defmodule Bookmark.Repo.Migrations.ShortcodesAddCreatedByColumn do
  use Ecto.Migration

  def change do
    alter table("shortcodes") do
      add :created_by, :integer
    end

  end
end
