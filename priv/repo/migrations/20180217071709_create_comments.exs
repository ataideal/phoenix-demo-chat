defmodule Chatdemo.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :username, :string
      add :text, :string

      timestamps()
    end

  end
end
