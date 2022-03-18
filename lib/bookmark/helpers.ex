defmodule Bookmark.Helpers do
  alias Bookmark.{Repo, Shortcodes.ShortCode}

  def generate() do
    for _ <- 1..6, into: "", do: <<Enum.random('0123456789abcdef')>>
  end

  def code_to_url(path) do
    Repo.get_by(ShortCode, code: path)
  end
end
