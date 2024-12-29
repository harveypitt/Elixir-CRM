defmodule Capclearv1Web.UserSessionController do
  use Capclearv1Web, :controller

  alias Capclearv1.Accounts
  alias Capclearv1Web.UserAuth

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if _existing_account = Accounts.get_account_by_email(email) do
      case Accounts.authenticate_account(email, password) do
        {:ok, account} ->
          UserAuth.log_in_user(conn, account)

        {:error, _reason} ->
          conn
          |> put_flash(:error, "Invalid email or password")
          |> redirect(to: ~p"/login")
      end
    else
      # Prevent timing attacks by simulating password check
      Bcrypt.no_user_verify()
      conn
      |> put_flash(:error, "Invalid email or password")
      |> redirect(to: ~p"/login")
    end
  end

  def delete(conn, _params) do
    conn
    |> UserAuth.log_out_user()
    |> redirect(to: ~p"/")
  end
end
