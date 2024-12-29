defmodule Capclearv1.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :email, :string
    field :hashed_password, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    has_one :user, Capclearv1.Users.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:email, :password, :password_confirmation])
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unique_constraint(:email)
    |> validate_password()
  end

  defp validate_password(changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      password ->
        changeset
        |> validate_length(:password, min: 8, max: 72)
        |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
        |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
        |> validate_format(:password, ~r/[!@#$%^&*(),.?":{}|<>]/, message: "at least one symbol")
        |> validate_confirmation(:password, message: "does not match password")
        |> put_change(:hashed_password, password)
    end
  end
end
