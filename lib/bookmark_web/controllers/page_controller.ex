defmodule BookmarkWeb.PageController do
  use BookmarkWeb, :controller
  alias Bookmark.{Repo, Shortcode}
  import Ecto.Query


  def index(conn, _params) do
    render(
      conn,
      "index.html",
      bookmark: Repo.get(Shortcode, 1)
      )
  end
end
