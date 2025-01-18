defmodule Website.AboutPage do
  use Tableau.Page,
    layout: Website.PageLayout,
    permalink: "/",
    title: "about",
    hide_title: true

  use Phoenix.Component

  def template(assigns) do
    ~H"""
    <p>
      Hey 👋🏻 I'm Ethan.
    </p>
    <p>
      I'm a software engineer living in Minneapolis, MN. I work at Cars Commerce as a principal software engineer. My professional interests lie in distributed systems, observability engineering, and software architecture. Those all sound more serious than they need to be.
    </p>
    <p>
      2017's 136784th World's Fittest Man. BJJ white belt.
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
      <p>
        Want me to come on your podcast or speak at your event? <a href="mailto:ethan@ethangunderson.com">Get in touch</a>.
      </p>
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
