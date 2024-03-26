defmodule RentCarsWeb.Api.RentalControllerTest do
  use RentCarsWeb.ConnCase
  import RentCars.CarsFixtures
  import RentCars.RentalsFixtures
  import RentCars.Helper

  describe "handle rentals" do
    setup :include_normal_user_token

    test "rent a car", %{conn: conn, user: user} do
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

    test "list all cars booked", %{conn: conn, user: user} do
      car = car_fixture()
      rental_fixture(%{user_id: user.id, car_id: car.id})

      conn = get(conn, ~p"/api/rentals")

      result =
        transform_response(json_response(conn, 200)["data"])
        |> hd()

      assert car.id == result.car.data.id
      assert car.name == result.car.data.name
      assert car.description == result.car.data.description
      assert car.daily_rate == result.car.data.daily_rate
      assert car.available == result.car.data.available
      assert car.category_id == result.car.data.category.data.id
      assert Money.to_string(car.fine_amount) == result.car.data.fine_amount
      assert car.brand == result.car.data.brand
      assert car.license_plate == result.car.data.license_plate

      Enum.each(car.specifications, fn specification ->
        assert specification.id in Enum.map(
                 transform_response(result.car.data.specifications.data),
                 & &1.id
               )

        assert specification.name in Enum.map(
                 transform_response(result.car.data.specifications.data),
                 & &1.name
               )
      end)
    end
  end

  defp create_expected_return_date do
    NaiveDateTime.utc_now()
    |> then(&%{&1 | month: &1.month + 1})
    |> NaiveDateTime.to_string()
  end
end
