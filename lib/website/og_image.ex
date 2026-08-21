defmodule Website.OgImage do
  @moduledoc """
  Pure HTML templates for the Open Graph screenshot pipeline.

  Every asset these pages reference is inlined. Headless Chrome captures
  whatever is painted when the screenshot fires, so an external font or
  image silently renders as a fallback instead of failing — inlining is
  what makes the output deterministic.
  """

  @font_path Path.expand("../../priv/fonts/inter-latin.woff2", __DIR__)
  @external_resource @font_path
  @inter_woff2 @font_path |> File.read!() |> Base.encode64()

  @doc """
  `@font-face` rule embedding Inter as a data URI.

  Inter is a variable font, so one file serves the whole 100-900 axis.
  """
  def font_face_css do
    """
    @font-face {
      font-family: 'Inter';
      font-style: normal;
      font-weight: 100 900;
      src: url(data:font/woff2;base64,#{@inter_woff2}) format('woff2');
    }
    """
  end

  @doc """
  Renders the coffee review OG card. `image_uri` is a data URI or nil.
  """
  def coffee_html(title, roaster, image_uri) do
    image_html =
      if image_uri,
        do: ~s(<img src="#{image_uri}" alt="#{escape(title)}" />),
        else: ""

    """
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <style>
        #{font_face_css()}
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

  defp escape(str) do
    str
    |> String.replace("&", "&amp;")
    |> String.replace("<", "&lt;")
    |> String.replace(">", "&gt;")
  end
end
