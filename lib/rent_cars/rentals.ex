defmodule RentCars.Rentals do
  alias __MODULE__.CreateRental
  alias RentCars.Repo

  def create(payload) do
    %{
      "car_id" => car_id,
      "user_id" => user_id,
      "expected_return_date" => expected_return_date
    } = payload

    CreateRental.execute(car_id, expected_return_date, user_id)
  end

  def with_assoc(rental, assoc), do: Repo.preload(rental, assoc)
end
