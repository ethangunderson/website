defmodule Website.OgImageTest do
  use ExUnit.Case, async: true

  alias Website.OgImage

  defp weight_covered?(css, weight) do
    ~r/font-weight:\s*(\d+)(?:\s+(\d+))?/
    |> Regex.scan(css, capture: :all_but_first)
    |> Enum.any?(fn
      [w] -> String.to_integer(w) == weight
      [lo, hi] -> weight in String.to_integer(lo)..String.to_integer(hi)
    end)
  end

  defp resource_refs(html) do
    ~r/(?:href|src)="([^"]*)"/
    |> Regex.scan(html, capture: :all_but_first)
    |> List.flatten()
  end

  describe "font_face_css/0" do
    test "embeds the typeface instead of fetching it" do
      css = OgImage.font_face_css()

      assert css =~ "data:font/woff2;base64,"
      assert Regex.scan(~r{https?://}, css) == []
    end

    test "covers every weight the templates ask for" do
      css = OgImage.font_face_css()

      for weight <- [600, 800] do
        assert weight_covered?(css, weight), "no @font-face covers weight #{weight}"
      end
    end
  end

  describe "coffee_html/3" do
    test "every resource reference is inline" do
      html =
        OgImage.coffee_html("Colombia Franky Hoyos", "PERC Coffee", "data:image/webp;base64,AAAA")

      refs = resource_refs(html)

      assert refs != []
      assert Enum.reject(refs, &String.starts_with?(&1, "data:")) == []
    end

    test "escapes markup in caller-supplied text" do
      html = OgImage.coffee_html("A & B <script>", "R>", nil)

      refute html =~ "<script>"
      assert html =~ "A &amp; B &lt;script&gt;"
      assert html =~ "R&gt;"
    end

    test "omits the image element when there is no image" do
      html = OgImage.coffee_html("T", "R", nil)

      refute html =~ "<img"
    end
  end

  describe "Website.OgImageLayout" do
    test "every resource reference is inline" do
      html = %{} |> Website.OgImageLayout.template() |> IO.iodata_to_binary()

      assert Enum.reject(resource_refs(html), &String.starts_with?(&1, "data:")) == []
    end
  end
end
