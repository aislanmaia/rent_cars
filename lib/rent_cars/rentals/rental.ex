defmodule RentCars.Rentals.Rental do
  alias RentCars.Accounts.User
  alias RentCars.Cars.Car
  use Ecto.Schema
  import Ecto.Changeset

  @fields [:end_date, :total]
  @required [:start_date, :expected_return_date, :car_id, :user_id]
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "rentals" do
    field :total, :integer
    field :start_date, :naive_datetime
    field :end_date, :naive_datetime
    field :expected_return_date, :naive_datetime
    belongs_to :car, Car
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(rental, attrs) do
    rental
    |> cast(attrs, @fields ++ @required)
    |> validate_required(@required)
  end
end
