defmodule RentCarsWeb.Api.SessionJSON do
  alias RentCarsWeb.Api.UserJSON

  @doc """
  Renders a single category.
  """
  def show(%{session: session}) do
    %{data: data(session)}
  end

  defp data(session) do
    %{
      user: UserJSON.show(%{user: session.user}),
      token: session.token
    }
  end
end
