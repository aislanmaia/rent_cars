defmodule RentCarsWeb.Api.CategoryJsonTest do
  use ExUnit.Case
  alias RentCarsWeb.Api.CategoryJSON
  alias RentCars.Categories.Category

  test "index returns a map with data key" do
    categories = [
      %Category{name: "test1", description: "test description1", id: 1},
      %Category{name: "test2", description: "test description2", id: 2}
    ]

    assert %{
             data: [
               %{
                 description: "test description1",
                 id: 1,
                 name: "test1"
               },
               %{
                 description: "test description2",
                 id: 2,
                 name: "test2"
               }
             ]
           } ==
             CategoryJSON.index(%{categories: categories})
  end
end
