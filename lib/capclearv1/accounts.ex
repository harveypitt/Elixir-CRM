defmodule Capclearv1.Accounts do
  @moduledoc """
  The Accounts context.
  Handles authentication and account management.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias Capclearv1.Repo
  alias Capclearv1.Accounts.Account

  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> hash_password()
    |> Repo.insert()
  end

  def get_account!(id), do: Repo.get!(Account, id)

  def get_account_by_email(email) do
    Repo.get_by(Account, email: email)
  end

  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> hash_password()
    |> Repo.update()
  end

  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  def change_account(%Account{} = account, attrs \\ %{}) do
    Account.changeset(account, attrs)
  end

  def authenticate_account(email, password) do
    account = get_account_by_email(email)

    cond do
      account && Bcrypt.verify_pass(password, account.hashed_password) ->
        {:ok, account}

      account ->
        {:error, :unauthorized}

      true ->
        # Prevent timing attacks by simulating password check
        Bcrypt.no_user_verify()
        {:error, :not_found}
    end
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{hashed_password: password}} = changeset) do
    change(changeset, hashed_password: Bcrypt.hash_pwd_salt(password))
  end

  defp hash_password(changeset), do: changeset
end
