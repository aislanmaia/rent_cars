defmodule RentCars.Cars do
  import Ecto.Query
  alias __MODULE__.Car
  alias RentCars.Repo

  def get_car!(id), do: Repo.get!(Car, id)

  def with_assoc(car, assoc), do: Repo.preload(car, assoc)

  def create(attrs) do
    %Car{}
    |> Car.changeset(attrs)
    |> Repo.insert()
  end

  def update(car_id, attrs) do
    car_id
    |> get_car!()
    |> Car.update_changeset(attrs)
    |> Repo.update()
  end

  def list_available_cars(filter_params \\ []) do
    # Repo.all(from Car, where: [available: true], preload: [:specifications])

    query = where(Car, [c], c.available == true)

    filter_params
    |> Enum.reduce(query, fn
      {:name, name}, query ->
        name_filter = "%" <> name <> "%"
        where(query, [c], ilike(c.name, ^name_filter))

      {:brand, brand}, query ->
        brand_filter = "%" <> brand <> "%"
        where(query, [c], ilike(c.brand, ^brand_filter))

      {:category, category}, query ->
        category_filter = "%" <> category <> "%"

        query
        |> join(:inner, [c], ca in assoc(c, :category))
        |> where([_c, ca], ilike(ca.name, ^category_filter))
    end)
    |> preload([:specifications])
    |> Repo.all()
  end

  def create_images(car_id, images) do
    car_id
    |> get_car!()
    |> Repo.preload([:images])
    |> Car.changeset(%{images: images})
    |> Repo.update()
  end
end
