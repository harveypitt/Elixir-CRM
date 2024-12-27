defmodule Capclearv1.AccountsTest do
  use Capclearv1.DataCase

  alias Capclearv1.Accounts
  alias Capclearv1.Accounts.Account

  describe "accounts" do
    @valid_attrs %{email: "test@example.com", hashed_password: "somehashedpassword"}
    @update_attrs %{email: "updated@example.com"}
    @invalid_attrs %{email: nil, hashed_password: nil}

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_account()

      account
    end

    test "create_account/1 with valid data creates an account" do
      assert {:ok, %Account{} = account} = Accounts.create_account(@valid_attrs)
      assert account.email == "test@example.com"
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, %Account{} = account} = Accounts.update_account(account, @update_attrs)
      assert account.email == "updated@example.com"
    end

    test "get_account!/1 returns the account" do
      account = account_fixture()
      assert Accounts.get_account!(account.id) == account
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Accounts.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Accounts.change_account(account)
    end
  end
end
