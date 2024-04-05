defmodule RentCars.Accounts do
  alias RentCars.Shared.Pagination
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

  def upload_photo(user_id, photo) do
    user_id
    |> get_user!()
    |> User.update_photo(%{avatar: photo})
    |> Repo.update()
  end

  # def users(cursor \\ nil) do
  #   case cursor do
  #     nil -> User |> limit(10) |> Repo.all()
  #     # Repo.all(from u in User, where: u.id > ^cursor, limit: 10)
  #     cursor -> User |> limit(10) |> where([u], u.id > ^cursor) |> Repo.all()
  #   end
  # end

  def users() do
    User
    |> Repo.all()
  end

  def users(page, per_page) when not is_nil(page) do
    users(:paginated, page, per_page)
  end

  def users(page, _) when is_nil(page) do
    users()
  end

  def users(:paginated, page, per_page) do
    page = String.to_integer(page || "1")
    per_page = String.to_integer(per_page || "5")

    User
    |> Pagination.page(page, per_page: per_page)
  end
end
