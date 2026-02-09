defmodule Website.AboutPage do
  use Tableau.Page,
    layout: Website.PageLayout,
    permalink: "/",
    title: "Ethan Gunderson",
    og_title: "Ethan Gunderson — Principal Engineer, Author, Builder",
    hide_title: true

  use Phoenix.Component
  import Website.Component

  def template(assigns) do
    ~H"""
    <section class="space-y-5 mb-12">
      <p class="text-2xl font-heading">
        Hey, I'm Ethan.
      </p>
      <p>
        I'm a principal software engineer at <a href="https://cars.com">Cars Commerce</a> with twenty years of experience building software. I care about performance, observability, and shipping things that people find useful.
      </p>
      <p>
        I'm currently writing a book on instrumenting Elixir applications. Before that, I started <a href="https://github.com/chicagodb/chicagodb.github.com">ChicagoDB</a> and <a href="https://paperswelove.org/chapter/chicago/">Papers We Love Chicago</a>, hosted <a href="https://podcasts.apple.com/be/podcast/growing-software/id1566244538">a podcast</a>, and built a bunch of things that taught me a lot.
      </p>
      <p>
        Off the clock I'm a dad to two boys, an avid cook, and a BJJ white belt. I enjoy coffee too much, have a thing for stationery and well-made objects, and was once 2017's 136,784th World's Fittest Man. I'll make you watch The Bear and The West Wing if you let me.
      </p>
    </section>

    <hr />

    <section class="my-12">
      <h2 class="text-2xl font-heading mb-6">Currently</h2>
      <.book_callout />
      <% post = List.first(@posts) %>
      <div class="mt-8">
        <h3 class="text-xl font-heading m-0 mb-1">Latest writing</h3>
        <article class="mt-2">
          <a href={post.permalink} class="text-lg"><%= post.title %></a>
          <span class="text-sm text-grille ml-2"><%= post.date |> Calendar.strftime("%b %Y") %></span>
          <p class="mt-1 text-base"><%= post.description %></p>
        </article>
      </div>
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
        Send me an <a href="mailto:ethan@ethangunderson.com">email</a> or find me on
        <a href="https://bsky.app/profile/ethangunderson.com">Bluesky</a>.
      </p>
    </section>
    """
  end
end
