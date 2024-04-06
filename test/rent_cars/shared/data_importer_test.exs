defmodule RentCars.Shared.DataImporterTest do
  use RentCars.DataCase
  alias RentCars.Shared.DataImporter

  describe "DataImporter" do
    test "should import csv data to structs" do
      file = %Plug.Upload{
        content_type: "text/csv",
        filename: "categories.csv",
        path: "test/support/fixtures/categories.csv"
      }

      assert [
               _struct1,
               _struct2,
               _struct3
             ] = DataImporter.import(file, &build_categories/1)
    end

    test "should import csv data to structs from raw string" do
      file_content = """
      name,description
      SUV,categoria alta
      Sedan,categoria com grande bagageiro
      """

      file_path = "test/support/fixtures/content.csv"
      :ok = File.write!(file_path, file_content)

      file = %Plug.Upload{
        content_type: "text/csv",
        filename: "categories.csv",
        path: file_path
      }

      assert [
               _struct1,
               _struct2
             ] = DataImporter.import(file, &build_categories/1)

      File.rm!(file_path)
    end
  end

  defp build_categories(row_data) do
    Enum.map(row_data, fn row ->
      %{
        id: Ecto.UUID.generate(),
        name: List.first(row),
        description: List.last(row),
        inserted_at: {:placeholder, :now},
        updated_at: {:placeholder, :now}
      }
    end)
  end
end
