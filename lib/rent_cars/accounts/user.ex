defmodule RentCars.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Waffle.Ecto.Schema
  alias RentCars.Accounts.Avatar
  alias RentCars.Rentals.Rental

  @role_values ~w/USER ADMIN/a

  @fields ~w/role/a
  @required_fields ~w/first_name last_name user_name password password_confirmation email drive_license/a

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :user_name, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    field :email, :string
    field :drive_license, :string
    field :role, Ecto.Enum, values: @role_values, default: :USER
    field :avatar, Avatar.Type
    has_many :rentals, Rental

    timestamps()
  end

  def changeset(attrs) do
    changeset(%__MODULE__{}, attrs)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, @fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> validate_format(:email, ~r/@/, message: "invalid email format")
    |> update_change(:email, &String.downcase/1)
    |> validate_length(:password, min: 6, max: 100)
    |> validate_confirmation(:password)
    |> unique_constraint(:user_name)
    |> unique_constraint(:email)
    |> unique_constraint(:drive_license)
    |> hash_password()
  end

  def update_user(user, params) do
    changeset(user, params)
  end

  def update_photo(user, params) do
    cast_attachments(user, params, [:avatar])
  end

  defp hash_password(%{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password_hash: Argon2.hash_pwd_salt(password))
  end

  defp hash_password(changeset), do: changeset
end
