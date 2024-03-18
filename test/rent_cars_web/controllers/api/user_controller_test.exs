defmodule RentCarsWeb.Api.UserControllerTest do
  use RentCarsWeb.ConnCase
  import RentCars.AccountsFixtures

  setup :include_normal_user_token

  test "create user when data is valid", %{conn: conn} do
    attrs = user_attrs()
    conn = post(conn, ~p"/api/users", user: attrs)
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get(conn, ~p"/api/users/#{id}")

    first_name = attrs.first_name
    email = String.downcase(attrs.email)

    assert %{
             "id" => ^id,
             "first_name" => ^first_name,
             "email" => ^email
           } = json_response(conn, 200)["data"]
  end
end
