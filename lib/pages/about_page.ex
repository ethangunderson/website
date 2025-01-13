defmodule Website.AboutPage do
  use Tableau.Page,
    layout: Website.PageLayout,
    permalink: "/",
    title: "about"

  use Phoenix.Component

  def template(assigns) do
    ~H"""
    <p>
      Hi! I'm a software engineer residing in Minneapolis, MN. I currently work at Cars Commerce as a principal engineer. My professional interests lie in distributed systems, observability engineering, and software architecture. Those all sound more serious than they need to be.
    </p>
    <p>
      2017's 136784th World's Fittest Man.
    </p>
    <p>
      Weird coffee person.
    </p>
    <p>
      Here to make friends. Send me an <a href="mailto:ethan@ethangunderson.com">email</a>.
    </p>
    <hr />
    <section>
      <h3 class="text-xl font-base mb-5">Latest writing</h3>
      <% post = List.first(@posts) %>
      <article class="flex flex-col space-y-2">
        <span>
          <h3 class="text-xl font-base m-0"><%= post.title %></h3>
          <%= post.date |> Calendar.strftime("%b %d %Y") %>
        </span>
        <span>
          <%= post.description %>
          <a class="text-base flex" href={post.permalink}>
            <h3 class="text-lg font-base m-0">Keep reading</h3>
          </a>
        </span>
      </article>
    </section>
    <hr />
    <section>
      <h3 class="text-xl font-base mb-5">Interviews and talks</h3>
      <ul class="list-none pl-0">
        <%= for i <- @data["interviews"] do %>
          <li class="p-0">
            <a href={i["link"]}><%= i["name"] %></a> (<%= i["year"] %>)
          </li>
        <% end %>
      </ul>
    </section>
    """
  end
end
