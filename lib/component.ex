defmodule Website.Component do
  use Phoenix.Component

  attr :name_class, :string, default: "text-2xl font-extrabold uppercase leading-[1.05] tracking-tight mb-2"
  attr :subtitle_class, :string, default: "text-[0.72rem] text-muted uppercase tracking-wider leading-snug"

  def site_header(assigns) do
    ~H"""
    <p class={@name_class}>Ethan<br />Gunderson</p>
    <p class={@subtitle_class}>Software Engineer.<br />Author. Builder.</p>
    """
  end

  def rating_display(assigns) do
    ~H"""
    <span class="relative inline-flex items-baseline gap-1 group not-prose">
      <span class="text-accent font-mono text-lg tracking-wider" aria-label={"#{@rating} out of 7"}><%= String.duplicate("★", @rating) <> String.duplicate("☆", 7 - @rating) %></span>
      <span class="text-muted text-xs cursor-default select-none leading-none self-center">ⓘ</span>
      <div class="hidden group-hover:block absolute bottom-full left-0 mb-2 w-56 bg-ink text-site-bg text-xs p-3 space-y-1 z-10 pointer-events-none">
        <div><strong>7</strong> — Perfect, must try, life-changing</div>
        <div><strong>6</strong> — Excellent, worth repeating. Go out of your way.</div>
        <div><strong>5</strong> — Good, don't go out of your way, but enjoyable.</div>
        <div><strong>4</strong> — Passable, works in a pinch</div>
        <div><strong>3</strong> — Bad, don't do this if you can</div>
        <div><strong>2</strong> — Atrocious, actively avoid</div>
        <div><strong>1</strong> — Evil, life-changing in a bad way</div>
      </div>
    </span>
    """
  end

  def project_card(assigns) do
    ~H"""
    <div class={[
      "glow-hover rounded p-3 -ml-3",
      if(@active, do: "border-l-4 border-amber pl-4", else: "opacity-80")
    ]}>
      <%= if @project["link"] do %>
        <a href={@project["link"]} class="text-lg"><%= @project["name"] %></a>
      <% else %>
        <span class="text-lg"><%= @project["name"] %></span>
      <% end %>
      <p class="mt-1 text-base"><%= @project["description"] %></p>
    </div>
    """
  end

  def book_callout(assigns) do
    ~H"""
    <div class="border-l-4 border-amber bg-surface p-6 my-6 rounded glow-hover">
      <h3 class="text-xl font-heading m-0 mb-2">
        <a href="https://www.instrumentingelixir.com/">Instrumenting Elixir Applications</a>
      </h3>
      <p class="m-0 text-base">
        A workshop and book on how to instrument Elixir applications using Telemetry and OpenTelemetry. Currently in progress.
      </p>
    </div>
    """
  end
end
