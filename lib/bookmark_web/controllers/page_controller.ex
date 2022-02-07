defmodule BookmarkWeb.PageController do
  use BookmarkWeb, :controller
  alias Bookmark.{Repo, Shortcode, CodeGenerator}
  import Ecto.Query

  def index(conn, _params) do
    render(
      conn,
      "index.html",
      bookmark: Repo.all(from(b in Shortcode))
    )
  end

  def create(conn, params) do
    IO.inspect(params)

    code = CodeGenerator.generate()
    IO.inspect(code)

    %Shortcode{}
    |> Shortcode.changeset(%{"url" => params["url"], "code" => code})
    |> Repo.insert()

    redirect(conn, to: Routes.page_path(conn, :index))
  end
end
