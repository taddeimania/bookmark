defmodule Bookmark.Shortcodes do
  @moduledoc """
  The Shortcodes context.
  """

  import Ecto.Query, warn: false
  alias Bookmark.Repo
  alias Bookmark.Shortcodes.ShortCode

  def list_shortcodes() do
    Repo.all(from b in ShortCode, order_by: [desc: b.inserted_at])
  end

  def list_public_shortcodes() do
    Repo.all(from b in ShortCode, where: b.private == false, order_by: b.inserted_at)
  end

  def list_popular_shortcodes() do
    Repo.all(from b in ShortCode, order_by: [desc: b.click_count], limit: 10)
  end

  def list_shortcodes_for_user_id(user_id) do
    Repo.all(
      from b in ShortCode,
        where: b.created_by == ^user_id,
        order_by: [desc: b.inserted_at]
    )
  end
end
