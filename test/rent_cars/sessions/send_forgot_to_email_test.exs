defmodule RentCars.Sessions.SendForgotToEmailTest do
  use RentCars.DataCase

  alias RentCars.Sessions.SendForgotToEmail
  import RentCars.AccountsFixtures

  test "send email to reset password" do
    user = user_fixture()

    assert {:ok, _returned_user, _token} = SendForgotToEmail.execute(user.email)
  end

  test "throw an error when user does not exist" do
    assert {:error, message} = SendForgotToEmail.execute("unexisting email")
    assert "User doest not exist" == message
  end
end
