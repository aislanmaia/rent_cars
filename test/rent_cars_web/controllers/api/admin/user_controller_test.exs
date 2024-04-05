defmodule RentCarsWeb.Api.Admin.UserControllerTest do
  use RentCarsWeb.ConnCase

  import RentCars.AccountsFixtures
  alias RentCars.Helper.Atomizer

  setup :include_admin_user_token

  describe "index/2" do
    test "list all users wihout pagination", %{conn: conn} do
      user_fixture()
      user_fixture()

      conn = get(conn, ~p"/api/admin/users")

      users = Atomizer.execute(json_response(conn, 200)["data"])

      assert users |> Enum.count() == 3
    end

    test "list all users with pagination", %{conn: conn} do
      user_fixture()
      user_fixture()

      page = 1
      per_page = 3

      conn = get(conn, ~p"/api/admin/users?page=#{page}&per_page=#{per_page}")

      %{list: users, metadata: metadata} = Atomizer.execute(json_response(conn, 200)["data"])

      assert users |> Enum.count() == 3
      refute metadata.has_next
      refute metadata.has_prev
      assert metadata.page == page
      assert metadata.per_page == per_page
      assert metadata.count == Enum.count(users)
      assert metadata.first_page == 1
      assert metadata.last_page == 1
    end
  end
end
