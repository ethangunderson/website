defmodule Website.RootLayout do
  use Tableau.Layout
  use Phoenix.Component

  defp active_class(page, href) do
    if (page[:permalink] || "") == href,
      do: "border-accent text-accent",
      else: "border-transparent"
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
        <meta property="og:description" content={@page[:description] || "Software engineer, author, and builder. Writing about observability, Elixir, and building software."} />
        <meta name="description" content={@page[:description] || "Software engineer, author, and builder. Writing about observability, Elixir, and building software."} />
        <meta property="og:url" content={URI.merge(@site[:config].url, @page[:permalink])} />
        <meta name="twitter:card" content="summary" />

        <title>
          <%= if @page[:title] == "Ethan Gunderson" do %>
            <%= "Ethan Gunderson — Software Engineer, Author, Builder" %>
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

      <body class="bg-site-bg text-ink font-sans text-[17px] leading-relaxed">
        <%# Fixed 4px red-orange accent bar across the very top %>
        <div class="fixed top-0 left-0 right-0 h-1 bg-accent z-50"></div>

        <%# Two-column grid — stacks to single column on mobile %>
        <div class="grid grid-cols-1 md:grid-cols-layout min-h-screen pt-1">

          <%# Sidebar %>
          <aside class="bg-sidebar-bg border-b-4 border-ink md:border-b-0 md:border-r-4 md:sticky md:top-1 md:h-[calc(100vh-4px)] p-6 md:p-10 flex flex-col overflow-y-auto">

            <div class="mb-8">
              <a href="/" class="no-underline hover:no-underline text-ink hover:text-ink block">
                <p class="text-2xl font-extrabold uppercase leading-[1.05] tracking-tight mb-2">
                  Ethan<br />Gunderson
                </p>
                <p class="text-[0.72rem] text-muted uppercase tracking-wider leading-snug">
                  Software Engineer.<br />Author. Builder.
                </p>
              </a>
            </div>

            <div class="border-t-4 border-ink mb-6"></div>

            <nav>
              <ul class="list-none p-0 m-0 flex flex-row flex-wrap gap-1 md:flex-col md:gap-0">
                <li>
                  <a href="/" class={["block py-2 px-3 text-[0.78rem] font-bold uppercase tracking-[0.09em] text-ink no-underline border-l-4 transition-colors duration-75 hover:border-accent hover:text-accent", active_class(@page, "/")]}>
                    About
                  </a>
                </li>
                <li>
                  <a href="/writing" class={["block py-2 px-3 text-[0.78rem] font-bold uppercase tracking-[0.09em] text-ink no-underline border-l-4 transition-colors duration-75 hover:border-accent hover:text-accent", active_class(@page, "/writing")]}>
                    Writing
                  </a>
                </li>
                <li>
                  <a href="/projects" class={["block py-2 px-3 text-[0.78rem] font-bold uppercase tracking-[0.09em] text-ink no-underline border-l-4 transition-colors duration-75 hover:border-accent hover:text-accent", active_class(@page, "/projects")]}>
                    Projects
                  </a>
                </li>
                <li>
                  <a href="/media" class={["block py-2 px-3 text-[0.78rem] font-bold uppercase tracking-[0.09em] text-ink no-underline border-l-4 transition-colors duration-75 hover:border-accent hover:text-accent", active_class(@page, "/media")]}>
                    Media
                  </a>
                </li>
                <li>
                  <a href="/now" class={["block py-2 px-3 text-[0.78rem] font-bold uppercase tracking-[0.09em] text-ink no-underline border-l-4 transition-colors duration-75 hover:border-accent hover:text-accent", active_class(@page, "/now")]}>
                    Now
                  </a>
                </li>
                <li>
                  <a href="/atlas" class={["block py-2 px-3 text-[0.78rem] font-bold uppercase tracking-[0.09em] text-ink no-underline border-l-4 transition-colors duration-75 hover:border-accent hover:text-accent", active_class(@page, "/atlas")]}>
                    Atlas
                  </a>
                </li>
              </ul>
            </nav>
          </aside>

          <%# Content column %>
          <div class="flex flex-col p-6 md:px-16 md:py-12">
            <main class="flex-1">
              <%= if !@page[:hide_title] do %>
                <h1 class="text-[2.25rem] font-extrabold uppercase tracking-tight leading-[1.1] mb-6 pb-4 border-b-4 border-ink">
                  <%= @page[:title] %>
                </h1>
              <% end %>

              <%= if @page[:date] do %>
                <time class="block text-[0.75rem] text-muted font-semibold uppercase tracking-[0.07em] mb-8">
                  <%= @page.date |> Calendar.strftime("%b %d %Y") %>
                </time>
              <% end %>

              <div class="prose text-base">
                <%= render(@inner_content) %>
              </div>
            </main>

            <footer class="border-t-4 border-ink mt-16 pt-8">
              <ul class="list-none p-0 m-0 flex gap-6 flex-wrap mb-3">
                <li><a href="https://www.github.com/ethangunderson" class="text-[0.78rem] font-bold uppercase tracking-[0.07em] no-underline text-ink hover:text-accent">Github</a></li>
                <li><a href="https://bsky.app/profile/ethangunderson.com" class="text-[0.78rem] font-bold uppercase tracking-[0.07em] no-underline text-ink hover:text-accent">Bluesky</a></li>
                <li><a href="https://www.linkedin.com/in/ethangunderson/" class="text-[0.78rem] font-bold uppercase tracking-[0.07em] no-underline text-ink hover:text-accent">LinkedIn</a></li>
                <li><a href="mailto:ethan@ethangunderson.com" class="text-[0.78rem] font-bold uppercase tracking-[0.07em] no-underline text-ink hover:text-accent">Email</a></li>
                <li><a href="/feed.xml" class="text-[0.78rem] font-bold uppercase tracking-[0.07em] no-underline text-ink hover:text-accent">RSS</a></li>
              </ul>
              <p class="text-[0.78rem] text-muted m-0">&copy; Ethan Gunderson</p>
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
