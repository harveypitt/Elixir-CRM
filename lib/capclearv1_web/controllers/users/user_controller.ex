defmodule Capclearv1Web.UserController do
  use Capclearv1Web, :controller

  alias Capclearv1.Users
  alias Capclearv1.Users.User
  alias Capclearv1.Contacts

  action_fallback Capclearv1Web.FallbackController

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, :index, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    {account_params, user_params} = Map.pop(user_params, "email")
    account_params = %{
      "email" => account_params || "",
      "hashed_password" => "temp_hash_#{account_params || ""}"
    }

    with {:ok, %{user: user}} <- Users.create_user_with_account(user_params, account_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def list_contacts(conn, %{"user_id" => id}) do
    user = Users.get_user!(id)

    case user.type do
      :dietitian ->
        contacts = Contacts.list_contacts_by_user_id(id)
        conn
        |> put_view(Capclearv1Web.ContactJSON)
        |> render(:index, contacts: contacts)
      _ ->
        conn
        |> put_status(:forbidden)
        |> json(%{error: "Only dietitians can have contacts"})
    end
  end
end
