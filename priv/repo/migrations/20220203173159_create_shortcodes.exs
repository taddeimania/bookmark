defmodule Bookmark.Repo.Migrations.CreateShortcodes do
  use Ecto.Migration

  def change do
    create table(:shortcodes) do
      add :title, :string
      add :code, :string
      add :url, :string

      timestamps()
    end
  end
end
