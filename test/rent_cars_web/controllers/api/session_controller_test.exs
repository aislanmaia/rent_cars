defmodule RentCarsWeb.Api.SessionControllerTest do
  use RentCarsWeb.ConnCase
  alias RentCars.Shared.Tokenr

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

    test "send forgot password", %{conn: conn, user: user} do
      conn = post(conn, ~p"/api/sessions/forgot_password", email: user.email)

      assert json_response(conn, 204) == ""
    end

    test "throw error when try to reset_password", %{conn: conn} do
      conn =
        post(conn, ~p"/api/sessions/reset_password",
          token: "invalid token",
          user: %{password: "123456", password_confirmation: "123456"}
        )

      assert json_response(conn, 400)["message"] == "Invalid token"
    end

    test "reset password", %{conn: conn, user: user} do
      token = Tokenr.generate_forgot_email_token(user)

      conn =
        post(conn, ~p"/api/sessions/reset_password",
          token: token,
          user: %{password: "123456789", password_confirmation: "123456789"}
        )

      assert json_response(conn, 200)["data"]["user"]["data"]["email"] == user.email
    end
  end
end
