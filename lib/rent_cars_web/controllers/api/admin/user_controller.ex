defmodule RentCarsWeb.Api.Admin.UserController do
  use RentCarsWeb, :controller

  alias RentCars.Accounts

  action_fallback RentCarsWeb.FallbackController

  def index(conn, params) do
    page = params["page"]
    per_page = params["per_page"]

    users = Accounts.users(page, per_page)

    conn
    |> render(:index, users: users)
  end
end
