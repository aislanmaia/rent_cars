defmodule RentCars.Rentals.Rental do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [:start_date, :end_date, :expected_return_date, :total]
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "rentals" do
    field :total, :integer
    field :start_date, :naive_datetime
    field :end_date, :naive_datetime
    field :expected_return_date, :naive_datetime
    field :car_id, :binary_id
    field :user_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(rental, attrs) do
    rental
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
