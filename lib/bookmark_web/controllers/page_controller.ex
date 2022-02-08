defmodule BookmarkWeb.PageController do
  use BookmarkWeb, :controller
  alias Bookmark.{Repo, Shortcode, Helpers}
  import Ecto.Query

  def index(conn, _params) do
    render(
      conn,
      "index.html",
      bookmark: Repo.all(from(b in Shortcode))
    )
  end

  def delete(conn, params) do
    query = Repo.get_by(Shortcode, id: params["to_be_deleted"])
    Repo.delete(query)

    redirect(conn, to: Routes.page_path(conn, :index))

  end

  def create(conn, params) do
    code = Helpers.generate()

    %Shortcode{}
    |> Shortcode.changeset(%{"url" => params["url"], "code" => code})
    |> Repo.insert()

    redirect(conn, to: Routes.page_path(conn, :index))
  end

  def redirector(conn, params) do
    url = Helpers.code_to_url(params["page"])
    redirect(conn, external: url.url)
  end
end
