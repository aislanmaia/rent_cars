defmodule RentCars.Accounts.Avatar do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @versions [:original, :thumb]
  @extensions ~w(.jpg .jpeg .png)

  def validate({file, _}) do
    file_extension = file.file_name |> Path.extname() |> String.downcase()

    case Enum.member?(@extensions, file_extension) do
      true -> :ok
      false -> {:error, "file type is invalid"}
    end
  end

  def transform(:thumb, _) do
    {:convert, "-thumbnail 100x100^ -gravity center -extent 100x100 -format png", :png}
  end

  def filename(version, {_file, _scope}) do
    # If need to get the filename without extension part
    # file.file_name |> Path.extname() |> then(&Path.basename(file.file_name, &1))
    version
  end

  def storage_dir(_, {_file, user}) do
    "uploads/avatars/#{user.id}"
  end
end
