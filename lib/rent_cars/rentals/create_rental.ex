defmodule RentCars.Rentals.CreateRental do
  alias RentCars.Repo
  alias RentCars.Cars.Car

  def execute(car_id) do
    car_available?(car_id)
  end

  defp car_available?(car_id) do
    Car
    |> Repo.get(car_id)
    |> check_car_availability()
  end

  defp check_car_availability(%{available: false}), do: {:error, "Car is unavailable"}
  defp check_car_availability(car), do: {:ok, car}
end
