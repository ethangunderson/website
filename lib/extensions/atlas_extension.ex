defmodule Website.AtlasExtension do
  use Tableau.Extension, key: :atlas, type: :pre_build, priority: 250

  alias Tableau.Extension.Common

  @cache_path "_atlas/.geocache.json"
  @nominatim_url "https://nominatim.openstreetmap.org/search"
  @user_agent "ethangunderson.com/atlas-geocoder"

  @impl Tableau.Extension
  def run(token) do
    cache = load_cache()

    {places_with_coords, cache} =
      "_atlas/*.md"
      |> Path.wildcard()
      |> Enum.sort()
      |> Common.entries(fn %{front_matter: fm, pre_convert_body: body} ->
        notes = String.trim(body)

        fm
        |> Map.new(fn {k, v} -> {to_string(k), v} end)
        |> Map.put("notes", if(notes == "", do: nil, else: notes))
        |> Map.put("discovered_via", fm[:discovered_via] || [])
      end)
      |> Enum.reduce({[], cache}, fn place, {acc, cache} ->
        {place, cache} = resolve_coords(place, cache)
        {acc ++ [place], cache}
      end)

    save_cache(cache)

    cities =
      places_with_coords
      |> Enum.group_by(& &1["city"])
      |> Enum.map(fn {slug, places} ->
        first = hd(places)

        %{
          "slug" => slug,
          "name" => first["city_name"],
          "country" => first["city_country"],
          "region" => first["city_region"],
          "places" => places
        }
      end)
      |> Enum.sort_by(& &1["name"])

    pages =
      Enum.map(cities, fn city ->
        slug = city["slug"]

        %Tableau.Page{
          parent: Website.PageLayout,
          permalink: "/atlas/#{slug}",
          template: fn assigns ->
            Website.AtlasCityTemplate.render(Map.put(assigns, :city, city))
          end,
          opts: %{title: city["name"], permalink: "/atlas/#{slug}"}
        }
      end)

    graph = Tableau.Graph.insert(token.graph, pages)

    {:ok,
     token
     |> Map.put(:atlas_cities, cities)
     |> Map.put(:graph, graph)}
  end

  defp resolve_coords(%{"lat" => lat, "lng" => lng} = place, cache)
       when is_number(lat) and is_number(lng) do
    {place, cache}
  end

  defp resolve_coords(%{"address" => address} = place, cache) when is_binary(address) do
    case Map.fetch(cache, address) do
      {:ok, %{"lat" => lat, "lng" => lng}} ->
        {Map.merge(place, %{"lat" => lat, "lng" => lng}), cache}

      :error ->
        case geocode(address) do
          {:ok, lat, lng} ->
            entry = %{"lat" => lat, "lng" => lng}
            cache = Map.put(cache, address, entry)
            {Map.merge(place, %{"lat" => lat, "lng" => lng}), cache}

          :error ->
            IO.warn(
              "AtlasExtension: could not geocode \"#{address}\" — place will appear in list but not on map"
            )

            {place, cache}
        end
    end
  end

  defp resolve_coords(place, cache), do: {place, cache}

  defp geocode(address) do
    :inets.start()
    :ssl.start()

    query = URI.encode_query(%{"q" => address, "format" => "json", "limit" => "1"})
    url = "#{@nominatim_url}?#{query}" |> String.to_charlist()
    headers = [{~c"User-Agent", @user_agent}, {~c"Accept", "application/json"}]

    # Nominatim usage policy: max 1 req/sec
    Process.sleep(1100)

    case :httpc.request(:get, {url, headers}, [{:ssl, [{:verify, :verify_none}]}], []) do
      {:ok, {{_, 200, _}, _, body}} ->
        case Jason.decode!(to_string(body)) do
          [%{"lat" => lat, "lon" => lon} | _] ->
            {:ok, String.to_float(lat), String.to_float(lon)}

          _ ->
            :error
        end

      _ ->
        :error
    end
  end

  defp load_cache do
    case File.read(@cache_path) do
      {:ok, contents} -> Jason.decode!(contents)
      {:error, _} -> %{}
    end
  end

  defp save_cache(cache) do
    File.write!(@cache_path, Jason.encode!(cache, pretty: true))
  end
end
