defmodule RentCars.CarsFixtures do
  alias RentCars.Cars
  import RentCars.CategoriesFixtures

  def car_attrs(attrs \\ %{}) do
    category = category_fixture()

    valid_attrs = %{
      name: "some car name",
      description: "some car description",
      brand: "some brand",
      daily_rate: 1000,
      license_plate: "asdf #{:rand.uniform(10_000)}",
      fine_amount: 30,
      category_id: category.id,
      specifications: [
        %{name: "wheels", description: "some description"},
        %{name: "pumpkin wheels", description: "some description"}
      ]
    }

    Enum.into(attrs, valid_attrs)
  end

  def car_fixture(attrs \\ %{}) do
    {:ok, car} =
      attrs
      |> car_attrs()
      |> Cars.create()

    car
  end
end
