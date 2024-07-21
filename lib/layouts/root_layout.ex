defmodule Website.RootLayout do
  use Tableau.Layout
  use Phoenix.Component

  def template(assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="utf-8" />
        <meta http_equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />

        <meta property="og:title" content={@page[:title]} />
        <%= if @page[:image] do %>
          <meta property="og:image" content={@page[:image]} />
        <% end %>
        <%= if @page[:description] do %>
          <meta property="og:description" content={@page[:description]} />
        <% end %>
        <meta property="og:url" content={URI.merge(@site[:config].url, @page[:permalink])} />

        <title>
          <%= [@page[:title], "Ethan Gunderson"]
          |> Enum.filter(& &1)
          |> Enum.intersperse("|")
          |> Enum.join(" ") %>
        </title>

        <link rel="stylesheet" href="/css/site.css" />
      </head>

      <body class="w-1/3 mx-auto text-lg">
        <header class="flex flex-col space-y-3 mt-10">
          <nav class="w-full">
            <ul class="flex justify-end space-x-5 list-none underline">
              <li><a href="/">about</a></li>
              <li><a href="/writing">writing</a></li>
              <li><a href="/projects">projects</a></li>
            </ul>
          </nav>
          <div class="flex flex-col justify-start">
            <h1 class="font-bold text-2xl">
              <%= @page[:title] %>
            </h1>

            <%= if @page[:date] do %>
              <time class="text-sm">
                <%= @page.date |> Calendar.strftime("%b %d %Y") %>
              </time>
            <% end %>
          </div>
        </header>
        <main class="prose prose-lg max-w-full mt-10">
          <%= render(@inner_content) %>
        </main>
        <footer class="space-y-10 border-t-2 my-10">
          <ul class="list-none flex space-x-10 mt-10 underline">
            <li><a href="https://www.github.com/ethangunderson">github</a></li>
            <li><a href="https://www.linkedin.com/in/ethangunderson/">linkedin</a></li>
            <li><a href="mailto:ethan@ethangunderson.com">email</a></li>
          </ul>
          <div class="flex justify-between text-sm">
            <p>
              &copy; <%= Date.utc_today().year %> Ethan Gunderson
            </p>
            <p>
              <a class="underline" href="/feed.xml">RSS</a>
            </p>
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
