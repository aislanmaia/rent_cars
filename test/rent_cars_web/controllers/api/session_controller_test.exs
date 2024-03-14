defmodule RentCarsWeb.Api.SessionControllerTest do
  use RentCarsWeb.ConnCase

  describe "handle sessions" do
    setup :include_normal_user_token

    test "create session", %{conn: conn, user: user, password: password} do
      conn = post(conn, ~p"/api/sessions", email: user.email, password: password)
      # assert %{"id" => id} = json_response(conn, 201)["data"]

      assert json_response(conn, 201)["data"]["user"]["data"]["email"] == user.email
    end

    test "get me", %{conn: conn, user: user, token: token} do
      conn = post(conn, ~p"/api/sessions/me", token: token)

      assert json_response(conn, 200)["data"]["user"]["data"]["email"] == user.email
    end
  end
end
