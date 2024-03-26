defmodule RentCarsWeb.Api.RentalController do
  alias RentCars.Rentals
  use RentCarsWeb, :controller
  action_fallback RentCarsWeb.FallbackController

  def create(conn, params) do
    [user_id] = get_req_header(conn, "user_id")
    params = Map.put(params, "user_id", user_id)

    with {:ok, %{rental: rental}} <- Rentals.create(params) do
      rental = rental |> Rentals.with_assoc([:car])

      conn
      |> put_status(:created)
      |> render(:show, rental: rental)
    end
  end
end
