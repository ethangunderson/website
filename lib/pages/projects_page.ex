defmodule Website.ProjectsPage do
  use Tableau.Page,
    layout: Website.PageLayout,
    permalink: "/projects",
    title: "projects"

  use Phoenix.Component

  def template(assigns) do
    ~H"""
    <div class="space-y-20">
      <div class="flex flex-col space-y-20">
        <%= for type <- @data["projects"] do %>
          <div :for={{status, projects} <- type}>
            <h2 class="text-base"><%= status %></h2>
            <div class="space-y-5">
              <div :for={project <- projects}>
                <%= if project["link"] do %>
                  <a href={project["link"]}><%= project["name"] %></a>
                <% else %>
                  <%= project["name"] %>
                <% end %>
                <p class="mt-0 text-sm">
                  <%= project["description"] %>
                </p>
              </div>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
