defmodule RentCars.Cars.Car do
  use Ecto.Schema
  import Ecto.Changeset
  alias RentCars.Cars.CarImage
  alias RentCars.Cars.CarSpecification
  alias RentCars.Categories.Category
  alias RentCars.Specifications.Specification

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @fields ~w/available brand daily_rate description fine_amount license_plate name category_id/a
  schema "cars" do
    field :name, :string
    field :description, :string
    field :available, :boolean, default: true
    field :brand, :string
    field :daily_rate, :integer
    field :fine_amount, Money.Ecto.Amount.Type
    field :license_plate, :string
    belongs_to :category, Category
    many_to_many :specifications, Specification, join_through: CarSpecification
    has_many :images, CarImage, on_replace: :delete_if_exists, on_delete: :delete_all

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(car, attrs) do
    car
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> update_change(:license_plate, &String.upcase/1)
    |> unique_constraint(:license_plate)
    |> cast_assoc(:specifications, with: &Specification.changeset/2)
    |> cast_assoc(:images, with: &CarImage.changeset/2)
  end

  def update_changeset(car, attrs) do
    car
    |> changeset(attrs)
    |> validate_change(:license_plate, fn :license_plate, license_plate ->
      if car.license_plate != license_plate do
        [license_plate: "you can't update license_plate"]
      else
        []
      end
    end)
  end
end
