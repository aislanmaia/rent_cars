defmodule RentCars.Rentals do
  import Ecto.Query

  alias __MODULE__.CreateRental
  alias RentCars.Rentals.Rental
  alias RentCars.Repo

  def list_rentals(user_id) do
    # Repo.all(from r in Rental, where: [user_id: ^user_id])
    Rental
    |> where([r], r.user_id == ^user_id)
    |> Repo.all()
  end

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
