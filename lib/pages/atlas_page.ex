defmodule Website.AtlasPage do
  use Tableau.Page,
    layout: Website.PageLayout,
    permalink: "/atlas",
    title: "Atlas"

  use Phoenix.Component

  def template(assigns) do
    ~H"""
    <p class="text-md mb-10">
      Places that I've been and recommend, or want to try. All hits no skips. Broken down by city.
    </p>

    <div class="border-t-4 border-ink">
      <%= for city <- @atlas_cities do %>
        <% total = length(city["places"])
        visited_count = Enum.count(city["places"], & &1["visited"]) %>
        <a
          href={"/atlas/#{city["slug"]}"}
          class="flex items-baseline justify-between py-5 pl-3 border-b-2 border-ink border-l-4 border-transparent no-underline hover:border-accent hover:text-accent transition-colors duration-75"
        >
          <span class="font-extrabold uppercase tracking-tight text-xl">
            <%= city["name"] %>
          </span>
          <span class="text-[0.7rem] font-bold uppercase tracking-wider text-muted">
            <%= city["country"] %> &mdash; <%= visited_count %>/<%= total %> visited
          </span>
        </a>
      <% end %>
    </div>
    """
  end
end
