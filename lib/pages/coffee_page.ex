defmodule Website.CoffeePage do
  use Tableau.Page,
    layout: Website.RootLayout,
    permalink: "/coffee",
    title: "Coffee"

  use Phoenix.Component

  import Website.Component, only: [rating_display: 1]

  def template(assigns) do
    ~H"""
    <section class="space-y-8 not-prose">
      <div class="flex items-center gap-3 mb-2">
        <span class="text-[0.72rem] font-bold uppercase tracking-[0.09em] text-muted">View:</span>
        <a href="/coffee" class="text-[0.72rem] font-bold uppercase tracking-[0.09em] border-b-2 border-ink no-underline text-ink">Log</a>
        <a href="/coffee/grid" class="text-[0.72rem] font-bold uppercase tracking-[0.09em] border-b-2 border-transparent no-underline text-ink hover:border-accent hover:text-accent">Grid</a>
        <a href="/coffee/stats" class="text-[0.72rem] font-bold uppercase tracking-[0.09em] border-b-2 border-transparent no-underline text-ink hover:border-accent hover:text-accent">Stats</a>
      </div>

      <% coffee_posts =
        @posts |> Enum.filter(&(&1[:categories] == "coffee")) |> Enum.sort_by(& &1.date, {:desc, Date}) %>
      <% posts_by_year = Enum.group_by(coffee_posts, & &1.date.year) %>
      <% roasters = coffee_posts |> Enum.map(& &1[:roaster]) |> Enum.reject(&is_nil/1) |> Enum.uniq() |> Enum.sort() %>
      <% ratings = coffee_posts |> Enum.map(& &1[:rating]) |> Enum.reject(&is_nil/1) |> Enum.uniq() |> Enum.sort(:desc) %>

      <div class="space-y-3">
        <div class="flex flex-wrap items-center gap-2">
          <span class="text-[0.72rem] font-bold uppercase tracking-[0.09em] text-muted w-16">Roaster</span>
          <button class="filter-btn px-3 py-1 text-xs font-bold uppercase tracking-wider border border-ink" data-filter-type="roaster" data-filter-value="all" data-active="true">All</button>
          <%= for roaster <- roasters do %>
            <button class="filter-btn px-3 py-1 text-xs font-bold uppercase tracking-wider border border-ink" data-filter-type="roaster" data-filter-value={roaster} data-active="false"><%= roaster %></button>
          <% end %>
        </div>
        <div class="flex flex-wrap items-center gap-2">
          <span class="text-[0.72rem] font-bold uppercase tracking-[0.09em] text-muted w-16">Rating</span>
          <button class="filter-btn px-3 py-1 text-xs font-bold uppercase tracking-wider border border-ink" data-filter-type="rating" data-filter-value="all" data-active="true">All</button>
          <%= for rating <- ratings do %>
            <button class="filter-btn px-3 py-1 text-xs font-bold uppercase tracking-wider border border-ink" data-filter-type="rating" data-filter-value={rating} data-active="false">★ <%= rating %></button>
          <% end %>
        </div>
      </div>

      <%= for {year, year_posts} <- Enum.sort_by(posts_by_year, fn {year, _} -> year end, :desc) do %>
        <%
          seven_count = Enum.count(year_posts, &(&1[:rating] == 7))
        %>
        <div data-year-group={year}>
          <div class="flex items-baseline gap-3 mb-1 border-b-2 border-ink pb-2">
            <h2 class="text-3xl font-heading font-black"><%= year %></h2>
            <span class="text-[0.72rem] font-bold uppercase tracking-[0.09em] text-muted">
              <%= length(year_posts) %> CUPS<%= if seven_count > 0, do: " · #{seven_count} SEVEN" %>
            </span>
          </div>

          <div>
            <%= for post <- year_posts do %>
              <%= if post[:rating] == 7 || post[:highlight] do %>
                <article class="border-l-4 border-l-accent pl-4 py-4 border-b border-b-ink/20 hover:bg-ink/5" data-roaster={post[:roaster]} data-rating={post[:rating]}>
                  <a href={post.permalink} class="no-underline flex items-start gap-4">
                    <%= if post[:image] do %>
                      <img
                        src={post[:image]}
                        alt={"Image of coffee bag for #{post.title}"}
                        class="h-24 w-auto object-cover flex-shrink-0 border border-ink"
                      />
                    <% end %>
                    <div class="flex-1 min-w-0">
                      <p class="text-[0.72rem] font-bold uppercase tracking-widest text-accent mb-1">Best of <%= year %></p>
                      <div class="flex items-baseline justify-between gap-4">
                        <p class="text-lg font-black uppercase tracking-tight text-ink leading-tight">
                          <%= post.title %>
                          <span class="text-sm font-bold text-muted ml-2 normal-case"><%= post[:roaster] %></span>
                        </p>
                        <.rating_display rating={post[:rating]} />
                      </div>
                      <p class="text-sm text-muted mt-1"><%= post[:process] %> · <%= post[:region] %>.</p>
                    </div>
                  </a>
                </article>
              <% else %>
                <article data-roaster={post[:roaster]} data-rating={post[:rating]}>
                  <a href={post.permalink} class="no-underline flex items-center justify-between gap-4 py-3 hover:bg-ink/5 -mx-1 px-1 border-b border-ink/20">
                    <p class="text-sm font-black uppercase tracking-tight text-ink">
                      <%= post.title %>
                      <span class="font-normal not-italic text-muted"> — </span>
                      <span class="font-normal italic text-muted"><%= post[:process] %> · <%= post[:region] %></span>
                    </p>
                    <div class="flex items-center gap-4 flex-shrink-0">
                      <span class="text-[0.65rem] font-bold uppercase tracking-widest text-muted hidden sm:block"><%= post[:roaster] %></span>
                      <.rating_display rating={post[:rating]} />
                    </div>
                  </a>
                </article>
              <% end %>
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
