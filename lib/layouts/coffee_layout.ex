defmodule Website.CoffeeLayout do
  use Tableau.Layout, layout: Website.RootLayout
  use Phoenix.Component

  defp stars(n), do: String.duplicate("★", n) <> String.duplicate("☆", 5 - n)

  def template(assigns) do
    ~H"""
    <article class="flex gap-x-5">
      <div class="not-prose flex flex-col gap-y-2 min-w-[250px] max-w-[250px]">
        <img
          src={@page[:image]}
          alt={"Cover image for #{@page[:name]}"}
          class={"object-cover border-2 border-ink block #{if @page[:type] == "album", do: "aspect-square", else: "aspect-[2/3]"}"}
        />
        <div class="gap-x-2 items-center">
          <div class="text-[0.8rem] text-muted font-semibold uppercase tracking-[0.07em]">
            <strong>Roaster:</strong> <%= @page[:roaster] %>
          </div>
          <div class="text-[0.8rem] text-muted font-semibold uppercase tracking-[0.07em]">
            <strong>Process:</strong> <%= @page[:process] %>
          </div>
          <div class="text-[0.8rem] text-muted font-semibold uppercase tracking-[0.07em]">
            <strong>Roast Level:</strong> <%= @page[:roast_level] %>
          </div>
          <div class="text-[0.8rem] text-muted font-semibold uppercase tracking-[0.07em]">
            <strong>Region:</strong> <%= @page[:region] %>
          </div>
          <div class="text-[0.8rem] text-muted font-semibold uppercase tracking-[0.07em]">
            <a href={@page[:link]}>Link</a>
          </div>
        </div>
      </div>

      <div class="prose text-base">
        <%= {:safe, render(@inner_content)} %>
        <span
          class="text-accent font-mono text-lg tracking-wider"
          aria-label={"#{@page[:rating]} out of 5 stars"}
        >
          <%= stars(@page[:rating] || 0) %>
        </span>
        <div class="mt-3">
          <div data-peepmetrics-cheers></div>
          <script src="https://peepmetrics.com/cheers.js" data-token="izRiEhBmlc9R0YIFUHqa9" async>
          </script>
        </div>
      </div>
    </article>
    """
  end
end
