defmodule Website.BookPage do
  use Tableau.Page,
    layout: Website.PageLayout,
    permalink: "/book",
    title: "Instrumenting Elixir",
    description:
      "A practical guide to making your Elixir applications observable — telemetry, tracing, metrics, and more."

  use Phoenix.Component

  def template(assigns) do
    ~H"""
    <section class="space-y-6 mb-12">
      <p class="text-2xl font-heading">Instrumenting Elixir</p>
      <p class="text-lg text-grille">A book by Ethan Gunderson</p>
      <p>
        Elixir gives you the building blocks for highly reliable, concurrent systems.
        But reliability without visibility is just hope.
      </p>
      <p>
        <em>Instrumenting Elixir</em> is a practical guide to making your applications observable —
        from adding structured telemetry to your domain logic, to wiring up metrics and dashboards,
        to tracing requests across distributed services.
      </p>
      <p>
        You'll learn to use Elixir's native telemetry ecosystem — <code>:telemetry</code>,
        <code>:telemetry_metrics</code>, OpenTelemetry, and more — to answer the questions
        that matter in production: What's happening right now? Why did that request fail?
        Where is the bottleneck?
      </p>
    </section>

    <hr />

    <section class="my-12 space-y-6">
      <h2 class="text-2xl font-heading">What you'll learn</h2>
      <ul class="list-none pl-0 space-y-2">
        <li>How to instrument your own code with <code>:telemetry</code> events</li>
        <li>Metrics collection and visualization with <code>:telemetry_metrics</code> and Prometheus</li>
        <li>Distributed tracing with OpenTelemetry across Phoenix, Ecto, and LiveView</li>
        <li>Structured logging that actually helps you debug production issues</li>
        <li>Building dashboards and alerts that tell you something useful</li>
        <li>Observability patterns for GenServers, Broadway pipelines, and Oban jobs</li>
      </ul>
    </section>

    <hr />

    <section class="my-12 space-y-6">
      <h2 class="text-2xl font-heading">Get notified when it ships</h2>
      <p>
        The book is well underway. Drop your email and I'll let you know when it's ready —
        no noise, just a note when there's something worth reading.
      </p>
      <form
        action="https://buttondown.com/api/emails/embed-subscribe/instrumentingelixir"
        method="post"
        target="popupwindow"
        onsubmit="window.open('https://buttondown.com/instrumentingelixir', 'popupwindow')"
        class="flex gap-2 flex-wrap"
      >
        <input
          type="email"
          name="email"
          placeholder="you@example.com"
          required
          class="border-2 border-ink bg-site-bg px-3 py-2 text-sm flex-1 min-w-48 focus:outline-none focus:border-accent"
        />
        <button
          type="submit"
          class="border-2 border-ink bg-ink text-site-bg px-4 py-2 text-sm font-heading uppercase tracking-wide hover:bg-accent hover:border-accent transition-colors duration-75 cursor-pointer"
        >
          Notify me
        </button>
      </form>
    </section>
    """
  end
end
