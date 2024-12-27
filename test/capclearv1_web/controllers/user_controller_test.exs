defmodule Capclearv1Web.UserControllerTest do
  use Capclearv1Web.ConnCase

  import Capclearv1.AccountsFixtures

  alias Capclearv1.Users.User

  @create_attrs %{
    "first_name" => "John",
    "last_name" => "Doe",
    "gender" => "male",
    "phone" => "1234567890",
    "type" => "dietitian",
    "email" => "john.doe@example.com"
  }
  @update_attrs %{
    "first_name" => "Jane",
    "last_name" => "Smith",
    "phone" => "0987654321"
  }
  @invalid_attrs %{
    "first_name" => nil,
    "last_name" => nil,
    "type" => nil,
    "email" => nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, ~p"/api/users")
      assert json_response(conn, 200)["data"] == []
    end

    test "lists users with their accounts preloaded", %{conn: conn} do
      user = user_fixture()
      conn = get(conn, ~p"/api/users")
      assert [response] = json_response(conn, 200)["data"]
      assert response["email"] == user.account.email
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "first_name" => "John",
               "last_name" => "Doe",
               "gender" => "male",
               "phone" => "1234567890",
               "type" => "dietitian",
               "email" => "john.doe@example.com"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when email format is invalid", %{conn: conn} do
      attrs = Map.put(@create_attrs, "email", "invalid-email")
      conn = post(conn, ~p"/api/users", user: attrs)
      assert json_response(conn, 422)["errors"]["email"]
    end

    test "renders errors when email is already taken", %{conn: conn} do
      # Create first user
      post(conn, ~p"/api/users", user: @create_attrs)

      # Try to create second user with same email
      conn = post(conn, ~p"/api/users", user: @create_attrs)
      assert json_response(conn, 422)["errors"]["email"]
    end

    test "renders errors when type is invalid", %{conn: conn} do
      attrs = Map.put(@create_attrs, "type", "invalid_type")
      conn = post(conn, ~p"/api/users", user: attrs)
      assert json_response(conn, 422)["errors"]["type"]
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "first_name" => "Jane",
               "last_name" => "Smith",
               "phone" => "0987654321"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when partial data is invalid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user}", user: %{"first_name" => ""})
      assert json_response(conn, 422)["errors"]["first_name"]
    end

    test "preserves existing data when updating partial fields", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user}", user: %{"phone" => "9999999999"})
      assert response = json_response(conn, 200)["data"]
      assert response["first_name"] == user.first_name
      assert response["last_name"] == user.last_name
      assert response["phone"] == "9999999999"
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/api/users/#{user}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/users/#{user}")
      end
    end

    test "returns 404 when user doesn't exist", %{conn: conn} do
      assert_error_sent 404, fn ->
        delete(conn, ~p"/api/users/9999999")
      end
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end

  def valid_user_attributes(attrs \\ %{}) do
    attrs = Enum.into(attrs, %{
      "first_name" => "John",
      "last_name" => "Doe",
      "gender" => "male",
      "phone" => "1234567890",
      "type" => "dietitian",
      "email" => unique_user_email()
    })
  end
end
