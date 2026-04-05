defmodule Website.PostLayout do
  use Tableau.Layout, layout: Website.RootLayout
  use Phoenix.Component

  def template(assigns) do
    ~H"""
    <%= {:safe, render(@inner_content)} %>
    <div data-peepmetrics-cheers></div>
    <script src="https://peepmetrics.com/cheers.js" data-token="izRiEhBmlc9R0YIFUHqa9" async></script>
    """
  end
end
