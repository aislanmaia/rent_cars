defmodule RentCars.CarsTest do
  import RentCars.{CategoriesFixtures, CarsFixtures}
  use RentCars.DataCase

  alias RentCars.Cars

  setup do
    category = category_fixture()

    payload = %{
      name: "Lancer",
      description: "Good car",
      brand: "Mistsubishi",
      daily_rate: 1000,
      license_plate: "asdf 1013",
      fine_amount: 30,
      category_id: category.id,
      specifications: [
        %{name: "wheels", description: "some description"},
        %{name: "pumpkin wheels", description: "some description"}
      ]
    }

    %{payload: payload}
  end

  describe "Cars.get_car!/1" do
    test "can have associations loaded", %{payload: payload} do
      specifications =
        car_fixture(%{specifications: payload.specifications})
        |> Cars.with_assoc([:specifications])
        |> Map.get(:specifications)

      Enum.each(specifications, fn specification ->
        assert specification.name in Enum.map(payload.specifications, & &1.name)
        assert specification.description in Enum.map(payload.specifications, & &1.description)
      end)
    end
  end

  describe "Cars.create/1" do
    test "should create a car with success", %{payload: payload} do
      assert {:ok, car} = Cars.create(payload)
      assert car.name == payload.name
      assert car.description == payload.description
      assert car.brand == payload.brand
      assert car.daily_rate == payload.daily_rate
      assert car.license_plate == String.upcase(payload.license_plate)
      assert car.fine_amount == Money.new(payload.fine_amount)
      assert car.category_id == payload.category_id
      assert car.available == true

      Enum.each(car.specifications, fn specification ->
        assert specification.name in Enum.map(payload.specifications, & &1.name)
        assert specification.description in Enum.map(payload.specifications, & &1.description)
      end)
    end

    test "should not permit duplicated license_plate", %{payload: payload} do
      assert {:ok, _} = Cars.create(payload)

      assert {:error, changeset} = Cars.create(payload)
      assert "has already been taken" in errors_on(changeset).license_plate
    end

    test "should not missing required fields" do
      attrs = %{}

      assert {:error, changeset} = Cars.create(attrs)

      assert %{name: ["can't be blank"]} = errors_on(changeset)
      assert %{description: ["can't be blank"]} = errors_on(changeset)
      assert %{brand: ["can't be blank"]} = errors_on(changeset)
      assert %{daily_rate: ["can't be blank"]} = errors_on(changeset)
      assert %{fine_amount: ["can't be blank"]} = errors_on(changeset)
      assert %{license_plate: ["can't be blank"]} = errors_on(changeset)
      assert %{category_id: ["can't be blank"]} = errors_on(changeset)
    end
  end

  describe "Cars.update/1" do
    test "should update a car with success" do
      car = car_fixture()
      payload = %{name: "Lancer 2032"}

      assert {:ok, car} = Cars.update(car.id, payload)

      assert car.name == payload.name
    end

    test "should throw an error when trying to update license_plate" do
      car = car_fixture()
      payload = %{license_plate: "new license plate"}

      assert {:error, changeset} = Cars.update(car.id, payload)
      assert "you can't update license_plate" in errors_on(changeset).license_plate
    end
  end

  describe "Cars.list_available_cars/0" do
    test "list all available cars" do
      category = category_fixture()
      car_fixture(%{category_id: category.id})
      car_fixture(%{category_id: category.id, name: "pumpkin"})
      car_fixture(%{available: false, category_id: category.id})

      assert Cars.list_available_cars() |> Enum.count() == 2

      assert Cars.list_available_cars(name: "pump") |> Enum.count() == 1
    end

    test "list all available cars by brand" do
      category = category_fixture()
      car_fixture(%{category_id: category.id, brand: "pumpkin"})
      car_fixture(%{category_id: category.id, name: "tesla"})

      assert Cars.list_available_cars() |> Enum.count() == 2

      assert Cars.list_available_cars(brand: "pump") |> Enum.count() == 1
    end

    test "list all available cars by category" do
      category = category_fixture(%{name: "pumpking"})
      car_fixture(%{brand: "pumpkin"})
      car_fixture(%{category_id: category.id, name: "pumpkin"})

      assert Cars.list_available_cars() |> Enum.count() == 2

      assert Cars.list_available_cars(category: "pump") |> Enum.count() == 1
    end
  end
end
