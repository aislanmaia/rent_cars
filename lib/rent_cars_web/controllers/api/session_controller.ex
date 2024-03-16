defmodule RentCarsWeb.Api.SessionController do
  use RentCarsWeb, :controller
  alias RentCars.Sessions
  action_fallback RentCarsWeb.FallbackController

  def create(conn, %{"email" => email, "password" => password}) do
    with {:ok, user, token} <- Sessions.create(email, password) do
      session = %{user: user, token: token}

      conn
      |> put_status(:created)
      |> render(:show, session: session)
    end
  end

  def me(conn, %{"token" => token}) do
    with {:ok, user} <- Sessions.me(token) do
      session = %{user: user, token: token}

      conn
      |> render(:show, session: session)
    end
  end

  def forgot_password(conn, %{"email" => email}) do
    with {:ok, _email, _token} <- Sessions.forgot_password(email) do
      conn
      |> put_status(:no_content)
      |> put_resp_header("content-type", "application/json")
      |> json("")
    end
  end

  def reset_password(conn, params) do
    with {:ok, user} <- Sessions.reset_password(params) do
      session = %{user: user, token: nil}

      conn
      |> render(:show, session: session)
    end

    # with {:ok, _email, _token} <- Sessions.reset_password(email) do
    #   conn
    #   |> put_status(:no_content)
    #   |> put_resp_header("content-type", "application/json")
    #   |> json("")
    # end
  end
end
