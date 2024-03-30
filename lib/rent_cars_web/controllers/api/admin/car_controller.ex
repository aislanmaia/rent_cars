defmodule RentCarsWeb.Api.Admin.CarController do
  use RentCarsWeb, :controller
  alias RentCars.Cars
  action_fallback RentCarsWeb.FallbackController

  def create(conn, %{"car" => params}) do
    with {:ok, car} <- Cars.create(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/admin/cars/#{car.id}")
      |> render(:show, car: car)
    end
  end

  def show(conn, %{"id" => id}) do
    car = Cars.get_car!(id) |> Cars.with_assoc(:specifications)

    conn
    |> render(:show, car: car)
  end

  def update(conn, %{"id" => id, "car" => car_params}) do
    with {:ok, car} <- Cars.update(id, car_params) do
      conn
      |> put_resp_header("location", ~p"/api/admin/cars/#{car.id}")
      |> render(:show, car: car)
    end
  end

  def create_images(conn, %{"id" => id, "images" => images}) do
    with {:ok, car} <- Cars.create_images(id, images) do
      conn
      |> put_resp_header("location", ~p"/api/admin/cars/#{car.id}")
      |> render(:show, car: car)
    end
  end
end
