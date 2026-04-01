defmodule Website.AtlasCityTemplate do
  use Phoenix.Component

  def render(assigns) do
    categories =
      assigns.city["places"]
      |> Enum.map(& &1["category"])
      |> Enum.uniq()
      |> Enum.sort()

    assigns = Map.put(assigns, :categories, categories)

    ~H"""
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <style>
      /* Square zoom controls matching site aesthetic */
      .leaflet-bar a,
      .leaflet-bar a:hover { border-radius: 0; background: #ffffff; color: #111111; border-color: #111111; font-weight: 700; }
      .leaflet-bar a:hover { background: #111111; color: #f5f5f0; }
      .leaflet-bar { border: 3px solid #111111 !important; box-shadow: none !important; }
      .leaflet-bar a + a { border-top: 2px solid #111111; }
      /* Square tooltips */
      .leaflet-tooltip { border-radius: 0; border: 2px solid #111111; background: #ffffff; color: #111111; font-family: inherit; font-size: 0.72rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.07em; box-shadow: none; padding: 3px 7px; }
      .leaflet-tooltip-top:before { display: none; }
      /* Attribution */
      .leaflet-control-attribution { font-size: 0.6rem; background: rgba(245,245,240,0.85); }
      /* Filter buttons */
      .filter-btn { border: 2px solid #111111; background: transparent; color: #111111; padding: 3px 10px; font-size: 0.68rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.07em; cursor: pointer; font-family: inherit; }
      .filter-btn[data-active="true"] { background: #111111; color: #f5f5f0; }
      .filter-btn:hover { background: #111111; color: #f5f5f0; }
    </style>

    <div class="not-prose">
      <p class="text-[0.72rem] font-bold uppercase tracking-wider text-muted mb-6">
        <%= @city["country"] %> &mdash; <%= @city["region"] %>
      </p>

      <div id="travel-map" style="height: 420px; width: 100%;" class="border-4 border-ink mb-10"></div>

      <div class="flex gap-2 flex-wrap mb-6">
        <button class="filter-btn" data-filter="all" data-active="true">All</button>
        <%= for cat <- @categories do %>
          <button class="filter-btn" data-filter={cat}><%= cat %></button>
        <% end %>
      </div>

      <div class="border-t-4 border-ink">
        <%= for {place, idx} <- Enum.with_index(@city["places"]) do %>
          <div
            id={"place-#{idx}"}
            class="py-5 pl-3 border-b-2 border-ink border-l-4 border-transparent cursor-pointer hover:border-accent hover:text-accent transition-colors duration-75 group"
            data-lat={place["lat"]}
            data-lng={place["lng"]}
            data-idx={idx}
            data-category={place["category"]}
          >
            <div class="flex items-start gap-3 flex-wrap mb-2">
              <span class="font-extrabold uppercase tracking-tight text-base">
                <%= place["name"] %>
              </span>
              <span class={"text-[0.62rem] font-bold uppercase tracking-wider border-2 px-1.5 py-0.5 #{category_classes(place["category"])}"}>
                <%= place["category"] %>
              </span>
              <%= if place["visited"] do %>
                <span class="text-[0.62rem] font-bold uppercase tracking-wider border-2 border-accent text-accent px-1.5 py-0.5">
                  Visited
                </span>
              <% else %>
                <span class="text-[0.62rem] font-bold uppercase tracking-wider border-2 border-muted text-muted px-1.5 py-0.5">
                  Want to go
                </span>
              <% end %>
            </div>

            <p class="text-sm text-muted mb-2"><%= place["address"] %></p>

            <%= if place["notes"] do %>
              <p class="text-sm mb-2"><%= place["notes"] %></p>
            <% end %>

            <div class="flex gap-4 flex-wrap text-[0.68rem] font-bold uppercase tracking-wider mt-2">
              <%= if place["website"] do %>
                <a href={place["website"]} class="text-accent-blue hover:text-accent no-underline" onclick="event.stopPropagation()">
                  Website
                </a>
              <% end %>
              <%= if place["google_maps"] do %>
                <a href={place["google_maps"]} class="text-accent-blue hover:text-accent no-underline" onclick="event.stopPropagation()">
                  Maps
                </a>
              <% end %>
              <%= for source <- (place["discovered_via"] || []) do %>
                <a href={source["url"]} class="text-muted hover:text-accent no-underline" onclick="event.stopPropagation()">
                  via <%= source["label"] %>
                </a>
              <% end %>
            </div>
          </div>
        <% end %>
      </div>
    </div>

    <script id="places-data" type="application/json">
      <%= Phoenix.HTML.raw(Jason.encode!(@city["places"])) %>
    </script>

    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>

    <script>
      (function () {
        var places = JSON.parse(document.getElementById('places-data').textContent);

        var map = L.map('travel-map');

        L.tileLayer('https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png', {
          maxZoom: 19,
          attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> &copy; <a href="https://carto.com/attributions">CARTO</a>'
        }).addTo(map);

        var categoryLabel = { coffee: 'C', restaurant: 'R', bar: 'B', shopping: 'S' };

        function makeIcon(color, label) {
          var letter = label || '?';
          return L.divIcon({
            html: '<div style="width:18px;height:18px;background:' + color + ';border:3px solid #111111;display:flex;align-items:center;justify-content:center;font-size:9px;font-weight:900;color:#ffffff;font-family:Inter,sans-serif;line-height:1;">' + letter + '</div>',
            className: '',
            iconSize: [18, 18],
            iconAnchor: [9, 9],
            tooltipAnchor: [9, -9]
          });
        }

        var markers = {};

        places.forEach(function (place, idx) {
          if (place.lat == null || place.lng == null) return;

          var color = place.visited ? '#e63000' : '#0047ff';
          var label = categoryLabel[place.category] || '?';
          var marker = L.marker([place.lat, place.lng], {
            icon: makeIcon(color, label)
          }).addTo(map);

          marker.bindTooltip(place.name, { direction: 'top', offset: [0, -8] });
          marker._travelCategory = place.category;

          marker.on('click', function () {
            var el = document.getElementById('place-' + idx);
            if (!el) return;
            el.scrollIntoView({ behavior: 'smooth', block: 'center' });
            el.style.borderLeftColor = '#e63000';
            el.style.color = '#e63000';
            setTimeout(function () {
              el.style.borderLeftColor = '';
              el.style.color = '';
            }, 1400);
          });

          markers[idx] = marker;
        });

        function fitVisible() {
          var visible = Object.values(markers).filter(function (m) { return map.hasLayer(m); });
          if (visible.length > 0) {
            map.fitBounds(L.featureGroup(visible).getBounds(), { padding: [40, 40] });
          } else {
            map.setView([20, 0], 2);
          }
        }

        function applyFilter(category) {
          var all = category === 'all';

          // Update list rows
          document.querySelectorAll('[data-category]').forEach(function (el) {
            el.style.display = (all || el.dataset.category === category) ? '' : 'none';
          });

          // Update markers
          Object.values(markers).forEach(function (m) {
            if (all || m._travelCategory === category) {
              if (!map.hasLayer(m)) map.addLayer(m);
            } else {
              if (map.hasLayer(m)) map.removeLayer(m);
            }
          });

          fitVisible();

          // Update button states
          document.querySelectorAll('.filter-btn').forEach(function (btn) {
            btn.dataset.active = (btn.dataset.filter === category).toString();
          });

          // Sync URL
          var url = new URL(window.location);
          if (all) {
            url.searchParams.delete('category');
          } else {
            url.searchParams.set('category', category);
          }
          history.replaceState(null, '', url);
        }

        // Apply initial filter from URL
        var initialCategory = new URL(window.location).searchParams.get('category') || 'all';
        fitVisible();
        if (initialCategory !== 'all') applyFilter(initialCategory);

        // Filter button clicks
        document.querySelectorAll('.filter-btn').forEach(function (btn) {
          btn.addEventListener('click', function () {
            applyFilter(btn.dataset.filter);
          });
        });

        // List row → map
        document.querySelectorAll('[data-idx]').forEach(function (el) {
          el.addEventListener('click', function () {
            var idx = parseInt(el.dataset.idx, 10);
            var m = markers[idx];
            if (!m) return;
            map.panTo(m.getLatLng());
            m.openTooltip();
          });
        });
      })();
    </script>
    """
  end

  defp category_classes("coffee"), do: "border-ink text-ink "
  defp category_classes("restaurant"), do: "border-ink text-ink "
  defp category_classes("bar"), do: "border-muted text-muted "
  defp category_classes("shopping"), do: "border-muted text-muted "
  defp category_classes(_), do: "border-muted text-muted "
end
