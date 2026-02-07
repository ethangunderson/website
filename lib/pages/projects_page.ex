defmodule Website.ProjectsPage do
  use Tableau.Page,
    layout: Website.PageLayout,
    permalink: "/projects",
    title: "Projects"

  use Phoenix.Component
  import Website.Component

  def template(assigns) do
    ~H"""
    <p class="mb-10">Things I've built, am building, or contributed to.</p>
    <div class="space-y-16">
      <%= for type <- @data["projects"] do %>
        <div :for={{status, projects} <- type}>
          <h2 class="text-2xl font-heading mb-6 capitalize"><%= status %></h2>
          <div class="space-y-6">
            <%= for project <- projects do %>
              <.project_card project={project} active={status == "active"} />
            <% end %>
          </div>
        </div>
      <% end %>
    </div>
    """
  end
end
