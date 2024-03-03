defmodule RentCars.SpecificationsTest do
  use RentCars.DataCase

  alias RentCars.Specifications

  describe "specifications" do
    alias RentCars.Specifications.Specification

    import RentCars.SpecificationsFixtures

    @invalid_attrs %{name: nil, description: nil}

    test "list_specifications/0 returns all specifications" do
      specification = specification_fixture()
      assert Specifications.list_specifications() == [specification]
    end

    test "get_specification!/1 returns the specification with given id" do
      specification = specification_fixture()
      assert Specifications.get_specification!(specification.id) == specification
    end

    test "create_specification/1 with valid data creates a specification" do
      valid_attrs = %{name: "some name", description: "some description"}

      assert {:ok, %Specification{} = specification} =
               Specifications.create_specification(valid_attrs)

      assert specification.name == "some name"
      assert specification.description == "some description"
    end

    test "create_specification/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Specifications.create_specification(@invalid_attrs)
    end

    test "update_specification/2 with valid data updates the specification" do
      specification = specification_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description"}

      assert {:ok, %Specification{} = specification} =
               Specifications.update_specification(specification, update_attrs)

      assert specification.name == "some updated name"
      assert specification.description == "some updated description"
    end

    test "update_specification/2 with invalid data returns error changeset" do
      specification = specification_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Specifications.update_specification(specification, @invalid_attrs)

      assert specification == Specifications.get_specification!(specification.id)
    end

    test "delete_specification/1 deletes the specification" do
      specification = specification_fixture()
      assert {:ok, %Specification{}} = Specifications.delete_specification(specification)

      assert_raise Ecto.NoResultsError, fn ->
        Specifications.get_specification!(specification.id)
      end
    end

    test "change_specification/1 returns a specification changeset" do
      specification = specification_fixture()
      assert %Ecto.Changeset{} = Specifications.change_specification(specification)
    end
  end
end
