defmodule Website.Media do
  @moduledoc """
  The vocabulary shared by `_media/` entries, their layout, and the
  `add-media-review` skill.
  """

  @types ~w(book game album movie tv)

  @doc "Every `type` value a `_media/` entry may carry."
  def types, do: @types
end
