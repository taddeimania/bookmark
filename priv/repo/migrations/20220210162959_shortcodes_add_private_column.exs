defmodule Bookmark.Repo.Migrations.ShortcodesAddPrivateColumn do
  use Ecto.Migration

  def change do
    alter table("shortcodes") do
      add :private, :boolean
    end
  end
end
