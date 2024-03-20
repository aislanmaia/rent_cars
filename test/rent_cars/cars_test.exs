defmodule RentCars.CarsTest do
  use RentCars.DataCase

  alias RentCars.Cars
  import RentCars.{CategoriesFixtures, CarsFixtures}

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

  describe "Cars.create/1" do
    test "should create a car with success", %{payload: payload} do
      assert {:ok, car} = Cars.create(payload)
      assert car.name == payload.name
      assert car.description == payload.description
      assert car.brand == payload.brand
      assert car.daily_rate == payload.daily_rate
      assert car.license_plate == String.upcase(payload.license_plate)
      assert car.fine_amount == payload.fine_amount
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
end
