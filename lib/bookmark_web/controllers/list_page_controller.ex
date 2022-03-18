defmodule BookmarkWeb.ListPageController do
  use BookmarkWeb, :controller

  alias Bookmark.{Repo, Shortcodes, Shortcodes.ShortCode, Helpers}
  import Ecto.Query

  def index(conn, _params) do
    render(
      conn,
      "index.html",
      bookmark: Shortcodes.list_public_shortcodes()
    )
  end

  def sort_order_by(conn, params) do
    query =
      case params["sort_term"] do
        "All" ->
          Shortcodes.list_shortcodes()

        "Current User" ->
          Shortcodes.list_shortcodes_for_user_id(conn.assigns.current_user.id)

        "Popularity" ->
          Shortcodes.list_popular_shortcodes()
      end

    render(
      conn,
      "index.html",
      bookmark: query
    )

    redirect(conn, to: Routes.page_path(conn, :index))
  end
end
