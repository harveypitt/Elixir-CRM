defmodule Capclearv1Web.UserAuth do
  use Capclearv1Web, :verified_routes

  import Plug.Conn, except: [assign: 3]
  import Phoenix.Controller
  import Phoenix.Component

  alias Capclearv1.Accounts

  @max_age 60 * 60 * 24 * 60 # 60 days
  @remember_me_cookie "_capclearv1_web_user_remember_me"
  @remember_me_options [sign: true, max_age: @max_age, same_site: "Lax"]

  def log_in_user(conn, account, params \\ %{}) do
    token = Phoenix.Token.sign(Capclearv1Web.Endpoint, "user auth", account.id)
    user_return_to = get_session(conn, :user_return_to)

    conn
    |> renew_session()
    |> put_token_in_session(token)
    |> maybe_write_remember_me_cookie(token, params)
    |> redirect(to: user_return_to || signed_in_path(conn))
  end

  def log_out_user(conn) do
    if live_socket_id = get_session(conn, :live_socket_id) do
      Capclearv1Web.Endpoint.broadcast(live_socket_id, "disconnect", %{})
    end

    conn
    |> renew_session()
    |> delete_resp_cookie(@remember_me_cookie)
    |> redirect(to: ~p"/")
  end

  def fetch_current_account(conn, _opts) do
    {token, conn} = ensure_user_token(conn)
    account =
      with {:ok, account_id} <- Phoenix.Token.verify(Capclearv1Web.Endpoint, "user auth", token, max_age: @max_age) do
        Accounts.get_account!(account_id)
      else
        _ -> nil
      end
    Plug.Conn.assign(conn, :current_account, account)
  end

  def require_authenticated_user(conn, _opts) do
    if conn.assigns[:current_account] do
      conn
    else
      conn
      |> put_flash(:error, "You must log in to access this page.")
      |> redirect(to: ~p"/login")
      |> halt()
    end
  end

  def redirect_if_user_is_authenticated(conn, _opts) do
    if conn.assigns[:current_account] do
      conn
      |> redirect(to: ~p"/")
      |> halt()
    else
      conn
    end
  end

  def on_mount(:mount_current_account, _params, session, socket) do
    case session do
      %{"user_token" => user_token} ->
        {:cont, assign_new(socket, :current_account, fn ->
          case Phoenix.Token.verify(Capclearv1Web.Endpoint, "user auth", user_token, max_age: @max_age) do
            {:ok, account_id} -> Accounts.get_account!(account_id)
            _ -> nil
          end
        end)}

      %{} ->
        {:cont, assign_new(socket, :current_account, fn -> nil end)}
    end
  end

  def on_mount(:ensure_authenticated, _params, session, socket) do
    case session do
      %{"user_token" => user_token} ->
        case Phoenix.Token.verify(Capclearv1Web.Endpoint, "user auth", user_token, max_age: @max_age) do
          {:ok, account_id} ->
            {:cont, assign_new(socket, :current_account, fn -> Accounts.get_account!(account_id) end)}
          _ ->
            {:halt, redirect(socket, to: ~p"/login")}
        end

      %{} ->
        {:halt, redirect(socket, to: ~p"/login")}
    end
  end

  def on_mount(:redirect_if_authenticated, _params, session, socket) do
    case session do
      %{"user_token" => _user_token} ->
        {:halt, redirect(socket, to: signed_in_path(socket))}

      %{} ->
        {:cont, socket}
    end
  end

  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  defp maybe_write_remember_me_cookie(conn, token, %{"remember_me" => "true"}) do
    put_resp_cookie(conn, @remember_me_cookie, token, @remember_me_options)
  end

  defp maybe_write_remember_me_cookie(conn, _token, _params) do
    conn
  end

  defp ensure_user_token(conn) do
    if token = get_session(conn, :user_token) do
      {token, conn}
    else
      conn = fetch_cookies(conn, signed: [@remember_me_cookie])

      if token = conn.cookies[@remember_me_cookie] do
        {token, put_token_in_session(conn, token)}
      else
        {nil, conn}
      end
    end
  end

  defp put_token_in_session(conn, token) do
    conn
    |> put_session(:user_token, token)
    |> put_session(:live_socket_id, "users_sessions:#{Base.url_encode64(token)}")
  end

  defp signed_in_path(_conn), do: ~p"/"
end
