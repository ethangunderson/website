defmodule Website.MediaCollectionTest do
  use ExUnit.Case, async: true

  alias Website.Media

  @root Path.expand("../..", __DIR__)
  @agreed_types ~w(book game album movie tv)

  defp entries do
    @root
    |> Path.join("_media/*.md")
    |> Path.wildcard()
    |> Enum.map(fn file ->
      [yaml] =
        Regex.run(~r/\A---\n(.*?)\n---/s, File.read!(file), capture: :all_but_first)

      {Path.basename(file, ".md"), YamlElixir.read_from_string!(yaml)}
    end)
  end

  test "types/0 is exactly the agreed set" do
    assert Enum.sort(Media.types()) == Enum.sort(@agreed_types)
  end

  test "every entry has a known type" do
    unknown = for {slug, fm} <- entries(), fm["type"] not in Media.types(), do: {slug, fm["type"]}

    assert unknown == []
  end

  test "every entry's image exists under extra/" do
    missing =
      for {slug, fm} <- entries(),
          not File.exists?(Path.join([@root, "extra", fm["image"] || ""])),
          do: {slug, fm["image"]}

    assert missing == []
  end

  test "every entry's filename matches its permalink" do
    mismatched =
      for {slug, fm} <- entries(),
          Path.basename(fm["permalink"] || "") != slug,
          do: {slug, fm["permalink"]}

    assert mismatched == []
  end
end
