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
      I like to help developers figure out what goes bump in the night.
    </p>
    <p>
      I make things that sometimes work.
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
    """
  end
end
