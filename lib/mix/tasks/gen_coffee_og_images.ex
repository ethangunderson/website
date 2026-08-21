defmodule Mix.Tasks.GenCoffeeOgImages do
  use Mix.Task

  @shortdoc "Generates composite OG images for coffee reviews"

  @chrome System.get_env(
            "CHROME_PATH",
            "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
          )

  def run(_args) do
    project_root = File.cwd!()
    output_dir = Path.join(project_root, "extra/images/og/coffee")
    File.mkdir_p!(output_dir)

    Path.wildcard(Path.join(project_root, "_coffee/*.md"))
    |> Enum.each(fn file ->
      slug = Path.basename(file, ".md")
      fm = parse_frontmatter(file)
      image_uri = build_image_uri(fm["image"], project_root)
      html = Website.OgImage.coffee_html(fm["title"] || slug, fm["roaster"] || "", image_uri)

      tmp = Path.join(System.tmp_dir!(), "og-coffee-#{slug}.html")
      output = Path.join(output_dir, "#{slug}.png")

      File.write!(tmp, html)
      screenshot(tmp, output)
      File.rm!(tmp)

      Mix.shell().info("  #{slug}.png")
    end)

    Mix.shell().info("Done.")
  end

  defp parse_frontmatter(file) do
    case File.read!(file)
         |> then(&Regex.run(~r/\A---\n(.*?)\n---/s, &1, capture: :all_but_first)) do
      [yaml] ->
        Regex.scan(~r/^([\w_-]+):\s*(.+)$/m, yaml)
        |> Enum.reduce(%{}, fn [_, k, v], acc -> Map.put(acc, k, strip_quotes(v)) end)

      _ ->
        %{}
    end
  end

  defp strip_quotes(v) do
    v = String.trim(v)

    if String.starts_with?(v, "\"") && String.ends_with?(v, "\""),
      do: String.slice(v, 1..-2//1),
      else: v
  end

  defp build_image_uri(nil, _root), do: nil
  defp build_image_uri("", _root), do: nil

  defp build_image_uri(path, root) do
    local = Path.join([root, "extra", path])

    case File.read(local) do
      {:ok, data} ->
        mime = path |> Path.extname() |> String.trim_leading(".") |> mime_type()
        "data:#{mime};base64,#{Base.encode64(data)}"

      {:error, _} ->
        nil
    end
  end

  defp mime_type("webp"), do: "image/webp"
  defp mime_type("jpg"), do: "image/jpeg"
  defp mime_type("jpeg"), do: "image/jpeg"
  defp mime_type("png"), do: "image/png"
  defp mime_type(_), do: "image/jpeg"

  defp screenshot(html_file, output) do
    System.cmd(
      @chrome,
      [
        "--headless=new",
        "--disable-gpu",
        "--no-sandbox",
        "--screenshot=#{output}",
        "--window-size=1200,630",
        "--hide-scrollbars",
        "--force-device-scale-factor=1",
        "--run-all-compositor-stages-before-draw",
        "file://#{html_file}"
      ],
      stderr_to_stdout: true
    )
  end
end
