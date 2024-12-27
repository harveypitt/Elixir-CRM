defmodule Capclearv1.Repo.Migrations.RestructureUsersAndCreateAccounts do
  use Ecto.Migration

  def change do
    # Create accounts table
    create table(:accounts) do
      add :email, :string, null: false
      add :hashed_password, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:accounts, [:email])

    # Create temporary accounts for existing users
    execute """
    INSERT INTO accounts (email, hashed_password, inserted_at, updated_at)
    SELECT email, 'temporary_password', NOW(), NOW()
    FROM users
    WHERE email IS NOT NULL
    """

    # Add new columns to users table
    alter table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :gender, :string
      add :phone, :string
      add :type, :string
      add :account_id, references(:accounts, on_delete: :delete_all)
    end

    # Link existing users to their accounts
    execute """
    UPDATE users u
    SET account_id = a.id,
        first_name = COALESCE(name, 'Unknown'),
        last_name = 'User'
    FROM accounts a
    WHERE a.email = u.email
    """

    # Remove old columns and make account_id non-null
    execute "ALTER TABLE users DROP COLUMN email"
    execute "ALTER TABLE users DROP COLUMN name"
    execute "ALTER TABLE users ALTER COLUMN account_id SET NOT NULL"

    create index(:users, [:account_id])
  end
end
