defmodule Capclearv1.Repo.Migrations.UpdateContactsTableStructure do
  use Ecto.Migration

  def change do
    alter table(:contacts) do
      # Remove the old name field
      remove :name

      # Add new fields
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :phone, :string

      # Ensure email is not null
      modify :email, :string, null: false
    end

    # Add indexes for common queries
    create index(:contacts, [:user_id])
    create index(:contacts, [:email])
  end
end
