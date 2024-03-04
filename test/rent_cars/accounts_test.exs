defmodule RentCars.AccountsTest do
  use RentCars.DataCase
  alias RentCars.Accounts

  describe "create users" do
    test "create_user/1 with valid data" do
      valid_attrs = %{
        first_name: "user first name"
      }

      assert {:ok, user} = Accounts.create_user(valid_attrs)

      assert user.first_name == valid_attrs.first_name
    end
  end
end
