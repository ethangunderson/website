defmodule Mix.Tasks.GenCoffeeOgImages do
  use Mix.Task

  @shortdoc "Generates composite OG images for coffee reviews"

  @chrome System.get_env("CHROME_PATH", "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome")

  def run(_args) do
    project_root = File.cwd!()
    output_dir = Path.join(project_root, "extra/images/og/coffee")
    File.mkdir_p!(output_dir)

    Path.wildcard(Path.join(project_root, "_coffee/*.md"))
    |> Enum.each(fn file ->
      slug = Path.basename(file, ".md")
      fm = parse_frontmatter(file)
      image_uri = build_image_uri(fm["image"], project_root)
      html = render_html(fm["title"] || slug, fm["roaster"] || "", image_uri)

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
    case File.read!(file) |> then(&Regex.run(~r/\A---\n(.*?)\n---/s, &1, capture: :all_but_first)) do
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

  defp escape(str) do
    str
    |> String.replace("&", "&amp;")
    |> String.replace("<", "&lt;")
    |> String.replace(">", "&gt;")
  end

  defp render_html(title, roaster, image_uri) do
    image_html =
      if image_uri,
        do: ~s(<img src="#{image_uri}" alt="#{escape(title)}" />),
        else: ""

    """
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <link rel="preconnect" href="https://fonts.googleapis.com">
      <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
      <link href="https://fonts.googleapis.com/css2?family=Inter:wght@600;800&display=swap" rel="stylesheet">
      <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        html, body { width: 1200px; height: 630px; overflow: hidden; }
        body {
          background: #f5f5f0;
          font-family: 'Inter', ui-sans-serif, system-ui, sans-serif;
          position: relative;
        }
        .card {
          position: absolute;
          top: 28px; left: 28px; right: 20px; bottom: 28px;
          border: 4px solid #111111;
          border-top-color: #e63000;
          background: #ffffff;
          display: flex;
          overflow: hidden;
        }
        .left {
          width: 54%;
          display: flex;
          flex-direction: column;
          justify-content: center;
          padding: 48px 56px;
        }
        .site-name {
          font-size: 46px;
          font-weight: 800;
          color: #111111;
          text-transform: uppercase;
          letter-spacing: -0.03em;
          line-height: 0.95;
          margin-bottom: 6px;
        }
        .site-subtitle {
          font-size: 11px;
          font-weight: 600;
          color: #888888;
          text-transform: uppercase;
          letter-spacing: 0.08em;
          line-height: 1.5;
        }
        .divider {
          width: 100%;
          height: 4px;
          background: #111111;
          margin: 22px 0;
        }
        .coffee-title {
          font-size: 34px;
          font-weight: 800;
          color: #111111;
          text-transform: uppercase;
          letter-spacing: -0.02em;
          line-height: 1.05;
          margin-bottom: 10px;
        }
        .roaster {
          font-size: 13px;
          font-weight: 600;
          color: #888888;
          text-transform: uppercase;
          letter-spacing: 0.09em;
        }
        .right {
          flex: 1;
          display: flex;
          align-items: center;
          justify-content: center;
          padding: 24px 32px 24px 0;
        }
        .right img {
          max-width: 100%;
          max-height: 100%;
          object-fit: contain;
        }
      </style>
    </head>
    <body>
      <div class="card">
        <div class="left">
          <div class="site-name">Ethan<br>Gunderson</div>
          <div class="site-subtitle">Software Engineer.<br>Author. Builder.</div>
          <div class="divider"></div>
          <div class="coffee-title">#{escape(title)}</div>
          <div class="roaster">#{escape(roaster)}</div>
        </div>
        <div class="right">#{image_html}</div>
      </div>
    </body>
    </html>
    """
  end
end
