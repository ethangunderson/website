defmodule Website.AboutPage do
  use Tableau.Page,
    layout: Website.PageLayout,
    permalink: "/",
    title: "Ethan Gunderson",
    og_title: "Ethan Gunderson — Software Engineer, Author, Builder",
    hide_title: true

  use Phoenix.Component

  def template(assigns) do
    ~H"""
    <section class="space-y-5 mb-12">
      <p class="text-2xl font-heading">
        Hey, I'm Ethan.
      </p>
      <p>
        I'm a principal software engineer at <a href="https://cars.com">Cars Commerce</a>
        with twenty years of experience building software. I care about performance, observability, and shipping things that people find useful.
      </p>
      <p>
        I'm currently writing a book on instrumenting Elixir applications. Before that, I started
        <a href="https://github.com/chicagodb/chicagodb.github.com">ChicagoDB</a>
        and <a href="https://paperswelove.org/chapter/chicago/">Papers We Love Chicago</a>, hosted <a href="https://podcasts.apple.com/be/podcast/growing-software/id1566244538">a podcast</a>, and built a bunch of things that taught me a lot.
      </p>
      <p>
        Off the clock I'm a dad to two boys, an avid cook, and a BJJ white belt. I enjoy coffee too much, have a thing for stationery and well-made objects, and was once 2017's 136,784th World's Fittest Man. I'll make you watch The Bear and The West Wing if you let me.
      </p>
    </section>

    <hr />

    <section class="my-12">
      <% activity =
        @posts
        |> Enum.filter(&(&1[:categories] in ["post", "coffee", "media"]))
        |> Enum.sort_by(& &1.date, {:desc, Date})
        |> Enum.take(15) %>
      <h2 class="text-2xl font-heading mb-6">Recent activity</h2>
      <ul class="list-none pl-0 space-y-3">
        <%= for post <- activity do %>
          <% {type_label, type_color} = cond do
            post[:categories] == "post" -> {"writing", "bg-accent text-site-bg"}
            post[:categories] == "coffee" -> {"coffee", "bg-accent-blue text-site-bg"}
            post[:type] -> {post[:type], "bg-accent-blue text-site-bg"}
            true -> {"media", "bg-accent-blue text-site-bg"}
          end %>
          <% context = cond do
            post[:categories] == "coffee" && post[:roaster] -> post[:roaster]
            post[:categories] == "media" && post[:creator] -> post[:creator]
            true -> nil
          end %>
          <li class="flex items-baseline gap-3 text-sm">
            <time class="text-grille whitespace-nowrap w-12 shrink-0">
              <%= post.date |> Calendar.strftime("%b %d") %>
            </time>
            <span class={"#{type_color} text-xs font-heading uppercase px-2 py-1 shrink-0 leading-none"}>
              <%= type_label %>
            </span>
            <span>
              <a href={post.permalink}><%= post.title %></a>
              <%= if context do %>
                <span class="text-grille"> — <%= context %></span>
              <% end %>
              <%= if post[:rating] do %>
                <span class="text-grille text-xs ml-1"><%= String.duplicate("★", post[:rating]) %></span>
              <% end %>
            </span>
          </li>
        <% end %>
      </ul>
    </section>

    <hr />

    <section class="my-12">
      <h2 class="text-2xl font-heading mb-6">Speaking & community</h2>
      <p>
        Want me to come on your podcast or speak at your event? <a href="mailto:ethan@ethangunderson.com">Get in touch</a>.
      </p>
      <ul class="list-none pl-0 mt-4 space-y-1">
        <%= for i <- @data["interviews"] do %>
          <li>
            <a href={i["link"]}><%= i["name"] %></a>
            <span class="text-sm text-grille">(<%= i["year"] %>)</span>
          </li>
        <% end %>
      </ul>
    </section>

    <hr />

    <section class="my-12">
      <h2 class="text-2xl font-heading mb-4">Let's connect</h2>
      <p>
        I'm always up for a conversation about Elixir, observability, or whatever you're building.
        Send me an <a href="mailto:ethan@ethangunderson.com">email</a>
        or find me on <a href="https://bsky.app/profile/ethangunderson.com">Bluesky</a>.
      </p>
    </section>
    """
  end
end
