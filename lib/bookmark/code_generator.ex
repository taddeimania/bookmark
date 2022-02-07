defmodule Bookmark.CodeGenerator do
  def generate(nil), do: nil

  def generate() do
    s = for _ <- 1..6, into: "", do: <<Enum.random('0123456789abcdef')>>
    s
  end
end
