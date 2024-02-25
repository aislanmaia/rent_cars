defmodule RentCarsWeb.Api.CategoryController do
  use RentCarsWeb, :controller

  def index(conn, _params) do
    conn
    |> json(%{
      data: [
        %{
          description: "pumpkin 123",
          id: "123",
          name: "SPORT"
        }
      ]
    })
  end
end
