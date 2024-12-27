defmodule Capclearv1.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :gender, :string
    field :phone, :string
    field :type, :string

    belongs_to :account, Capclearv1.Accounts.Account
    has_many :contacts, Capclearv1.Contacts.Contact
    # We'll add chat_thread association later when we implement that part

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :gender, :phone, :type, :account_id])
    |> validate_required([:first_name, :last_name, :type, :account_id])
    |> foreign_key_constraint(:account_id)
  end
end
