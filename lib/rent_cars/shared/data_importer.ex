defmodule RentCars.Shared.DataImporter do
  def import(file, perform_action) when file.content_type == "text/csv" do
    file_path = file.path

    file_path
    |> File.stream!()
    |> stream_data()
    |> perform_action.()
  end

  defp stream_data(file_stream) do
    remove_headers(file_stream)
    |> Stream.map(&String.trim(&1, "\n"))
    |> Stream.map(&String.split(&1, ","))
  end

  defp remove_headers(file_stream) do
    Stream.drop(file_stream, 1)
  end
end
