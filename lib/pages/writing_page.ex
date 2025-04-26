defmodule Website.WritingPage do
  use Tableau.Page,
    layout: Website.PageLayout,
    permalink: "/writing",
    title: "Writing"

  use Phoenix.Component

  def template(assigns) do
    ~H"""
    <section class="max-w-2xl mb-8">
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
