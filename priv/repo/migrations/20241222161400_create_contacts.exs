defmodule Capclearv1.Repo.Migrations.CreateContacts do
  use Ecto.Migration

  def change do
    create table(:contacts) do
      add :name, :string
      add :email, :string

      timestamps(type: :utc_datetime)
    end
  end
end
