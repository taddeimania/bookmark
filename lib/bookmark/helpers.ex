defmodule Bookmark.Helpers do
  alias Bookmark.{Repo, Shortcode}

  def generate() do
    for _ <- 1..6, into: "", do: <<Enum.random('0123456789abcdef')>>
  end

  def code_to_url(path) do
    Repo.get_by(Shortcode, code: path)
  end
end
