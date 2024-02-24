defmodule RentCarsWeb.Api.CategoryControllerTest do
  use RentCarsWeb.ConnCase

  test "list all categories", %{conn: conn} do
    conn = get(conn, "/api/categories")

    assert json_response(conn, 200)["data"] == [
             %{
               id: "123",
               description: "pumpkin 123",
               name: "SPORT"
             }
           ]
  end
end
