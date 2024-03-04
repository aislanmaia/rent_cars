defmodule RentCars.AccountsTest do
  use RentCars.DataCase
  alias RentCars.Accounts

  describe "create users" do
    test "create_user/1 with valid data" do
      valid_attrs = %{
        first_name: "user first name",
        last_name: "user last name",
        user_name: "user user_name",
        password: "123456",
        password_confirmation: "123456",
        email: "user@email.com",
        drive_license: "ABC"
      }

      assert {:ok, user} = Accounts.create_user(valid_attrs)

      assert user.first_name == valid_attrs.first_name
      assert user.last_name == valid_attrs.last_name
      assert user.user_name == valid_attrs.user_name
      assert user.password == valid_attrs.password
      assert user.password_confirmation == valid_attrs.password_confirmation
      assert user.email == valid_attrs.email
      assert user.drive_license == valid_attrs.drive_license
    end
  end
end
