defmodule RentCarsWeb.Api.CategoryJSON do
  def index(%{categories: categories}) do
    %{data: for(category <- categories, do: data(category))}
  end

  @doc """
  Renders a single category.
  """
  def show(%{category: category}) do
    %{data: data(category)}
  end

  defp data(category) do
    %{
      id: category.id,
      description: category.description,
      name: category.name
    }
  end
end
