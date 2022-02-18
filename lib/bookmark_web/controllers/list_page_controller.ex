defmodule BookmarkWeb.ListPageController do
  use BookmarkWeb, :controller

  alias Bookmark.{Repo, Shortcode, Helpers}
  import Ecto.Query

  def index(conn, _params) do
    render(
      conn,
      "index.html",
      bookmark: Repo.all(from b in Shortcode, where: b.private == false, order_by: b.inserted_at)
    )
  end
end
