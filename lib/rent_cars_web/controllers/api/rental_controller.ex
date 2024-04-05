defmodule RentCarsWeb.Api.RentalController do
  alias RentCars.Rentals
  use RentCarsWeb, :controller
  action_fallback RentCarsWeb.FallbackController

  def index(conn, _params) do
    [user_id] = get_req_header(conn, "user_id")

    rentals =
      Rentals.list_rentals(user_id) |> Rentals.with_assoc(car: [:category, :specifications])

    conn
    |> render(:index, rentals: rentals)
  end

  def create(conn, params) do
    [user_id] = get_req_header(conn, "user_id")
    params = Map.put(params, "user_id", user_id)

    with {:ok, %{rental: rental}} <- Rentals.create(params) do
      # rental = rental |> Rentals.with_assoc([:car])

      conn
      |> put_status(:created)
      |> render(:show, rental: rental)
    end
  end

  def return(conn, %{"id" => id}) do
    [user_id] = get_req_header(conn, "user_id")

    with %{rental: {:ok, %{return_rental: rental}}} <- Rentals.return_car(id, user_id) do
      conn
      |> put_status(:created)
      |> render(:show, rental: rental)
    end
  end
end
