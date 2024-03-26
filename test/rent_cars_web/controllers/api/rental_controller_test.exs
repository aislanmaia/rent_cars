defmodule RentCarsWeb.Api.RentalControllerTest do
  use RentCarsWeb.ConnCase
  import RentCars.CarsFixtures

  describe "handle rentals" do
    setup :include_normal_user_token

    test "create session", %{conn: conn, user: user} do
      car = car_fixture()

      payload = %{
        car_id: car.id,
        expected_return_date: create_expected_return_date()
      }

      conn = post(conn, ~p"/api/rentals", payload)

      assert %{
               "id" => id,
               "car" => %{"data" => returned_car},
               "user_id" => user_id,
               "start_date" => start_date,
               "end_date" => end_date,
               "expected_return_date" => expected_return_date,
               "total" => total
             } =
               json_response(conn, 201)["data"]

      assert payload.car_id == returned_car["id"]
      assert user.id == user_id
      refute id == nil
      refute start_date == nil
      refute expected_return_date == nil
      assert nil == end_date
      assert nil == total
    end
  end

  defp create_expected_return_date() do
    NaiveDateTime.utc_now()
    |> then(&%{&1 | month: &1.month + 1})
    |> NaiveDateTime.to_string()
  end
end
