defmodule RentCars.Accounts do
  alias RentCars.Accounts.User
  alias RentCars.Repo

  def create_user(attrs) do
    attrs
    |> User.changeset()
    |> Repo.insert()
  end

  def get_user!(id) do
    Repo.get!(User, id)
  end

  def update_user(user, %{"user" => user_params}) do
    user
    |> User.update_user(user_params)
    |> Repo.update()
  end
end
