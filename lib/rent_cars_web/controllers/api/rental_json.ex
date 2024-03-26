defmodule RentCarsWeb.Api.RentalJSON do
  alias RentCarsWeb.Api.CarJSON

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
      total: rental.total
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