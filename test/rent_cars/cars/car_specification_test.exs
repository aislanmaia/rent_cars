defmodule RentCars.Cars.CarSpecificationTest do
  alias RentCars.Cars.CarSpecification
  use RentCars.DataCase

  test "should require fields" do
    changeset = CarSpecification.changeset(%CarSpecification{}, %{})
    assert %{car: ["can't be blank"], specification: ["can't be blank"]} = errors_on(changeset)
  end
end
