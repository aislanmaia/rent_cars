defmodule RentCars.Sessions.ResetPasswordTest do
  use RentCars.DataCase

  alias RentCars.Sessions.ResetPassword
  alias RentCars.Shared.Tokenr
  import RentCars.AccountsFixtures

  test "reset user password" do
    user = user_fixture()
    token = Tokenr.generate_forgot_email_token(user)

    params = %{
      "token" => token,
      "user" => %{"password" => "123456", "password_confirmation" => "123456"}
    }

    assert {:ok, returned_user} = ResetPassword.execute(params)
    assert user.email == returned_user.email
  end

  test "throw error when token is invalid" do
    params = %{"token" => "invalid token", "user" => {}}
    assert {:error, message} = ResetPassword.execute(params)
    assert "Invalid token" == message
  end
end
