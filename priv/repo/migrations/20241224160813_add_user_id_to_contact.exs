defmodule Capclearv1.Repo.Migrations.AddUserIdToContact do
  use Ecto.Migration

  def change do
    alter table(:contacts) do
      add :user_id, references(:users, on_delete: :nothing)
    end
  end
end
