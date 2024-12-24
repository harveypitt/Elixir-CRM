defmodule Capclearv1.Contacts.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contacts" do
    field :name, :string
    field :email, :string
    belongs_to :user, Capclearv1.Accounts.User
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(contact, attrs) do
    contact
    |> cast(attrs, [:name, :email, :user_id])
    |> validate_required([:name, :email])
  end
end
