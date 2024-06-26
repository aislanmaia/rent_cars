defmodule RentCars.Categories do
  alias __MODULE__.Category
  alias RentCars.Categories.ImportCSV
  alias RentCars.Repo

  def list_categories do
    Repo.all(Category)
  end

  def create_category(attrs) do
    attrs
    |> Category.changeset()
    |> Repo.insert()
  end

  def update_category(category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  def get_category!(id) do
    Repo.get!(Category, id)
  end

  def delete_category(category) do
    Repo.delete(category)
  end

  def import_categories(file) do
    ImportCSV.execute(file)
  end
end
