defmodule Website.WritingPage do
  use Tableau.Page,
    layout: Website.PageLayout,
    permalink: "/writing",
    title: "writing"

  use Phoenix.Component

  def template(assigns) do
    ~H"""
    <section>
      <h3 class="text-xl font-base mb-5">latest</h3>
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
    <section class="max-w-2xl mb-8">
      <h3 class="text-xl font-base mb-5">writing</h3>
      <article :for={post <- @posts} class="mt-2 flex space-x-2">
        <time><%= post.date |> Calendar.strftime("%b %y") %></time>
        <a class="text-base flex" href={post.permalink}>
          <h3 class="text-lg font-base m-0"><%= post.title %></h3>
        </a>

        <a class="no-underline text-base flex" href={post.permalink}></a>
      </article>
    </section>
    """
  end
end
