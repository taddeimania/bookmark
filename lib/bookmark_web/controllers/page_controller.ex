defmodule BookmarkWeb.PageController do
  use BookmarkWeb, :controller

  alias Bookmark.{Repo, Shortcodes.ShortCode, Helpers}
  import Ecto.Query

  def index(conn, _params) when conn.assigns.current_user |> is_nil() do
    render(
      conn,
      "nonlogged_index.html",
      bookmark:
        Repo.all(
          from b in ShortCode, where: b.private == false, order_by: b.inserted_at, limit: 5
        )
    )
  end

  def index(conn, _params) do
    render(
      conn,
      "index.html",
      page_number: 0,
      bookmark: Repo.all(from b in ShortCode, order_by: b.inserted_at, limit: 5)
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
    ptbd = Repo.get(ShortCode, params["to_be_deleted"])

    if ptbd.created_by == user_id do
      query = Repo.get_by(ShortCode, id: params["to_be_deleted"])
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

    %ShortCode{}
    |> ShortCode.changeset(%{
      "url" => params["url"],
      "code" => code,
      "created_by" => user_id,
      "private" => false,
      "click_count" => 0
    })
    |> Repo.insert()

    redirect(conn, to: Routes.page_path(conn, :index))
  end

  def redirector(conn, params) do
    increment_count(conn, params)
    url = params["url"]
    redirect(conn, external: url)
  end

  def toggle_privates(conn, _params) when conn.assigns.current_user |> is_nil() do
    conn
    |> put_flash(:error, "Gotta log in to do that.")
    |> redirect(to: "/")
  end

  def toggle_privates(conn, params) do
    record = Repo.get(ShortCode, params["shortcode_id"])

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
        "Date Descending" ->
          Repo.all(from b in ShortCode, order_by: [desc: b.inserted_at])

        "Date Ascending" ->
          Repo.all(from b in ShortCode, order_by: [asc: b.inserted_at])
      end

    render(
      conn,
      "index.html",
      bookmark: query
    )
  end

  def increment_count(_conn, params) do
    item = Repo.get!(ShortCode, params["id"])
    item = Ecto.Changeset.change(item, click_count: String.to_integer(params["count"]) + 1)
    Repo.update(item)
  end

  def change_page(conn, params) do
    page_up = params["page_up"]

    new_page_number =
      if page_up == "1" do
        String.to_integer(params["page"]) + 1
      else
        String.to_integer(params["page"]) - 1
      end

    offset = 5 * new_page_number

    query = Repo.all(from b in ShortCode, limit: 5, offset: ^offset)

    render(
      conn,
      "index.html",
      page_number: new_page_number,
      bookmark: query,
      page_up: page_up
    )
  end
end
