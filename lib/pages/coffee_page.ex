defmodule Website.CoffeePage do
  use Tableau.Page,
    layout: Website.RootLayout,
    permalink: "/coffee",
    title: "Coffee"

  use Phoenix.Component

  def template(assigns) do
    ~H"""
    <section class="space-y-12 not-prose">
      <% media_posts =
        @posts |> Enum.filter(&(&1[:categories] == "coffee")) |> Enum.sort_by(& &1.date, {:desc, Date}) %>
      <% posts_by_year = Enum.group_by(media_posts, & &1.date.year) %>
      <%= for {year, posts} <- Enum.sort_by(posts_by_year, fn {year, _} -> year end, :desc) do %>
        <div>
          <h2 class="text-xl font-heading mb-6"><%= year %></h2>
          <div class="flex flex-wrap gap-2">
            <%= for post <- posts do %>
              <article class="flex-shrink-0">
                <a href={post.permalink} class="no-underline">
                  <img
                    src={post[:image]}
                    alt={"Image of coffee bag for #{post.title}"}
                    class={"h-[262px] w-auto object-cover border-2 border-ink block hover:scale-105 #{if post[:type] == "album", do: "aspect-square", else: "aspect-[2/3]"}"}
                  />
                </a>
              </article>
            <% end %>
          </div>
        </div>
      <% end %>
    </section>
    """
  end
end
