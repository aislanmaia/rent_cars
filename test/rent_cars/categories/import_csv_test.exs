defmodule RentCars.Categories.ImportCsvTest do
  alias RentCars.Categories
  alias RentCars.Categories.ImportCSV
  use RentCars.DataCase

  describe "ImportCSV" do
    test "import categories through CSV file" do
      file = %Plug.Upload{
        content_type: "text/csv",
        filename: "categories.csv",
        path: "test/support/fixtures/categories.csv"
      }

      assert {:ok, entries_count} = ImportCSV.execute(file)
      assert Categories.list_categories() |> Enum.count() == entries_count
    end

    test "throw error when importing an invalid CSV file" do
      invalid_file_content = ""

      file_path = "test/support/fixtures/content.csv"
      :ok = File.write!(file_path, invalid_file_content)

      file = %Plug.Upload{
        content_type: "text/csv",
        filename: "categories.csv",
        path: file_path
      }

      assert {:error, "cannot store imported categories"} = ImportCSV.execute(file)
      assert Categories.list_categories() |> Enum.count() == 0

      File.rm!(file_path)
    end
  end
end
