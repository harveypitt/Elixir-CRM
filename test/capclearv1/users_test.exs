defmodule Capclearv1.UsersTest do
  use Capclearv1.DataCase

  alias Capclearv1.Users
  alias Capclearv1.Accounts
  alias Capclearv1.Users.User

  describe "users" do
    @valid_account_attrs %{"email" => "test@example.com", "hashed_password" => "somehashedpassword"}
    @valid_attrs %{
      "first_name" => "John",
      "last_name" => "Doe",
      "gender" => "male",
      "phone" => "1234567890",
      "type" => "dietitian"
    }
    @update_attrs %{
      "first_name" => "Jane",
      "last_name" => "Smith",
      "phone" => "0987654321"
    }
    @invalid_attrs %{"first_name" => nil, "last_name" => nil, "type" => nil, "account_id" => nil}

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_account_attrs)
        |> Accounts.create_account()

      account
    end

    def user_fixture(attrs \\ %{}) do
      account = account_fixture()
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Map.put("account_id", account.id)
        |> Users.create_user()

      user
    end

    test "create_user_with_account/2 with valid data creates both user and account" do
      assert {:ok, %{account: account, user: user}} =
        Users.create_user_with_account(@valid_attrs, @valid_account_attrs)

      assert user.first_name == "John"
      assert user.last_name == "Doe"
      assert user.type == :dietitian
      assert account.email == "test@example.com"
    end

    test "create_user_with_account/2 with invalid user data returns error" do
      assert {:error, :user, %Ecto.Changeset{}, %{}} =
        Users.create_user_with_account(@invalid_attrs, @valid_account_attrs)
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      [listed_user] = Users.list_users()
      assert listed_user.id == user.id
      assert listed_user.first_name == user.first_name
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      found_user = Users.get_user!(user.id)
      assert found_user.id == user.id
      assert found_user.first_name == user.first_name
    end

    test "get_user_by_account/1 returns the user for given account" do
      user = user_fixture()
      found_user = Users.get_user_by_account(user.account_id)
      assert found_user.id == user.id
      assert found_user.account_id == user.account_id
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = updated_user} = Users.update_user(user, @update_attrs)
      assert updated_user.first_name == "Jane"
      assert updated_user.last_name == "Smith"
      assert updated_user.phone == "0987654321"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      found_user = Users.get_user!(user.id)
      assert user.first_name == found_user.first_name
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end
  end
end
