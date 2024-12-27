defmodule Capclearv1.Users do
  @moduledoc """
  The Users context.
  Handles user profiles and user-specific operations.
  """

  import Ecto.Query, warn: false
  alias Capclearv1.Repo
  alias Capclearv1.Users.User
  alias Capclearv1.Accounts

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def create_user_with_account(user_attrs, account_attrs) do
    Ecto.Multi.new()
    |> Ecto.Multi.run(:account, fn _repo, _changes ->
      Accounts.create_account(account_attrs)
    end)
    |> Ecto.Multi.insert(:user, fn %{account: account} ->
      user_attrs = case user_attrs["type"] do
        type when is_binary(type) ->
          Map.put(user_attrs, "type", String.to_existing_atom(type))
        _ ->
          user_attrs
      end
      user_attrs = Map.put(user_attrs, "account_id", account.id)
      User.changeset(%User{}, user_attrs)
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user} = result} ->
        {:ok, Map.put(result, :user, Repo.preload(user, :account))}
      error ->
        error
    end
  end

  def list_users do
    User
    |> Repo.all()
    |> Repo.preload(:account)
  end

  def get_user!(id) do
    User
    |> Repo.get!(id)
    |> Repo.preload(:account)
  end

  def get_user_by_account(account_id) do
    User
    |> Repo.get_by(account_id: account_id)
    |> Repo.preload(:account)
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, user} -> {:ok, Repo.preload(user, :account)}
      error -> error
    end
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
