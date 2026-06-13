defmodule Website.OgImagePage do
  use Tableau.Page,
    layout: Website.OgImageLayout,
    permalink: "/og-image",
    title: "OG Image"

  use Phoenix.Component

  def template(assigns) do
    ~H"""
    """
  end
end
