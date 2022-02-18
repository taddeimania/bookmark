defmodule BookmarkWeb.PageController do
  use BookmarkWeb, :controller

  alias Bookmark.{Repo, Shortcode, Helpers}
  import Ecto.Query

  def index(conn, _params) when conn.assigns.current_user |> is_nil() do
    render(
      conn,
      "nonlogged_index.html",
      bookmark: Repo.all(from b in Shortcode, where: b.private == false, order_by: b.inserted_at)
    )
  end

  def index(conn, _params) do
    render(
      conn,
      "index.html",
      bookmark: Repo.all(from b in Shortcode, order_by: b.inserted_at)
    )
  end

  # do i need to guard against nonlogged users now that the template doesn't show delete/private options?
  def delete(conn, _params) when conn.assigns.current_user |> is_nil() do
    conn
    |> put_flash(:error, "Don't touch that you non-logged in user, you.")
    |> redirect(to: "/")
  end

  def delete(conn, params) do
    user_id = conn.assigns.current_user.id
    ptbd = Repo.get(Shortcode, params["to_be_deleted"])

    if ptbd.created_by == user_id do
      query = Repo.get_by(Shortcode, id: params["to_be_deleted"])
      Repo.delete(query)
    else
      conn
      |> put_flash(:error, "Don't touch that it's somebody elses bookmark.")
      |> redirect(to: "/")
    end

    redirect(conn, to: Routes.page_path(conn, :index))
  end

  def create(conn, _params) when conn.assigns.current_user |> is_nil() do
    conn
    |> put_flash(:error, "Gotta log in to do that.")
    |> redirect(to: "/")
  end

  def create(conn, params) do
    code = Helpers.generate()
    user_id = conn.assigns.current_user.id

    %Shortcode{}
    |> Shortcode.changeset(%{
      "url" => params["url"],
      "code" => code,
      "created_by" => user_id,
      "private" => true
    })
    |> Repo.insert()

    redirect(conn, to: Routes.page_path(conn, :index))
  end

  def redirector(conn, params) do
    url = Helpers.code_to_url(params["page"])
    redirect(conn, external: url.url)
  end

  def toggle_privates(conn, _params) when conn.assigns.current_user |> is_nil() do
    conn
    |> put_flash(:error, "Gotta log in to do that.")
    |> redirect(to: "/")
  end

  def toggle_privates(conn, params) do
    record = Repo.get(Shortcode, params["shortcode_id"])

    if record.private do
      Ecto.Changeset.change(record, %{
        url: record.url,
        code: record.code,
        created_by: record.created_by,
        private: false
      })
    else
      Ecto.Changeset.change(record, %{
        url: record.url,
        code: record.code,
        created_by: record.created_by,
        private: true
      })
    end
    |> Repo.update()

    redirect(conn, to: Routes.page_path(conn, :index))
  end

  def sort_order_by(conn, params) do
    query =
      case params["sort_term"] do
        "Date Descending" -> Repo.all(from b in Shortcode, order_by: [desc: b.inserted_at])
        "Date Ascending" -> Repo.all(from b in Shortcode, order_by: [asc: b.inserted_at])
      end

    render(
      conn,
      "index.html",
      bookmark: query
    )

    redirect(conn, to: Routes.page_path(conn, :index))
  end
end
