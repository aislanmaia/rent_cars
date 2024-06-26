defmodule RentCars.Rentals.ReturnCar do
  defstruct rental: nil, days: nil, delay: nil, total_fees: nil

  import Ecto.Query
  alias Ecto.Multi
  alias RentCars.Cars.Car
  alias RentCars.Rentals.Rental
  alias RentCars.Repo

  def execute(rental_id, user_id) do
    with %__MODULE__{} = return_rental <- get_rental(rental_id, user_id),
         return_rental <- calculate_delay(return_rental),
         return_rental <- calculate_fees(return_rental) do
      return_car(return_rental)
    else
      err -> err
    end
  end

  defp get_rental(rental_id, user_id) do
    err = {:error, "Car reservation does not exist"}

    result = fn rental ->
      (rental != nil && %__MODULE__{rental: Repo.preload(rental, :car)}) || err
    end

    Rental
    |> where([r], r.id == ^rental_id)
    |> where([r], r.user_id == ^user_id)
    |> Repo.one()
    |> then(&result.(&1))
  end

  defp calculate_delay(%{rental: rental} = return_rental) do
    now = NaiveDateTime.utc_now()
    days = Timex.diff(now, rental.start_date, :days)
    days = (days <= 0 && 1) || days
    delay = Timex.diff(now, rental.expected_return_date, :days)

    %{return_rental | days: days, delay: delay}
  end

  defp calculate_fees(%{rental: %{car: car}, delay: delay, days: days} = return_rental) do
    calculate_fine = (delay > 0 && delay * car.fine_amount.amount) || 0
    total_fees = days * car.daily_rate + calculate_fine
    %{return_rental | total_fees: total_fees}
  end

  defp return_car(%{rental: rental, total_fees: total_fees} = return_rental) do
    rental =
      Multi.new()
      |> Multi.update(:car_is_available, Car.changeset(rental.car, %{available: true}))
      |> Multi.update(
        :return_rental,
        Rental.changeset(rental, %{
          total: Money.new(total_fees * 100),
          end_date: NaiveDateTime.utc_now()
        })
      )
      |> Repo.transaction()

    %{return_rental | rental: rental}
  end
end
