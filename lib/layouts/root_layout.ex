defmodule Website.RootLayout do
  use Tableau.Layout
  use Phoenix.Component

  defp active_class(page, href) do
    permalink = page[:permalink] || ""

    if permalink == href do
      "nav-led nav-led-active font-semibold text-parchment"
    else
      "nav-led no-underline hover:text-copper"
    end
  end

  def template(assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en" class="text-parchment">
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
        <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=Source+Serif+4:ital,opsz,wght@0,8..60,400;0,8..60,500;0,8..60,600;0,8..60,700;1,8..60,400;1,8..60,500&display=swap" rel="stylesheet" />

        <link rel="stylesheet" href="/css/site.css" />
        <script src="https://tinylytics.app/embed/qsUQPD1PyV36tTZ7CVZn.js" defer></script>
      </head>

      <body class="bg-walnut px-10 md:px-0 w-full max-w-2xl mx-auto text-lg font-body">
        <header class="pt-20 mb-16">
          <nav class="flex justify-between items-baseline mb-10">
            <a href="/" class="no-underline hover:no-underline">
              <h1 class="font-heading text-3xl text-parchment">Ethan Gunderson</h1>
              <p class="text-sm text-grille mt-1 font-heading tracking-wide uppercase">Principal Engineer. Author. Builder.</p>
            </a>
            <ul class="flex space-x-5 list-none text-base font-heading">
              <li><a href="/" class={active_class(@page, "/")}>about</a></li>
              <li><a href="/writing" class={active_class(@page, "/writing")}>writing</a></li>
              <li><a href="/projects" class={active_class(@page, "/projects")}>projects</a></li>
              <li><a href="/now" class={active_class(@page, "/now")}>now</a></li>
              <li><a href="/uses" class={active_class(@page, "/uses")}>uses</a></li>
            </ul>
          </nav>
          <div class="flex flex-col justify-start">
            <%= if !@page[:hide_title] do %>
              <h1 class="font-heading font-normal text-3xl mb-10">
                <%= @page[:title] %>
              </h1>
            <% end %>

            <%= if @page[:date] do %>
              <time class="text-sm text-grille font-mono">
                <%= @page.date |> Calendar.strftime("%b %d %Y") %>
              </time>
            <% end %>
          </div>
        </header>
        <main class="prose prose-xl sm:my-0 max-w-full">
          <%= render(@inner_content) %>
        </main>
        <footer class="border-grain border-t mt-16 pt-10 pb-10" style="border-top: 3px double #3d352e;">
          <div class="flex justify-between">
            <ul class="list-none space-y-1 text-base">
              <li><a href="https://www.github.com/ethangunderson">Github</a></li>
              <li><a href="https://bsky.app/profile/ethangunderson.com">Bluesky</a></li>
              <li><a href="https://www.linkedin.com/in/ethangunderson/">LinkedIn</a></li>
              <li><a href="mailto:ethan@ethangunderson.com">Email</a></li>
            </ul>
            <div class="text-base text-right">
              <p class="text-grille">&copy; Ethan Gunderson</p>
              <p><a href="/feed.xml">RSS</a></p>
            </div>
          </div>
        </footer>
      </body>

      <%= if Mix.env() == :dev do %>
        <%= Phoenix.HTML.raw(Tableau.live_reload(assigns)) %>
      <% end %>
    </html>
    """
    |> Phoenix.HTML.Safe.to_iodata()
  end
end
