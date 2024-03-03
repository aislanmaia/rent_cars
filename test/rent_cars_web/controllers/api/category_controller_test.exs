defmodule RentCarsWeb.Api.CategoryControllerTest do
  use RentCarsWeb.ConnCase
  import RentCars.CategoriesFixtures

  test "list all categories", %{conn: conn} do
    conn = get(conn, ~p"/api/categories")
    assert json_response(conn, 200)["data"] == []
  end

  test "create category when data is valid", %{conn: conn} do
    attrs = %{name: "Sport", description: "pumpkin 123"}
    conn = post(conn, ~p"/api/categories", category: attrs)
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get(conn, ~p"/api/categories/#{id}")

    name = String.upcase(attrs.name)
    description = attrs.description

    assert %{
             "id" => ^id,
             "name" => ^name,
             "description" => ^description
           } = json_response(conn, 200)["data"]
  end

  test "try to create category when data is invalid", %{conn: conn} do
    attrs = %{description: "pumpkin 123"}
    conn = post(conn, ~p"/api/categories", category: attrs)
    assert json_response(conn, 422)["errors"] == %{"name" => ["can't be blank"]}

    attrs = %{name: "Sport"}
    conn = post(conn, ~p"/api/categories", category: attrs)
    assert json_response(conn, 422)["errors"] == %{"description" => ["can't be blank"]}
  end

  describe "update category" do
    setup [:create_category]

    test "update category with valid data", %{conn: conn, category: category} do
      attrs = %{name: "update category name"}

      conn =
        put(conn, ~p"/api/categories/#{category.id}", category: %{name: "update category name"})

      assert %{"id" => id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/categories/#{id}")
      name = String.upcase(attrs.name)

      assert %{
               "id" => ^id,
               "name" => ^name
             } = json_response(conn, 200)["data"]
    end
  end

  describe "delete category" do
    setup [:create_category]

    test "delete category with valid data", %{conn: conn, category: category} do
      conn = delete(conn, ~p"/api/categories/#{category.id}")

      assert response(conn, 204)

      assert_error_sent 404, fn -> get(conn, ~p"/api/categories/#{category.id}") end
    end
  end

  defp create_category(_) do
    category = category_fixture()
    %{category: category}
  end
end
