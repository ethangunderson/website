defmodule Website.WritingPage do
  use Tableau.Page,
    layout: Website.PageLayout,
    permalink: "/writing",
    title: "Writing"

  use Phoenix.Component

  def template(assigns) do
    ~H"""
    <p class="mb-10">I write about observability, Elixir, and building software.</p>
    <section class="space-y-12">
      <% writing_posts = Enum.filter(@posts, &(&1[:categories] == "post")) %>
      <% posts_by_year = Enum.group_by(writing_posts, & &1.date.year) %>
      <%= for {year, posts} <- Enum.sort_by(posts_by_year, fn {year, _} -> year end, :desc) do %>
        <div>
          <h2 class="text-2xl font-heading mb-4"><%= year %></h2>
          <div class="space-y-6">
            <%= for post <- posts do %>
              <article>
                <div class="flex items-baseline gap-3">
                  <a href={post.permalink} class="text-lg"><%= post.title %></a>
                  <time class="text-sm text-grille whitespace-nowrap"><%= post.date |> Calendar.strftime("%b %d") %></time>
                </div>
                <%= if post[:description] do %>
                  <p class="mt-1 text-base text-parchment/70"><%= post.description %></p>
                <% end %>
              </article>
            <% end %>
          </div>
        </div>
      <% end %>
    </section>
    """
  end
end
