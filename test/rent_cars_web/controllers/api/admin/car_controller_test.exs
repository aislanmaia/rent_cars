defmodule RentCarsWeb.Api.Admin.CarControllerTest do
  use RentCarsWeb.ConnCase
  import RentCars.CarsFixtures
  import RentCars.CategoriesFixtures

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

  # describe "car category" do
  #   setup [:create_category]

  #   test "update category with valid data", %{conn: conn, category: category} do
  #     attrs = %{name: "update category name"}

  #     conn =
  #       put(conn, ~p"/api/admin/categories/#{category.id}",
  #         category: %{name: "update category name"}
  #       )

  #     assert %{"id" => id} = json_response(conn, 200)["data"]

  #     conn = get(conn, ~p"/api/admin/categories/#{id}")
  #     name = String.upcase(attrs.name)

  #     assert %{
  #              "id" => ^id,
  #              "name" => ^name
  #            } = json_response(conn, 200)["data"]
  #   end
  # end

  # describe "delete category" do
  #   setup [:create_category]

  #   test "delete category with valid data", %{conn: conn, category: category} do
  #     conn = delete(conn, ~p"/api/admin/categories/#{category.id}")

  #     assert response(conn, 204)

  #     assert_error_sent 404, fn -> get(conn, ~p"/api/admin/categories/#{category.id}") end
  #   end
  # end

  # describe "normal user permissions should not" do
  #   setup [:include_normal_user_token, :create_category]

  #   test "list categories", %{conn: conn} do
  #     conn = get(conn, ~p"/api/admin/categories")
  #     assert json_response(conn, 401)
  #   end

  #   test "create category", %{conn: conn} do
  #     attrs = %{name: "Sport", description: "pumpkin 123"}
  #     conn = post(conn, ~p"/api/admin/categories", category: attrs)
  #     assert json_response(conn, 401)
  #   end

  #   test "update category with valid data", %{conn: conn, category: category} do
  #     attrs = %{name: "update category name"}

  #     conn =
  #       put(conn, ~p"/api/admin/categories/#{category.id}", category: attrs)

  #     assert json_response(conn, 401)
  #   end

  #   test "delete category", %{conn: conn, category: category} do
  #     conn = delete(conn, ~p"/api/admin/categories/#{category.id}")

  #     assert response(conn, 401)
  #   end
  # end

  # defp create_category(_) do
  #   category = category_fixture()
  #   %{category: category}
  # end
end
