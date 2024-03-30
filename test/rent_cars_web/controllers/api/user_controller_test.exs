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

  test "upload user image", %{conn: conn} do
    photo = %Plug.Upload{
      content_type: "image/png",
      filename: "avatar.png",
      path: "test/support/fixtures/avatar.png"
    }

    conn = patch(conn, ~p"/api/users/photo", avatar: photo)

    assert json_response(conn, 201)["data"]["avatar"] |> String.contains?("original.png")
  end
end
