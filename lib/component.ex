defmodule Website.Component do
  use Phoenix.Component

  def project_card(assigns) do
    ~H"""
    <div>
      <%= if @project["link"] do %>
        <a href={@project["link"]}><%= @project["name"] %></a>
      <% else %>
        <%= @project["name"] %>
      <% end %>
      <p class="mt-0 text-md"><%= @project["description"] %></p>
    </div>
    """
  end
end
