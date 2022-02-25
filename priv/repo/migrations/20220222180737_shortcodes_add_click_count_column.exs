defmodule Bookmark.Repo.Migrations.ShortcodesAddClickCountColumn do
  use Ecto.Migration

  def change do
    alter table("shortcodes") do
      add :click_count, :integer
    end
  end
end
