defmodule Website.CoffeePage do
  use Tableau.Page,
    layout: Website.RootLayout,
    permalink: "/coffee",
    title: "Coffee"

  use Phoenix.Component

  def template(assigns) do
    ~H"""
    <section class="space-y-8 not-prose">
      <% coffee_posts =
        @posts |> Enum.filter(&(&1[:categories] == "coffee")) |> Enum.sort_by(& &1.date, {:desc, Date}) %>
      <% posts_by_year = Enum.group_by(coffee_posts, & &1.date.year) %>
      <% roasters = coffee_posts |> Enum.map(& &1[:roaster]) |> Enum.reject(&is_nil/1) |> Enum.uniq() |> Enum.sort() %>
      <% ratings = coffee_posts |> Enum.map(& &1[:rating]) |> Enum.reject(&is_nil/1) |> Enum.uniq() |> Enum.sort(:desc) %>

      <div class="space-y-3">
        <div class="flex flex-wrap items-center gap-2">
          <span class="text-sm font-heading text-muted w-16">Roaster</span>
          <button class="filter-btn px-3 py-1 text-sm border border-ink" data-filter-type="roaster" data-filter-value="all" data-active="true">All</button>
          <%= for roaster <- roasters do %>
            <button class="filter-btn px-3 py-1 text-sm border border-ink" data-filter-type="roaster" data-filter-value={roaster} data-active="false"><%= roaster %></button>
          <% end %>
        </div>
        <div class="flex flex-wrap items-center gap-2">
          <span class="text-sm font-heading text-muted w-16">Rating</span>
          <button class="filter-btn px-3 py-1 text-sm border border-ink" data-filter-type="rating" data-filter-value="all" data-active="true">All</button>
          <%= for rating <- ratings do %>
            <button class="filter-btn px-3 py-1 text-sm border border-ink" data-filter-type="rating" data-filter-value={rating} data-active="false"><%= String.duplicate("★", rating) %></button>
          <% end %>
        </div>
      </div>

      <%= for {year, posts} <- Enum.sort_by(posts_by_year, fn {year, _} -> year end, :desc) do %>
        <div data-year-group={year}>
          <h2 class="text-xl font-heading mb-6"><%= year %></h2>
          <div class="flex flex-wrap gap-2">
            <%= for post <- posts do %>
              <article class="flex-shrink-0" data-roaster={post[:roaster]} data-rating={post[:rating]}>
                <a href={post.permalink} class="no-underline">
                  <img
                    src={post[:image]}
                    alt={"Image of coffee bag for #{post.title}"}
                    class="h-[262px] w-auto object-cover border-2 border-ink block hover:scale-105 aspect-[2/3]"
                  />
                </a>
              </article>
            <% end %>
          </div>
        </div>
      <% end %>
    </section>

    <script>
      (function () {
        var activeRoaster = 'all';
        var activeRatings = new Set();

        function applyFilters() {
          document.querySelectorAll('[data-roaster]').forEach(function (el) {
            var roasterMatch = activeRoaster === 'all' || el.dataset.roaster === activeRoaster;
            var ratingMatch = activeRatings.size === 0 || activeRatings.has(el.dataset.rating);
            el.style.display = (roasterMatch && ratingMatch) ? '' : 'none';
          });

          document.querySelectorAll('[data-year-group]').forEach(function (section) {
            var anyVisible = Array.from(section.querySelectorAll('[data-roaster]')).some(function (el) {
              return el.style.display !== 'none';
            });
            section.style.display = anyVisible ? '' : 'none';
          });

          document.querySelectorAll('.filter-btn').forEach(function (btn) {
            var type = btn.dataset.filterType;
            var val = btn.dataset.filterValue;
            var isActive = (type === 'roaster' && val === activeRoaster) ||
                           (type === 'rating' && val === 'all' && activeRatings.size === 0) ||
                           (type === 'rating' && val !== 'all' && activeRatings.has(val));
            btn.dataset.active = isActive.toString();
            btn.style.backgroundColor = isActive ? 'var(--color-ink, #000)' : '';
            btn.style.color = isActive ? 'var(--color-paper, #fff)' : '';
          });

          var url = new URL(window.location);
          if (activeRoaster === 'all') { url.searchParams.delete('roaster'); } else { url.searchParams.set('roaster', activeRoaster); }
          if (activeRatings.size === 0) { url.searchParams.delete('rating'); } else { url.searchParams.set('rating', Array.from(activeRatings).join(',')); }
          history.replaceState(null, '', url);
        }

        var params = new URL(window.location).searchParams;
        activeRoaster = params.get('roaster') || 'all';
        var ratingParam = params.get('rating');
        if (ratingParam) { ratingParam.split(',').forEach(function (r) { activeRatings.add(r); }); }
        applyFilters();

        document.querySelectorAll('.filter-btn').forEach(function (btn) {
          btn.addEventListener('click', function () {
            var type = btn.dataset.filterType;
            var val = btn.dataset.filterValue;
            if (type === 'roaster') {
              activeRoaster = val;
            } else if (type === 'rating') {
              if (val === 'all') {
                activeRatings.clear();
              } else if (activeRatings.has(val)) {
                activeRatings.delete(val);
              } else {
                activeRatings.add(val);
              }
            }
            applyFilters();
          });
        });
      })();
    </script>
    """
  end
end
