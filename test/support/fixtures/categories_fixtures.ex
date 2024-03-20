defmodule RentCars.CategoriesFixtures do
  alias RentCars.Categories

  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        name: "some category name #{:rand.uniform(10_000)}",
        description: "some category description #{:rand.uniform(10_000)}"
      })
      |> Categories.create_category()

    category
  end
end
