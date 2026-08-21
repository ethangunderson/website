defmodule Website.BrewRecipeTest do
  use ExUnit.Case, async: true

  alias Website.BrewRecipe

  @v60 %{
    method: "V60",
    kind: "filter",
    dose_g: 30,
    yield_g: 500,
    temp_f: 210,
    grinder: "DF54",
    grind: 70,
    steps: [
      %{stage: "Bloom", water_g: 60, time: "0:30"},
      %{stage: "Second bloom", water_g: 100, time: "0:30"},
      %{stage: "Single pour", water_g: 500, time: "1:30"}
    ]
  }

  @espresso %{
    method: "Flair 58 Plus 2",
    kind: "espresso",
    dose_g: 18,
    yield_g: 40,
    temp_f: 210,
    grinder: "DF54",
    grind: 5,
    steps: [
      %{stage: "Preinfusion", time: "0:10"},
      %{stage: "Extraction", time: "0:25"}
    ]
  }

  describe "ratio/1" do
    test "renders filter ratios to one decimal" do
      assert BrewRecipe.ratio(@v60) == "1:16.7"
    end

    test "renders espresso ratios to one decimal" do
      assert BrewRecipe.ratio(@espresso) == "1:2.2"
    end

    test "is nil when either side is missing" do
      assert BrewRecipe.ratio(%{dose_g: 30}) == nil
      assert BrewRecipe.ratio(%{yield_g: 500}) == nil
    end
  end

  describe "total_time/1" do
    test "sums step durations across the recipe" do
      assert BrewRecipe.total_time(@v60) == "2:30"
    end

    test "carries seconds into minutes" do
      assert BrewRecipe.total_time(@espresso) == "0:35"
    end

    test "is nil when no step carries a time" do
      assert BrewRecipe.total_time(%{steps: [%{stage: "Bloom"}]}) == nil
    end

    test "raises on a malformed duration rather than rendering garbage" do
      assert_raise ArgumentError, fn ->
        BrewRecipe.total_time(%{steps: [%{stage: "Bloom", time: "thirty"}]})
      end
    end
  end

  describe "spec_parts/1" do
    test "orders segments dose, temp, grind, total" do
      assert BrewRecipe.spec_parts(@v60) == [
               "30g in / 500g out (1:16.7)",
               "210°F",
               "DF54 at 70",
               "2:30 total"
             ]
    end

    test "omits segments whose fields are absent" do
      parts = BrewRecipe.spec_parts(%{dose_g: 18, yield_g: 40, steps: []})
      assert parts == ["18g in / 40g out (1:2.2)"]
    end
  end

  describe "label/1" do
    test "joins kind and method" do
      assert BrewRecipe.label(@v60) == "Filter — V60"
      assert BrewRecipe.label(@espresso) == "Espresso — Flair 58 Plus 2"
    end

    test "falls back to method alone when kind is absent" do
      assert BrewRecipe.label(%{method: "Aeropress"}) == "Aeropress"
    end
  end

  describe "has_water?/1" do
    test "is true when any step carries a cumulative water figure" do
      assert BrewRecipe.has_water?(@v60)
    end

    test "is false for espresso, where the yield is the water" do
      refute BrewRecipe.has_water?(@espresso)
    end
  end
end
