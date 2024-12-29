defmodule Capclearv1.Contacts.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contacts" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :phone, :string

    belongs_to :user, Capclearv1.Accounts.User
    # has_many :receipts, Capclearv1.Receipts.Receipt

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(contact, attrs) do
    contact
    |> cast(attrs, [:first_name, :last_name, :email, :phone, :user_id])
    |> validate_required([:first_name, :last_name, :email, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
