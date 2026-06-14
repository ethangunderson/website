defmodule Website.NowPage do
  use Tableau.Page,
    layout: Website.RootLayout,
    permalink: "/now",
    title: "Now",
    hide_title: true

  use Phoenix.Component

  def template(assigns) do
    ~H"""
    <div class="not-prose">
      <h1 class="text-[2.25rem] font-extrabold uppercase tracking-tight leading-[1.1] mb-6 pb-4 border-b-4 border-ink">
        Now
      </h1>

      <% {log, _} = System.cmd("git", ["log", "-1", "--format=%as", "--", "_data/now.yml"])
         updated_at = case Date.from_iso8601(String.trim(log)) do
           {:ok, date} -> Calendar.strftime(date, "%b %d %Y")
           _ -> Calendar.strftime(Date.utc_today(), "%b %d %Y")
         end %>
      <span class="text-[0.72rem] font-bold uppercase tracking-[0.07em] text-muted block mb-8">
        Updated <%= updated_at %>
      </span>

      <span class="block my-8">
      Snapshot of where my attention is going these days. Lightly maintained. This only changes when the inputs do.
      </span>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-x-10 gap-y-8 mb-8">
        <%= for section <- @data["now"]["sections"] do %>
          <section>
            <h2 class="text-[0.78rem] font-extrabold uppercase tracking-[0.1em] pb-2 border-b-2 border-ink mb-3"><%= section["title"] %></h2>
            <p class="leading-[1.55]"><%= Phoenix.HTML.raw(section["body"]) %></p>
          </section>
        <% end %>

        <% latest_coffee = @posts |> Enum.filter(&(&1[:categories] == "coffee")) |> Enum.sort_by(& &1.date, {:desc, Date}) |> List.first() %>
        <%= if latest_coffee do %>
          <section>
            <h2 class="text-[0.78rem] font-extrabold uppercase tracking-[0.1em] pb-2 border-b-2 border-ink mb-3">Coffee</h2>
            <p class="leading-[1.55]">
              <a href={latest_coffee.permalink} class="underline hover:text-accent transition-colors duration-75"><%= latest_coffee.title %></a>
              — <%= latest_coffee[:roaster] %> · <span class="text-accent"><%= String.duplicate("★", latest_coffee[:rating]) %></span><span class="text-muted"><%= String.duplicate("☆", 7 - latest_coffee[:rating]) %></span>
            </p>
          </section>
        <% end %>
      </div>

      <section class="mb-8 pt-10">
        <h2 class="text-xlg font-extrabold uppercase tracking-[0.1em] pb-2 border-b-2 border-ink mb-5">Open questions</h2>
        <ol class="list-none p-0 m-0 flex flex-col gap-5">
          <%= for {q, i} <- Enum.with_index(@data["now"]["open_questions"]) do %>
            <.open_question number={String.pad_leading(Integer.to_string(i + 1), 2, "0")} heading={q["heading"]}>
              <%= q["body"] %>
            </.open_question>
          <% end %>
        </ol>
      </section>

      <p class="mb-2">Get in touch — <a href="mailto:ethan@ethangunderson.com" class="underline hover:text-accent transition-colors duration-75">ethan@ethangunderson.com</a></p>

      <p class="text-[0.875rem] text-muted">Inspired by <a href="https://nownownow.com/about" class="underline hover:text-accent transition-colors duration-75">Derek Sivers' /now movement</a>.</p>
    </div>
    """
  end

  attr(:number, :string, required: true)
  attr(:heading, :string, required: true)
  slot(:inner_block, required: true)

  defp open_question(assigns) do
    ~H"""
    <li class="grid grid-cols-[2.25rem_1fr] gap-2 items-baseline">
      <span class="text-base font-extrabold text-accent leading-none tracking-tight"><%= @number %></span>
      <div>
        <p class="text-[0.95rem] font-bold uppercase tracking-[0.04em] mb-1"><%= @heading %></p>
        <p class="leading-[1.55]"><%= render_slot(@inner_block) %></p>
      </div>
    </li>
    """
  end
end
