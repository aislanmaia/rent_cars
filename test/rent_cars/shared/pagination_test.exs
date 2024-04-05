defmodule RentCars.Shared.PaginationTest do
  alias RentCars.Shared.Pagination
  use RentCars.DataCase
  import RentCars.AccountsFixtures
  alias RentCars.Accounts.User

  test "should paginate data" do
    user_fixture()
    user_fixture()
    user_fixture()
    per_page = 1
    users = Pagination.query(User, "1", per_page: per_page)
    assert users |> Enum.count() == per_page
  end
end
