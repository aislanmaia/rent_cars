defmodule RentCarsWeb.Api.CarControllerTest do
  use RentCarsWeb.ConnCase
  import RentCars.CarsFixtures

  alias RentCarsWeb.Api.Admin.SpecificationJSON

  describe "cars list" do
    test "can list all available cars", %{conn: conn} do
      car_fixture()
      car = car_fixture(%{brand: "pumpkin"})

      conn = get(conn, ~p"/api/cars", brand: "pump")

      expected = [
        %{
          "data" => %{
            "id" => car.id,
            "name" => car.name,
            "brand" => car.brand,
            "description" => car.description,
            "category" => nil,
            "available" => car.available,
            "daily_rate" => car.daily_rate,
            "fine_amount" => Money.to_string(car.fine_amount),
            "license_plate" => car.license_plate,
            "specifications" => %{
              "data" =>
                SpecificationJSON.index(%{specifications: car.specifications}).data
                |> Jason.encode!()
                |> Jason.decode!()
            },
            "images" => []
          }
        }
      ]

      assert expected == json_response(conn, 200)["data"]
    end

    test "can show a car", %{conn: conn} do
      car_fixture()
      car = car_fixture(%{brand: "pumpkin"})

      conn = get(conn, ~p"/api/cars/#{car.id}")

      expected =
        %{
          "id" => car.id,
          "name" => car.name,
          "brand" => car.brand,
          "description" => car.description,
          "category" => nil,
          "available" => car.available,
          "daily_rate" => car.daily_rate,
          "fine_amount" => Money.to_string(car.fine_amount),
          "license_plate" => car.license_plate,
          "specifications" => %{
            "data" =>
              SpecificationJSON.index(%{specifications: car.specifications}).data
              |> Jason.encode!()
              |> Jason.decode!()
          },
          "images" => []
        }

      assert expected == json_response(conn, 200)["data"]
    end
  end
end
