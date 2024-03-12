defmodule RentCars.AccountsFixtures do
  alias RentCars.Accounts

  def user_attrs(attrs \\ %{}) do
    valid_attrs = %{
      first_name: "user first name",
      last_name: "user last name",
      user_name: "user user_name",
      password: "123456",
      password_confirmation: "123456",
      email: "User@email.com",
      drive_license: "ABC"
    }

    Enum.into(attrs, valid_attrs)
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> user_attrs()
      |> Accounts.create_user()

    user
  end
end
