defmodule RentCarsWeb.Api.CategoryController do
  use RentCarsWeb, :controller
  alias RentCars.Categories

  def index(conn, _params) do
    categories = Categories.list_categories()

    conn
    |> render(:index, categories: categories)
  end
end
