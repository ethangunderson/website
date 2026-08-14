defmodule Website.FriendsPage do
  use Tableau.Page,
    layout: Website.PageLayout,
    permalink: "/friends",
    title: "Friends"

  use Phoenix.Component

  def template(assigns) do
    ~H"""
    Here are some of my friends that are on the internet!
    <div class="space-y-3 mt-5">
      <%= for friend <- @data["friends"] do %>
        <a href={friend["link"]} class="no-underline block hover:text-accent transition-colors duration-75">
          <div class="flex items-center gap-4 text-lg">
            <span><%= friend["name"] %></span>
          </div>
        </a>
      <% end %>
    </div>
    """
  end
end
