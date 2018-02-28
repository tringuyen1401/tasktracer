defmodule Tasktracer.Repo.Migrations.AddFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :manager_id, references(:users)
    end

    create index(:users, [:manager_id])    
  end
end
