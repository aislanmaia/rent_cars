defmodule RentCarsWeb.Api.Admin.CategoryControllerTest do
  use RentCarsWeb.ConnCase
  import RentCars.CategoriesFixtures

  setup :include_admin_user_token

  test "list all categories", %{conn: conn} do
    conn = get(conn, ~p"/api/admin/categories")
    assert json_response(conn, 200)["data"] == []
  end

  test "create category when data is valid", %{conn: conn} do
    attrs = %{name: "Sport", description: "pumpkin 123"}
    conn = post(conn, ~p"/api/admin/categories", category: attrs)
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get(conn, ~p"/api/admin/categories/#{id}")

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
    conn = post(conn, ~p"/api/admin/categories", category: attrs)
    assert json_response(conn, 422)["errors"] == %{"name" => ["can't be blank"]}

    attrs = %{name: "Sport"}
    conn = post(conn, ~p"/api/admin/categories", category: attrs)
    assert json_response(conn, 422)["errors"] == %{"description" => ["can't be blank"]}
  end

  describe "update category" do
    setup [:create_category]

    test "update category with valid data", %{conn: conn, category: category} do
      attrs = %{name: "update category name"}

      conn =
        put(conn, ~p"/api/admin/categories/#{category.id}", category: attrs)

      assert %{"id" => id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/admin/categories/#{id}")
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
      conn = delete(conn, ~p"/api/admin/categories/#{category.id}")

      assert response(conn, 204)

      assert_error_sent 404, fn -> get(conn, ~p"/api/admin/categories/#{category.id}") end
    end
  end

  describe "normal user permissions should not" do
    setup [:include_normal_user_token, :create_category]

    test "list categories", %{conn: conn} do
      conn = get(conn, ~p"/api/admin/categories")
      assert json_response(conn, 401)
    end

    test "create category", %{conn: conn} do
      attrs = %{name: "Sport", description: "pumpkin 123"}
      conn = post(conn, ~p"/api/admin/categories", category: attrs)
      assert json_response(conn, 401)
    end

    test "update category with valid data", %{conn: conn, category: category} do
      attrs = %{name: "update category name"}

      conn =
        put(conn, ~p"/api/admin/categories/#{category.id}", category: attrs)

      assert json_response(conn, 401)
    end

    test "delete category", %{conn: conn, category: category} do
      conn = delete(conn, ~p"/api/admin/categories/#{category.id}")

      assert response(conn, 401)
    end
  end

  describe "import categories" do
    test "import categories through CSV", %{conn: conn} do
      file = %Plug.Upload{
        content_type: "text/csv",
        filename: "categories.csv",
        path: "test/support/fixtures/categories.csv"
      }

      conn = post(conn, ~p"/api/admin/categories/import", file: file)

      assert "ok" = json_response(conn, 201)
    end
  end

  defp create_category(_) do
    category = category_fixture()
    %{category: category}
  end
end
