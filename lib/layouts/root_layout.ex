defmodule Website.RootLayout do
  use Tableau.Layout
  use Phoenix.Component
  import Website.Component

  defp active_class(page, href) do
    if (page[:permalink] || "") == href,
      do: "border-accent text-accent",
      else: "border-transparent"
  end

  defp person_schema do
    Jason.encode!(%{
      "@context" => "https://schema.org",
      "@type" => "Person",
      "name" => "Ethan Gunderson",
      "url" => "https://www.ethangunderson.com",
      "sameAs" => [
        "https://github.com/ethangunderson",
        "https://www.linkedin.com/in/ethangunderson/",
        "https://bsky.app/profile/ethangunderson.com"
      ]
    })
  end

  defp article_schema(page) do
    Jason.encode!(%{
      "@context" => "https://schema.org",
      "@type" => "BlogPosting",
      "headline" => page[:title],
      "author" => %{
        "@type" => "Person",
        "name" => "Ethan Gunderson",
        "url" => "https://www.ethangunderson.com"
      },
      "datePublished" => page[:date] && Date.to_iso8601(page.date),
      "url" => "https://www.ethangunderson.com#{page[:permalink]}",
      "description" => page[:description]
    })
  end

  defp review_schema(page) do
    Jason.encode!(%{
      "@context" => "https://schema.org",
      "@type" => "Review",
      "name" => page[:title],
      "author" => %{
        "@type" => "Person",
        "name" => "Ethan Gunderson",
        "url" => "https://www.ethangunderson.com"
      },
      "datePublished" => page[:date] && Date.to_iso8601(page.date),
      "url" => "https://www.ethangunderson.com#{page[:permalink]}",
      "reviewRating" => %{
        "@type" => "Rating",
        "ratingValue" => page[:rating],
        "bestRating" => 7,
        "worstRating" => 1
      },
      "itemReviewed" => %{
        "@type" => "Product",
        "name" => page[:title],
        "brand" => %{"@type" => "Brand", "name" => page[:roaster]},
        "description" =>
          [
            page[:region] && "Region: #{page[:region]}",
            page[:process] && "Process: #{page[:process]}",
            page[:roast_level] && "Roast level: #{page[:roast_level]}"
          ]
          |> Enum.reject(&is_nil/1)
          |> Enum.join(". ")
      }
    })
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
        <meta property="og:type" content={if @page[:categories] in ["post", "coffee", "media"], do: "article", else: "website"} />
        <% og_image = if @page[:categories] == "coffee" do
          slug = (@page[:permalink] || "") |> String.replace_prefix("/coffee/", "")
          "/images/og/coffee/#{slug}.png"
        else
          @page[:image] || "/images/og-default.png"
        end %>
        <meta property="og:image" content={URI.merge(@site[:config].url, og_image)} />
        <%= if @page[:categories] in ["post", "coffee"] && @page[:date] do %>
          <meta property="article:published_time" content={Date.to_iso8601(@page.date)} />
          <meta property="article:author" content="Ethan Gunderson" />
        <% end %>
        <meta
          property="og:description"
          content={
            @page[:description] ||
              "Software engineer, author, and builder. Writing about observability, Elixir, and building software."
          }
        />
        <meta
          name="description"
          content={
            @page[:description] ||
              "Software engineer, author, and builder. Writing about observability, Elixir, and building software."
          }
        />
        <meta property="og:url" content={URI.merge(@site[:config].url, @page[:permalink])} />
        <meta name="twitter:card" content={if @page[:image], do: "summary_large_image", else: "summary"} />

        <script type="application/ld+json">
          <%= Phoenix.HTML.raw(person_schema()) %>
        </script>
        <%= if @page[:categories] == "post" do %>
          <script type="application/ld+json">
            <%= Phoenix.HTML.raw(article_schema(@page)) %>
          </script>
        <% end %>
        <%= if @page[:categories] == "coffee" do %>
          <script type="application/ld+json">
            <%= Phoenix.HTML.raw(review_schema(@page)) %>
          </script>
        <% end %>

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
        <link
          href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
          rel="stylesheet"
        />

        <link rel="stylesheet" href="/css/site.css" />
        <script src="https://tinylytics.app/embed/qsUQPD1PyV36tTZ7CVZn.js" defer>
        </script>
        <script src="https://peepmetrics.com/t.js" data-token="izRiEhBmlc9R0YIFUHqa9" async>
        </script>
      </head>

      <body class="bg-site-bg text-ink font-sans text-[17px] leading-relaxed">

        <div class="fixed top-0 left-0 right-0 h-1 bg-accent z-50"></div>

        <div class="grid grid-cols-1 md:grid-cols-layout min-h-screen pt-1">

          <aside class="bg-sidebar-bg border-b-4 border-ink md:border-b-0 md:border-r-4 md:sticky md:top-1 md:h-[calc(100vh-4px)] p-6 md:p-10 flex flex-col overflow-y-auto">
            <div class="mb-8">
              <a href="/" class="no-underline hover:no-underline text-ink hover:text-ink block">
                <.site_header />
              </a>
            </div>

            <div class="border-t-4 border-ink mb-6"></div>

            <nav>
              <ul class="list-none p-0 m-0 flex flex-row flex-wrap gap-1 md:flex-col md:gap-0">
                <li>
                  <a
                    href="/"
                    class={[
                      "block py-2 px-3 text-[0.78rem] font-bold uppercase tracking-[0.09em] text-ink no-underline border-l-4 transition-colors duration-75 hover:border-accent hover:text-accent",
                      active_class(@page, "/")
                    ]}
                  >
                    About
                  </a>
                </li>
                <%!-- <li>
                  <a
                    href="/book"
                    class={[
                      "block py-2 px-3 text-[0.78rem] font-bold uppercase tracking-[0.09em] no-underline border-l-4 transition-colors duration-75 hover:border-accent hover:text-accent",
                      if(active_class(@page, "/book") == "border-accent text-accent",
                        do: "border-accent text-accent",
                        else: "border-transparent text-accent opacity-70"
                      )
                    ]}
                  >
                    Book
                  </a>
                </li> --%>
                <li>
                  <a
                    href="/notes"
                    class={[
                      "block py-2 px-3 text-[0.78rem] font-bold uppercase tracking-[0.09em] text-ink no-underline border-l-4 transition-colors duration-75 hover:border-accent hover:text-accent",
                      active_class(@page, "/notes")
                    ]}
                  >
                    Notes
                  </a>
                </li>
                <li>
                  <a
                    href="/projects"
                    class={[
                      "block py-2 px-3 text-[0.78rem] font-bold uppercase tracking-[0.09em] text-ink no-underline border-l-4 transition-colors duration-75 hover:border-accent hover:text-accent",
                      active_class(@page, "/projects")
                    ]}
                  >
                    Projects
                  </a>
                </li>
                <li>
                  <a
                    href="/media"
                    class={[
                      "block py-2 px-3 text-[0.78rem] font-bold uppercase tracking-[0.09em] text-ink no-underline border-l-4 transition-colors duration-75 hover:border-accent hover:text-accent",
                      active_class(@page, "/media")
                    ]}
                  >
                    Media
                  </a>
                </li>
                <li>
                  <a
                    href="/coffee"
                    class={[
                      "block py-2 px-3 text-[0.78rem] font-bold uppercase tracking-[0.09em] text-ink no-underline border-l-4 transition-colors duration-75 hover:border-accent hover:text-accent",
                      active_class(@page, "/coffee")
                    ]}
                  >
                    Coffee
                  </a>
                </li>
                <li>
                  <a
                    href="/now"
                    class={[
                      "block py-2 px-3 text-[0.78rem] font-bold uppercase tracking-[0.09em] text-ink no-underline border-l-4 transition-colors duration-75 hover:border-accent hover:text-accent",
                      active_class(@page, "/now")
                    ]}
                  >
                    Now
                  </a>
                </li>
                <li>
                  <a
                    href="/atlas"
                    class={[
                      "block py-2 px-3 text-[0.78rem] font-bold uppercase tracking-[0.09em] text-ink no-underline border-l-4 transition-colors duration-75 hover:border-accent hover:text-accent",
                      active_class(@page, "/atlas")
                    ]}
                  >
                    Atlas
                  </a>
                </li>
              </ul>
            </nav>
          </aside>

          <div class="flex flex-col p-6 md:px-16 md:py-12">
            <main class="flex-1">
              <%= if !@page[:hide_title] do %>
                <h1 class="text-[2.25rem] font-extrabold uppercase tracking-tight leading-[1.1] mb-6 pb-4 border-b-4 border-ink">
                  <%= if @page[:link_url] do %>
                    <a href={@page[:link_url]} class="no-underline hover:text-accent"><%= @page[:title] %> ↗</a>
                  <% else %>
                    <%= @page[:title] %>
                  <% end %>
                </h1>
              <% end %>

              <%= if @page[:date] do %>
                <time class={"block text-[0.75rem] text-muted font-semibold uppercase tracking-[0.07em] #{if @page[:categories] == "post", do: "mb-1", else: "mb-8"}"}>
                  <%= @page.date |> Calendar.strftime("%b %d %Y") %>
                </time>
              <% end %>
              <%= if @page[:categories] == "post" do %>
                <p class="text-[0.75rem] text-muted font-semibold uppercase tracking-[0.07em] mb-8">Ethan Gunderson</p>
              <% end %>

              <div class="prose text-base">
                <%= render(@inner_content) %>
              </div>
            </main>

            <footer class="border-t-4 border-ink mt-16 pt-8">
              <ul class="list-none p-0 m-0 flex gap-6 flex-wrap mb-3">
                <li>
                  <a
                    href="https://www.github.com/ethangunderson"
                    class="text-[0.78rem] font-bold uppercase tracking-[0.07em] no-underline text-ink hover:text-accent"
                  >
                    Github
                  </a>
                </li>
                <li>
                  <a
                    href="https://bsky.app/profile/ethangunderson.com"
                    class="text-[0.78rem] font-bold uppercase tracking-[0.07em] no-underline text-ink hover:text-accent"
                  >
                    Bluesky
                  </a>
                </li>
                <li>
                  <a
                    href="https://www.linkedin.com/in/ethangunderson/"
                    class="text-[0.78rem] font-bold uppercase tracking-[0.07em] no-underline text-ink hover:text-accent"
                  >
                    LinkedIn
                  </a>
                </li>
                <li>
                  <a
                    href="mailto:ethan@ethangunderson.com"
                    class="text-[0.78rem] font-bold uppercase tracking-[0.07em] no-underline text-ink hover:text-accent"
                  >
                    Email
                  </a>
                </li>
                <li>
                  <a
                    href="/feed.xml"
                    class="text-[0.78rem] font-bold uppercase tracking-[0.07em] no-underline text-ink hover:text-accent"
                  >
                    RSS
                  </a>
                </li>
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
