defmodule Website.RootLayout do
  use Tableau.Layout
  use Phoenix.Component

  defp active_class(page, href) do
    permalink = page[:permalink] || ""

    if permalink == href do
      "nav-active"
    else
      ""
    end
  end

  def template(assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="utf-8" />
        <meta http_equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />

        <meta property="og:title" content={@page[:og_title] || @page[:title] || "Ethan Gunderson"} />
        <meta property="og:site_name" content="Ethan Gunderson" />
        <meta property="og:type" content={if @page[:date], do: "article", else: "website"} />
        <%= if @page[:image] do %>
          <meta property="og:image" content={@page[:image]} />
        <% end %>
        <meta property="og:description" content={@page[:description] || "Principal engineer, author, and builder. Writing about observability, Elixir, and building software."} />
        <meta name="description" content={@page[:description] || "Principal engineer, author, and builder. Writing about observability, Elixir, and building software."} />
        <meta property="og:url" content={URI.merge(@site[:config].url, @page[:permalink])} />
        <meta name="twitter:card" content="summary" />

        <title>
          <%= if @page[:title] == "Ethan Gunderson" do %>
            <%= "Ethan Gunderson — Principal Engineer, Author, Builder" %>
          <% else %>
            <%= [@page[:title], "Ethan Gunderson"]
            |> Enum.filter(& &1)
            |> Enum.intersperse("|")
            |> Enum.join(" ") %>
          <% end %>
        </title>

        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet" />

        <link rel="stylesheet" href="/css/site.css" />
        <script src="https://tinylytics.app/embed/qsUQPD1PyV36tTZ7CVZn.js" defer></script>
      </head>

      <body>
        <div class="accent-bar"></div>

        <div class="site-wrapper">
          <aside class="sidebar">
            <div class="sidebar-name">
              <a href="/">
                <p class="site-name">Ethan<br />Gunderson</p>
                <p class="site-tagline">Principal Engineer.<br />Author. Builder.</p>
              </a>
            </div>

            <hr class="sidebar-divider" />

            <nav class="sidebar-nav">
              <ul>
                <li><a href="/" class={active_class(@page, "/")}>About</a></li>
                <li><a href="/writing" class={active_class(@page, "/writing")}>Writing</a></li>
                <li><a href="/projects" class={active_class(@page, "/projects")}>Projects</a></li>
                <li><a href="/now" class={active_class(@page, "/now")}>Now</a></li>
                <li><a href="/uses" class={active_class(@page, "/uses")}>Uses</a></li>
              </ul>
            </nav>
          </aside>

          <div class="content-col">
            <main class="content-main">
              <%= if !@page[:hide_title] do %>
                <h1 class="page-title"><%= @page[:title] %></h1>
              <% end %>

              <%= if @page[:date] do %>
                <time class="post-date">
                  <%= @page.date |> Calendar.strftime("%b %d %Y") %>
                </time>
              <% end %>

              <div class="prose">
                <%= render(@inner_content) %>
              </div>
            </main>

            <footer class="site-footer">
              <ul class="footer-links">
                <li><a href="https://www.github.com/ethangunderson">Github</a></li>
                <li><a href="https://bsky.app/profile/ethangunderson.com">Bluesky</a></li>
                <li><a href="https://www.linkedin.com/in/ethangunderson/">LinkedIn</a></li>
                <li><a href="mailto:ethan@ethangunderson.com">Email</a></li>
                <li><a href="/feed.xml">RSS</a></li>
              </ul>
              <p class="footer-meta">&copy; Ethan Gunderson</p>
            </footer>
          </div>
        </div>
      </body>

      <%= if Mix.env() == :dev do %>
        <%= Phoenix.HTML.raw(Tableau.live_reload(assigns)) %>
      <% end %>
    </html>
    """
    |> Phoenix.HTML.Safe.to_iodata()
  end
end
