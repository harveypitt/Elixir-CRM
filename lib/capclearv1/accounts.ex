defmodule Capclearv1.Accounts do
  @moduledoc """
  The Accounts context.
  Handles authentication and account management.
  """

  import Ecto.Query, warn: false
  alias Capclearv1.Repo
  alias Capclearv1.Accounts.Account

  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  def get_account!(id), do: Repo.get!(Account, id)

  def get_account_by_email(email) do
    Repo.get_by(Account, email: email)
  end

  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  def change_account(%Account{} = account, attrs \\ %{}) do
    Account.changeset(account, attrs)
  end
end
