defmodule Website.ProjectsPage do
  use Tableau.Page,
    layout: Website.PageLayout,
    permalink: "/projects",
    title: "Projects"

  use Phoenix.Component
  import Website.Component

  def template(assigns) do
    ~H"""
    <div class="space-y-20">
      <div class="flex flex-col space-y-20">
        <%= for type <- @data["projects"] do %>
          <div :for={{status, projects} <- type}>
            <h2 class="text-base"><%= status %></h2>
            <div class="space-y-5">
              <%= for {project, idx} <- Enum.with_index(projects) do %>
              <div>
                <.project_card project={project} />
                <%= if idx < length(projects) - 1 do %>
                  <hr class="border-black border-dashed">
                <% end %>
              </div>
              <% end %>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
