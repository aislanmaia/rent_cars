defmodule RentCarsWeb.Api.UserController do
  use RentCarsWeb, :controller
  alias RentCars.Accounts
  action_fallback RentCarsWeb.FallbackController

  def create(conn, %{"user" => user}) do
    with {:ok, user} <- Accounts.create_user(user) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user.id}")
      |> render(:show, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    conn
    |> render(:show, user: user)
  end

  def upload_photo(conn, %{"avatar" => params}) do
    [user_id] = get_req_header(conn, "user_id")

    with {:ok, user} <- Accounts.upload_photo(user_id, params) do
      conn
      |> put_status(:created)
      |> render(:show, user: user)
    end
  end
end
