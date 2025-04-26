defmodule Website.RootLayout do
  use Tableau.Layout
  use Phoenix.Component

  def template(assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en" class="text-gray-800">
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
        <script src="https://tinylytics.app/embed/qsUQPD1PyV36tTZ7CVZn.js" defer></script>
      </head>

      <body class="bg-[#e4e9e9] px-10 md:px-0 w-full sm:w-3/5 lg:w-2/5 mx-auto text-lg">
        <header class="flex flex-col space-y-3 pt-20">
          <nav class="flex justify-between mb-10 pb-5">
            <h1>Ethan Gunderson</h1>
            <ul class="flex justify-end space-x-5 list-none">
              <li><a href="/">about</a></li>
              <li><a href="/writing">writing</a></li>
              <li><a href="/projects">projects</a></li>
              <li><a href="/now">now</a></li>
            </ul>
          </nav>
          <div class="flex flex-col justify-start">
            <%= if !@page[:hide_title] do %>
              <h1 class="font-bold text-2xl mb-10">
                <%= @page[:title] %>
              </h1>
            <% end %>

            <%= if @page[:date] do %>
              <time class="text-sm">
                <%= @page.date |> Calendar.strftime("%b %d %Y") %>
              </time>
            <% end %>
          </div>
        </header>
        <main class="prose prose-xl sm:my-0 max-w-full">
          <%= render(@inner_content) %>
        </main>
        <footer class="space-y-10 flex space-x-20 border-black border-t border-dashed my-10">
          <ul class="list-none mt-10 ">
            <li><a href="https://www.github.com/ethangunderson">Github</a></li>
            <li><a href="https://bsky.app/profile/ethangunderson.com">Bluesky</a></li>
            <li><a href="https://www.linkedin.com/in/ethangunderson/">LinkedIn</a></li>
            <li><a href="mailto:ethan@ethangunderson.com">Email</a></li>
          </ul>
          <ul class="">
            <li> &copy; Ethan Gunderson</li>
            <li><a href="/feed.xml">RSS</a></li>
          </ul>
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
