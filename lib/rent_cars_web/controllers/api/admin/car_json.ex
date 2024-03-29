defmodule RentCarsWeb.Api.Admin.CarJSON do
  alias RentCarsWeb.Api.Admin.CategoryJSON
  alias RentCarsWeb.Api.Admin.SpecificationJSON

  def show(%{car: car}) do
    %{data: data(car)}
  end

  defp data(car) do
    %{
      id: car.id,
      name: car.name,
      description: car.description,
      brand: car.brand,
      available: car.available,
      daily_rate: car.daily_rate,
      license_plate: car.license_plate,
      fine_amount: Money.to_string(car.fine_amount),
      category: load_category(car.category),
      specifications: load_specifications(car.specifications)
    }
  end

  defp load_category(category) do
    if Ecto.assoc_loaded?(category) do
      CategoryJSON.show(%{category: category})
    else
      nil
    end
  end

  defp load_specifications(specifications) do
    if Ecto.assoc_loaded?(specifications) do
      SpecificationJSON.index(%{specifications: specifications})
    else
      nil
    end
  end
end
