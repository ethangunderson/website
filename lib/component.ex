defmodule Website.Component do
  use Phoenix.Component

  def project_card(assigns) do
    ~H"""
    <div class={if @active, do: "border-l-4 border-accent pl-4", else: "opacity-80"}>
      <%= if @project["link"] do %>
        <a href={@project["link"]} class="text-lg"><%= @project["name"] %></a>
      <% else %>
        <span class="text-lg"><%= @project["name"] %></span>
      <% end %>
      <p class="mt-1 text-base"><%= @project["description"] %></p>
    </div>
    """
  end

  def book_callout(assigns) do
    ~H"""
    <div class="border-l-4 border-accent bg-white/50 p-6 my-6">
      <h3 class="text-xl font-heading m-0 mb-2">
        <a href="https://www.instrumentingelixir.com/">Instrumenting Elixir Applications</a>
      </h3>
      <p class="m-0 text-base">
        A workshop and book on how to instrument Elixir applications using Telemetry and OpenTelemetry. Currently in progress.
      </p>
    </div>
    """
  end
end
