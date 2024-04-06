defmodule RentCars.Categories.ImportCSV do
  alias RentCars.Categories.Category
  alias RentCars.Shared.DataImporter
  alias RentCars.Repo

  def execute(file) do
    case DataImporter.import(file, &build_categories/1) |> insert_all() do
      {number_of_entries, nil} when number_of_entries > 0 ->
        {:ok, number_of_entries}

      _ ->
        {:error, "cannot store imported categories"}
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

  defp insert_all(structs) do
    now =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

    placeholders = %{now: now}

    Category
    |> Repo.insert_all(structs, placeholders: placeholders)
  end
end
