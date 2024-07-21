defmodule Website.PageLayout do
  use Tableau.Layout, layout: Website.RootLayout
  use Phoenix.Component

  def template(assigns) do
    ~H"""
    <article>
      <%= {:safe, render(@inner_content)} %>
    </article>
    """
  end
end
