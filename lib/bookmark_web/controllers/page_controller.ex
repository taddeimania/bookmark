defmodule BookmarkWeb.PageController do
  use BookmarkWeb, :controller
  alias Bookmark.{Repo, Shortcode}
  import Ecto.Query


  def index(conn, _params) do
    render(
      conn,
      "index.html",
      bookmark: Repo.all(from b in Shortcode)
      )
  end

  def create(conn, params) do
    IO.inspect(params)

    %Shortcode{}
    |> Shortcode.changeset(%{"title" => params["title"], "url" => params["url"], "code" => params["code"]})
    |> Repo.insert()

    render(
      conn,
      "index.html",
      bookmark: Repo.all(from b in Shortcode)
    )
  end
end
