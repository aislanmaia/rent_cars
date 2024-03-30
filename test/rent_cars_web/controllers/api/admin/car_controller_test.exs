defmodule RentCarsWeb.Api.Admin.CarControllerTest do
  use RentCarsWeb.ConnCase
  import RentCars.CarsFixtures
  import RentCars.CategoriesFixtures
  alias RentCars.Helper.Atomizer

  setup :include_admin_user_token

  # test "list all categories", %{conn: conn} do
  #   conn = get(conn, ~p"/api/admin/categories")
  #   assert json_response(conn, 200)["data"] == []
  # end

  describe "cars create" do
    test "create car when data is valid", %{conn: conn} do
      category = category_fixture()

      payload = %{
        name: "some car name",
        description: "some car description",
        brand: "some brand",
        daily_rate: 1000,
        license_plate: "asdf #{:rand.uniform(10_000)}",
        fine_amount: 30,
        category_id: category.id,
        specifications: [
          %{name: "wheels", description: "some description"},
          %{name: "pumpkin wheels", description: "some description"}
        ]
      }

      conn = post(conn, ~p"/api/admin/cars", car: payload)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/admin/cars/#{id}")

      # name = payload.name
      # description = payload.description
      # specifications = payload.specifications |> Jason.encode!() |> Jason.decode!()

      # assert %{
      #          "id" => ^id,
      #          "name" => ^name,
      #          "description" => ^description
      #        } = json_response(conn, 200)["data"]

      result =
        json_response(conn, 200)["data"]
        |> Jason.encode!(keys: &String.to_atom/1)
        |> Jason.decode!(keys: &String.to_atom/1)

      name = result.name
      description = result.description

      assert %{
               id: ^id,
               name: ^name,
               description: ^description
             } = result

      Enum.each(result.specifications.data, fn specification ->
        assert specification.name in Enum.map(payload.specifications, & &1.name)
        assert specification.description in Enum.map(payload.specifications, & &1.description)
      end)
    end

    test "try to create car when data is invalid", %{conn: conn} do
      attrs = %{description: "pumpkin 123"}
      conn = post(conn, ~p"/api/admin/cars", car: attrs)

      assert json_response(conn, 422)["errors"] == %{
               "name" => ["can't be blank"],
               "brand" => ["can't be blank"],
               "category_id" => ["can't be blank"],
               "daily_rate" => ["can't be blank"],
               "fine_amount" => ["can't be blank"],
               "license_plate" => ["can't be blank"]
             }

      attrs = %{name: "Sport"}
      conn = post(conn, ~p"/api/admin/cars", car: attrs)

      assert json_response(conn, 422)["errors"] == %{
               "description" => ["can't be blank"],
               "brand" => ["can't be blank"],
               "category_id" => ["can't be blank"],
               "daily_rate" => ["can't be blank"],
               "fine_amount" => ["can't be blank"],
               "license_plate" => ["can't be blank"]
             }
    end
  end

  describe "cars update" do
    test "update car when data is valid", %{conn: conn} do
      car = car_fixture()

      payload = %{name: "Lancer 123"}

      conn = put(conn, ~p"/api/admin/cars/#{car.id}", car: payload)
      assert %{"id" => id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/admin/cars/#{id}")

      name = payload.name

      assert %{
               "id" => ^id,
               "name" => ^name
             } = json_response(conn, 200)["data"]
    end
  end

  describe "create_images/2" do
    test "create car images", %{conn: conn} do
      car = car_fixture(%{brand: "byd"})

      images = [
        %Plug.Upload{
          content_type: "image/jpg",
          filename: "car_1.jpg",
          path: "test/support/fixtures/car_1.jpg"
        },
        %Plug.Upload{
          content_type: "image/jpg",
          filename: "car_2.jpg",
          path: "test/support/fixtures/car_2.jpg"
        },
        %Plug.Upload{
          content_type: "image/jpg",
          filename: "car_3.jpg",
          path: "test/support/fixtures/car_3.jpg"
        }
      ]

      conn = patch(conn, ~p"/api/admin/cars/#{car.id}/images", images: images)

      %{images: images_result} = Atomizer.execute(json_response(conn, 200)["data"])

      assert Enum.at(images_result, 0) |> String.contains?("car_1")
      assert Enum.at(images_result, 1) |> String.contains?("car_2")
      assert Enum.at(images_result, 2) |> String.contains?("car_3")
    end
  end
end
