defmodule RentCarsWeb.Api.Admin.CategoryController do
  use RentCarsWeb, :controller
  alias RentCars.Categories

  action_fallback RentCarsWeb.FallbackController

  def index(conn, _params) do
    categories = Categories.list_categories()

    conn
    |> render(:index, categories: categories)
  end

  def create(conn, %{"category" => category}) do
    with {:ok, category} <- Categories.create_category(category) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/admin/categories/#{category.id}")
      |> render(:show, category: category)
    end
  end

  def show(conn, %{"id" => id}) do
    category = Categories.get_category!(id)

    conn
    |> render(:show, category: category)
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = Categories.get_category!(id)

    with {:ok, category} <- Categories.update_category(category, category_params) do
      conn
      |> put_resp_header("location", ~p"/api/admin/categories/#{category.id}")
      |> render(:show, category: category)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = Categories.get_category!(id)

    with {:ok, _category} <- Categories.delete_category(category) do
      send_resp(conn, :no_content, "")
    end
  end

  def import(conn, params) do
    file = params["file"]

    with {:ok, _file} <- Categories.import_categories(file) do
      conn
      |> put_status(:created)
      |> json(:ok)
    end
  end
end
