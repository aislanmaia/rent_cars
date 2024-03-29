defmodule RentCarsWeb.Api.RentalJSON do
  alias RentCarsWeb.Api.CarJSON

  def index(%{rentals: rentals}) do
    %{data: for(rental <- rentals, do: data(rental))}
  end

  @doc """
  Renders a single rental.
  """
  def show(%{rental: rental}) do
    %{data: data(rental)}
  end

  defp data(rental) do
    %{
      id: rental.id,
      user_id: rental.user_id,
      car: load_car(rental.car, rental.car_id),
      expected_return_date: rental.expected_return_date,
      start_date: rental.start_date,
      end_date: rental.end_date,
      total: Money.to_string((rental.total == nil && Money.new(0)) || rental.total)
    }
  end

  defp load_car(car, car_id) do
    if Ecto.assoc_loaded?(car) do
      CarJSON.show(%{car: car})
    else
      %{id: car_id}
    end
  end
end
