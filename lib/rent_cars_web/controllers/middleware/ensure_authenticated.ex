defmodule RentCarsWeb.Middleware.EnsureAuthenticated do
  alias RentCars.Shared.Tokenr
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, user} <- Tokenr.verify_auth_token(token) do
      put_req_header(conn, "user_id", user.id)
    else
      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(401, Jason.encode!(%{error: "Unauthenticated/Invalid Token"}))
        |> halt()
    end
  end
end
