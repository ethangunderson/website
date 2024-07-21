defmodule Website.WritingPage do
  use Tableau.Page,
    layout: Website.PageLayout,
    permalink: "/writing",
    title: "writing"

  use Phoenix.Component

  def template(assigns) do
    ~H"""
    <section class="max-w-2xl mx-auto mb-8">
      Notes for those who come later
      <article :for={post <- @posts} class="mt-8">
        <a class="no-underline text-base flex items-center justify-between" href={post.permalink}>
          <h3 class="text-base font-base m-0"><%= post.title %></h3>
          <time><%= post.date |> Calendar.strftime("%b %d %Y") %></time>
        </a>

        <a class="no-underline text-base flex" href={post.permalink}></a>
      </article>
    </section>
    """
  end
end
