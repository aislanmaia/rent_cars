defmodule RentCarsWeb.Api.Admin.UserJSON do
  alias RentCarsWeb.Api.UserJSON

  def index(%{users: users}) do
    %{data: render_users(users)}
  end

  defp render_users(users) when not is_nil(users.metadata) and not is_nil(users.list) do
    paginated_data(users)
  end

  defp render_users(users) do
    for(user <- users, do: UserJSON.show(%{user: user}))
  end

  defp paginated_data(users) do
    %{
      metadata: users.metadata,
      list: for(user <- users.list, do: UserJSON.show(%{user: user}))
    }
  end
end
