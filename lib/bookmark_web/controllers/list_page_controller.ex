defmodule BookmarkWeb.ListPageController do
  use BookmarkWeb, :controller

  alias Bookmark.{Repo, Shortcodes.ShortCode, Helpers}
  import Ecto.Query

  def index(conn, _params) do
    render(
      conn,
      "index.html",
      bookmark: Repo.all(from b in ShortCode, where: b.private == false, order_by: b.inserted_at)
    )
  end

  def sort_order_by(conn, params) do
    query =
      case params["sort_term"] do
        "All" ->
          Repo.all(from b in ShortCode, order_by: [desc: b.inserted_at])

        "Current User" ->
          Repo.all(
            from b in ShortCode,
              where: b.created_by == ^conn.assigns.current_user.id,
              order_by: [desc: b.inserted_at]
          )

        "Popularity" ->
          Repo.all(from b in ShortCode, order_by: [desc: b.click_count], limit: 10)
      end

    render(
      conn,
      "index.html",
      bookmark: query
    )

    redirect(conn, to: Routes.page_path(conn, :index))
  end
end
