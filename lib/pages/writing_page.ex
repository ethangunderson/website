defmodule Website.WritingPage do
  use Tableau.Page,
    layout: Website.PageLayout,
    permalink: "/notes",
    title: "Notes"

  use Phoenix.Component

  def template(assigns) do
    ~H"""
    <section class="not-prose">
      <% writing_posts =
        @posts
        |> Enum.filter(&(&1[:categories] == "post"))
        |> Enum.sort_by(& &1.date, {:desc, NaiveDateTime}) %>
      <% [latest | rest] = writing_posts %>
      <% posts_by_year = Enum.group_by(rest, & &1.date.year) %>

      <a href={latest.permalink} class="no-underline block">
      <div class="border-l-4 border-b-4 border-l-accent border-b-black pl-4 flex flex-col gap-2 py-5 mb-10">
        <p class="text-xs font-heading uppercase text-accent tracking-wider leading-none">
          Latest <span class="text-muted font-normal normal-case tracking-normal ml-2"><%= latest.date |> Calendar.strftime("%b %d %Y") |> String.upcase() %></span>
        </p>
          <h2 class="text-2xl font-heading leading-none uppercase"><%= latest.title %></h2>
        <%= if latest[:description] do %>
          <p class="text-base text-muted leading-snug"><%= latest.description %></p>
        <% end %>
      </div>
      </a>

      <div class="space-y-10">
      <%= for {year, posts} <- Enum.sort_by(posts_by_year, fn {year, _} -> year end, :desc) do %>
        <% count = length(posts) %>
        <div>
          <div class="flex items-baseline gap-3 border-b-2 border-ink pb-2 mb-3">
            <h2 class="text-3xl font-heading font-black"><%= year %></h2>
            <span class="text-[0.72rem] font-bold uppercase tracking-[0.09em] text-muted">
              <%= count %> <%= if count == 1, do: "note", else: "notes" %>
            </span>
          </div>
          <div class="space-y-3">
            <%= for post <- Enum.sort_by(posts, & &1.date, {:desc, NaiveDateTime}) do %>
              <% {_type, badge_class, context} = cond do
                "talks" in (post[:tags] || []) ->
                  {:talk, "bg-ink text-site-bg", post[:event]}
                "link" in (post[:tags] || []) ->
                  {:link, "bg-muted text-site-bg", post[:link_url] && URI.parse(post[:link_url]).host}
                true ->
                  {:post, "bg-accent text-site-bg", nil}
              end %>
              <% label = cond do
                "talks" in (post[:tags] || []) -> "talk"
                "link" in (post[:tags] || []) -> "link"
                true -> "post"
              end %>
              <a href={post.permalink} class="no-underline block">
              <div class="flex items-center gap-4 text-lg">
                <time class="font-bold whitespace-nowrap w-14 shrink-0 text-muted">
                  <%= post.date |> Calendar.strftime("%b %d") |> String.upcase() %>
                </time>
                <span class={"#{badge_class} text-xs font-heading uppercase px-2 py-0.5 shrink-0 leading-none"}>
                  <%= label %>
                </span>
                <span>
                  <%= post.title %>
                  <%= if context do %>
                    <span class="text-muted"> — <%= context %></span>
                  <% end %>
                </span>
              </div>
              </a>
            <% end %>
          </div>
        </div>
      <% end %>
      </div>
    </section>
    """
  end
end
