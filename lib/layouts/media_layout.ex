defmodule Website.MediaLayout do
  use Tableau.Layout, layout: Website.RootLayout
  use Phoenix.Component

  defp stars(n), do: String.duplicate("★", n) <> String.duplicate("☆", 5 - n)

  def template(assigns) do
    ~H"""
    <article class="flex gap-x-5">
      <div class="not-prose flex flex-col gap-y-2 min-w-[250px] max-w-[250px]">
        <img
          src={@page[:image]}
          alt={"Cover image for #{@page[:title]}"}
          class={"object-cover border-2 border-ink block #{if @page[:type] == "album", do: "aspect-square", else: "aspect-[2/3]"}"}
        />
        <div class="flex gap-x-2 items-center">
          <span class="text-[0.7rem] font-bold uppercase tracking-[0.1em] px-2 py-0.5 border-2 border-ink bg-ink text-site-bg">
            <%= String.upcase(@page[:type] || "") %>
          </span>
          <span class="text-[0.8rem] text-muted font-semibold uppercase tracking-[0.07em]">
            <%= @page[:creator] %> | <%= @page[:year] %>
          </span>
        </div>
      </div>

      <div class="prose text-base">
        <%= {:safe, render(@inner_content)} %>
        <span class="text-accent font-mono text-lg tracking-wider" aria-label={"#{@page[:rating]} out of 5 stars"}>
          <%= stars(@page[:rating] || 0) %>
        </span>
      </div>
    </article>
    """
  end
end
