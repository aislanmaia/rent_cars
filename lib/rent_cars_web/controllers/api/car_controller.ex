defmodule RentCarsWeb.Api.CarController do
  use RentCarsWeb, :controller
  alias RentCars.Cars
  action_fallback RentCarsWeb.FallbackController

  def index(conn, params) do
    cars =
      params
      |> convert_to_atom_key
      |> Cars.list_available_cars()

    conn
    |> render(:index, cars: cars)
  end

  def show(conn, %{"id" => id}) do
    car = Cars.get_car!(id) |> Cars.with_assoc(:specifications)

    conn
    |> render(:show, car: car)
  end

  defp convert_to_atom_key(params) do
    params
    |> Enum.map(fn {key, value} -> {String.to_atom(key), value} end)
  end
end
