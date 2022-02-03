defmodule Bookmark.Shortcode do
  use Ecto.Schema
  import Ecto.Changeset

  schema "shortcodes" do
    field :code, :string
    field :title, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(shortcode, attrs) do
    shortcode
    |> cast(attrs, [:title, :code, :url])
    |> validate_required([:title, :code, :url])
  end
end
