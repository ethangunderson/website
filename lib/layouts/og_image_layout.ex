defmodule Website.OgImageLayout do
  use Tableau.Layout
  use Phoenix.Component
  import Website.Component

  def template(assigns) do
    ~H"""
    <!DOCTYPE html>
    <html>
      <head>
        <meta charset="utf-8" />
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
        <link
          href="https://fonts.googleapis.com/css2?family=Inter:wght@600;800&display=swap"
          rel="stylesheet"
        />
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
            align-items: center;
            padding: 0 80px;
          }
          .og-name {
            font-size: 96px;
            font-weight: 800;
            color: #111111;
            text-transform: uppercase;
            letter-spacing: -0.03em;
            line-height: 0.95;
            margin-bottom: 20px;
          }
          .og-subtitle {
            font-size: 21px;
            font-weight: 600;
            color: #888888;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            line-height: 1.5;
          }
        </style>
      </head>
      <body>
        <div class="card">
          <div>
            <.site_header name_class="og-name" subtitle_class="og-subtitle" />
          </div>
        </div>
      </body>
    </html>
    """
    |> Phoenix.HTML.Safe.to_iodata()
  end
end
