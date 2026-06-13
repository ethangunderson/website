defmodule Website.CoffeeStatsPage do
  use Tableau.Page,
    layout: Website.RootLayout,
    permalink: "/coffee/stats",
    title: "Coffee Stats"

  use Phoenix.Component

  defp normalize_process(process) when is_binary(process) do
    p = String.downcase(process)
    cond do
      String.contains?(p, "co-ferment") or String.contains?(p, "co ferment") -> "Co-Ferment"
      String.contains?(p, "natural") -> "Natural"
      String.contains?(p, "washed") -> "Washed"
      true -> "Other"
    end
  end
  defp normalize_process(_), do: "Other"

  defp avg_rating_by(posts, key_fn) do
    posts
    |> Enum.reject(&(is_nil(key_fn.(&1)) or is_nil(&1[:rating])))
    |> Enum.group_by(key_fn)
    |> Enum.map(fn {key, group} ->
      avg = Enum.sum(Enum.map(group, & &1[:rating])) / length(group)
      {key, avg, length(group)}
    end)
    |> Enum.sort_by(fn {_k, avg, _n} -> avg end, :desc)
  end

  defp rating_distribution(posts) do
    counts = posts |> Enum.reject(&is_nil(&1[:rating])) |> Enum.frequencies_by(& &1[:rating])
    Enum.map(1..7, fn r -> {r, Map.get(counts, r, 0)} end)
  end

  defp horizontal_bar_svg(data) do
    row_h = 36
    bar_h = 20
    label_w = 120
    bar_area_w = 240
    bar_x = 130
    max_scale = 7.0
    total_h = length(data) * row_h + 40

    bars =
      data
      |> Enum.with_index()
      |> Enum.map(fn {{label, avg, count}, i} ->
        y = 20 + i * row_h
        bar_w = avg / max_scale * bar_area_w |> Float.round(1)
        val_x = bar_x + bar_w + 6
        val_label = "#{:erlang.float_to_binary(avg, decimals: 2)} (n=#{count})"

        """
        <text x="#{label_w}" y="#{y + bar_h - 4}" text-anchor="end"
              font-size="10" font-family="inherit" font-weight="700"
              fill="#111111">#{label}</text>
        <rect x="#{bar_x}" y="#{y}" width="#{bar_w}" height="#{bar_h}" fill="#111111"/>
        <text x="#{val_x}" y="#{y + bar_h - 4}" font-size="10" font-family="inherit" fill="#888888">#{val_label}</text>
        """
      end)
      |> Enum.join()

    axis_y = 20 + length(data) * row_h

    """
    <svg viewBox="0 0 400 #{total_h}" xmlns="http://www.w3.org/2000/svg"
         style="width:100%;max-width:480px;display:block;">
      #{bars}
      <line x1="#{bar_x}" y1="#{axis_y}" x2="#{bar_x + bar_area_w}" y2="#{axis_y}"
            stroke="#111111" stroke-width="1"/>
    </svg>
    """
  end

  defp rating_dist_svg(dist) do
    max_count = dist |> Enum.map(&elem(&1, 1)) |> Enum.max()
    max_count = max(max_count, 1)
    bar_w = 36
    gap = 14
    max_bar_h = 90
    padding_left = 10
    padding_top = 20
    chart_h = max_bar_h + padding_top + 30
    total_w = length(dist) * (bar_w + gap) + padding_left

    bars =
      dist
      |> Enum.with_index()
      |> Enum.map(fn {{rating, count}, i} ->
        x = padding_left + i * (bar_w + gap)
        bar_h = round(count / max_count * max_bar_h)
        y = padding_top + (max_bar_h - bar_h)
        label_y = padding_top + max_bar_h + 16
        count_y = y - 4
        count_label = if count > 0, do: ~s(<text x="#{x + div(bar_w, 2)}" y="#{count_y}" text-anchor="middle" font-size="11" font-family="inherit" fill="#111111">#{count}</text>), else: ""

        """
        <rect x="#{x}" y="#{y}" width="#{bar_w}" height="#{bar_h}" fill="#111111"/>
        #{count_label}
        <text x="#{x + div(bar_w, 2)}" y="#{label_y}" text-anchor="middle"
              font-size="12" font-family="inherit" font-weight="700" fill="#e63000">#{rating}★</text>
        """
      end)
      |> Enum.join()

    axis_y = padding_top + max_bar_h

    """
    <svg viewBox="0 0 #{total_w} #{chart_h}" xmlns="http://www.w3.org/2000/svg"
         style="width:100%;max-width:360px;display:block;">
      #{bars}
      <line x1="#{padding_left}" y1="#{axis_y}" x2="#{total_w}" y2="#{axis_y}"
            stroke="#111111" stroke-width="1"/>
    </svg>
    """
  end

  def template(assigns) do
    ~H"""
    <% coffee_posts = @posts |> Enum.filter(&(&1[:categories] == "coffee")) %>
    <% total = length(coffee_posts) %>

    <div class="flex items-center gap-3 mb-8 not-prose">
      <span class="text-[0.72rem] font-bold uppercase tracking-[0.09em] text-muted">View:</span>
      <a href="/coffee" class="text-[0.72rem] font-bold uppercase tracking-[0.09em] border-b-2 border-transparent no-underline text-ink hover:border-accent hover:text-accent">Log</a>
      <a href="/coffee/grid" class="text-[0.72rem] font-bold uppercase tracking-[0.09em] border-b-2 border-transparent no-underline text-ink hover:border-accent hover:text-accent">Grid</a>
      <a href="/coffee/stats" class="text-[0.72rem] font-bold uppercase tracking-[0.09em] border-b-2 border-ink no-underline text-ink">Stats</a>
    </div>

    <section class="space-y-12 not-prose">
      <div>
        <h2 class="text-sm font-bold uppercase tracking-[0.09em] mb-1">Rating Distribution</h2>
        <p class="text-xs text-muted mb-4"><%= total %> coffees reviewed</p>
        <%= Phoenix.HTML.raw(rating_dist_svg(rating_distribution(coffee_posts))) %>
      </div>

      <div>
        <h2 class="text-sm font-bold uppercase tracking-[0.09em] mb-1">Avg Rating by Region</h2>
        <p class="text-xs text-muted mb-4">Out of 7.00</p>
        <%= Phoenix.HTML.raw(horizontal_bar_svg(avg_rating_by(coffee_posts, & &1[:region]))) %>
      </div>

      <div>
        <h2 class="text-sm font-bold uppercase tracking-[0.09em] mb-1">Avg Rating by Roaster</h2>
        <p class="text-xs text-muted mb-4">Out of 7.00</p>
        <%= Phoenix.HTML.raw(horizontal_bar_svg(avg_rating_by(coffee_posts, & &1[:roaster]))) %>
      </div>

      <div>
        <h2 class="text-sm font-bold uppercase tracking-[0.09em] mb-1">Avg Rating by Roast Level</h2>
        <p class="text-xs text-muted mb-4">Out of 7.00</p>
        <%= Phoenix.HTML.raw(horizontal_bar_svg(avg_rating_by(coffee_posts, & &1[:roast_level]))) %>
      </div>

      <div>
        <h2 class="text-sm font-bold uppercase tracking-[0.09em] mb-1">Avg Rating by Process</h2>
        <p class="text-xs text-muted mb-4">Natural includes anaerobic variants. Co-Ferment matched before Natural.</p>
        <%= Phoenix.HTML.raw(horizontal_bar_svg(avg_rating_by(coffee_posts, &normalize_process(&1[:process])))) %>
      </div>
    </section>
    """
  end
end
