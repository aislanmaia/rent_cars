defmodule RentCarsWeb.Api.Admin.SpecificationController do
  use RentCarsWeb, :controller

  alias RentCars.Specifications
  alias RentCars.Specifications.Specification

  action_fallback RentCarsWeb.FallbackController

  def index(conn, _params) do
    specifications = Specifications.list_specifications()
    render(conn, :index, specifications: specifications)
  end

  def create(conn, %{"specification" => specification_params}) do
    with {:ok, %Specification{} = specification} <-
           Specifications.create_specification(specification_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/admin/specifications/#{specification}")
      |> render(:show, specification: specification)
    end
  end

  def show(conn, %{"id" => id}) do
    specification = Specifications.get_specification!(id)
    render(conn, :show, specification: specification)
  end

  def update(conn, %{"id" => id, "specification" => specification_params}) do
    specification = Specifications.get_specification!(id)

    with {:ok, %Specification{} = specification} <-
           Specifications.update_specification(specification, specification_params) do
      render(conn, :show, specification: specification)
    end
  end

  def delete(conn, %{"id" => id}) do
    specification = Specifications.get_specification!(id)

    with {:ok, %Specification{}} <- Specifications.delete_specification(specification) do
      send_resp(conn, :no_content, "")
    end
  end
end
