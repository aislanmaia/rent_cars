defmodule RentCarsWeb.Api.UserJSON do
  alias RentCars.Accounts.Avatar
  # def index(%{users: users}) do
  #   %{data: for(user <- users, do: data(user))}
  # end

  @doc """
  Renders a single category.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(user) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      user_name: user.user_name,
      drive_license: user.drive_license,
      email: user.email,
      role: user.role,
      avatar: Avatar.url({user.avatar, user}, signed: true)
    }
  end
end
