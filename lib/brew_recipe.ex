defmodule Website.BrewRecipe do
  @moduledoc """
  Pure helpers over brew recipe frontmatter.

  Ratio and total time are derived here rather than stored in the markdown, so
  a recipe's stated numbers can never drift from its displayed summary.
  """

  def ratio(%{dose_g: dose, yield_g: yield})
      when is_number(dose) and is_number(yield) and dose > 0 do
    "1:" <> :erlang.float_to_binary(yield / dose, decimals: 1)
  end

  def ratio(_), do: nil

  def total_time(%{steps: steps}) when is_list(steps) do
    steps
    |> Enum.map(& &1[:time])
    |> Enum.reject(&is_nil/1)
    |> case do
      [] -> nil
      times -> times |> Enum.map(&to_seconds/1) |> Enum.sum() |> format_seconds()
    end
  end

  def total_time(_), do: nil

  def spec_parts(recipe) do
    total = total_time(recipe)

    [
      dose_part(recipe),
      recipe[:temp_f] && "#{recipe[:temp_f]}°F",
      grind_part(recipe),
      total && "#{total} total"
    ]
    |> Enum.reject(&is_nil/1)
  end

  def label(%{kind: kind, method: method}) when is_binary(kind) do
    "#{String.capitalize(kind)} — #{method}"
  end

  def label(%{method: method}), do: method

  def has_water?(%{steps: steps}) when is_list(steps) do
    Enum.any?(steps, &is_number(&1[:water_g]))
  end

  def has_water?(_), do: false

  defp dose_part(%{dose_g: dose, yield_g: yield} = recipe)
       when is_number(dose) and is_number(yield) do
    "#{dose}g in / #{yield}g out (#{ratio(recipe)})"
  end

  defp dose_part(_), do: nil

  defp grind_part(%{grinder: grinder, grind: grind})
       when not is_nil(grinder) and not is_nil(grind) do
    "#{grinder} at #{grind}"
  end

  defp grind_part(_), do: nil

  defp to_seconds(time) do
    case String.split(time, ":") do
      [minutes, seconds] -> String.to_integer(minutes) * 60 + String.to_integer(seconds)
      _ -> raise ArgumentError, "malformed step duration: #{inspect(time)}"
    end
  end

  defp format_seconds(total) do
    "#{div(total, 60)}:#{String.pad_leading(to_string(rem(total, 60)), 2, "0")}"
  end
end
