defmodule RentCarsWeb.Api.Admin.SpecificationControllerTest do
  use RentCarsWeb.ConnCase

  import RentCars.SpecificationsFixtures

  alias RentCars.Specifications.Specification

  @create_attrs %{
    name: "some name",
    description: "some description"
  }
  @update_attrs %{
    name: "some updated name",
    description: "some updated description"
  }
  @invalid_attrs %{name: nil, description: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  setup :include_admin_user_token

  describe "index" do
    test "lists all specifications", %{conn: conn} do
      conn = get(conn, ~p"/api/admin/specifications")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create specification" do
    test "renders specification when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/admin/specifications", specification: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/admin/specifications/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some description",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/admin/specifications", specification: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update specification" do
    setup [:create_specification]

    test "renders specification when data is valid", %{
      conn: conn,
      specification: %Specification{id: id} = specification
    } do
      conn =
        put(conn, ~p"/api/admin/specifications/#{specification}", specification: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/admin/specifications/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some updated description",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, specification: specification} do
      conn =
        put(conn, ~p"/api/admin/specifications/#{specification}", specification: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete specification" do
    setup [:create_specification]

    test "deletes chosen specification", %{conn: conn, specification: specification} do
      conn = delete(conn, ~p"/api/admin/specifications/#{specification}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/admin/specifications/#{specification}")
      end
    end
  end

  describe "normal user permissions should not" do
    setup [:include_normal_user_token, :create_specification]

    test "list specifications", %{conn: conn} do
      conn = get(conn, ~p"/api/admin/specifications")
      assert json_response(conn, 401)
    end

    test "create specification", %{conn: conn} do
      attrs = %{name: "Sport", description: "pumpkin 123"}
      conn = post(conn, ~p"/api/admin/specifications", specification: attrs)
      assert json_response(conn, 401)
    end

    test "update specification with valid data", %{conn: conn, specification: specification} do
      attrs = %{name: "update specification name"}

      conn =
        put(conn, ~p"/api/admin/specifications/#{specification.id}", specification: attrs)

      assert json_response(conn, 401)
    end

    test "delete specification", %{conn: conn, specification: specification} do
      conn = delete(conn, ~p"/api/admin/specifications/#{specification.id}")

      assert response(conn, 401)
    end
  end

  defp create_specification(_) do
    specification = specification_fixture()
    %{specification: specification}
  end
end
