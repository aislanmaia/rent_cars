defmodule RentCars.SessionsTest do
  use RentCars.DataCase

  alias RentCars.Sessions
  import RentCars.AccountsFixtures

  test "get user from token" do
    user = user_fixture()
    password = "123456"

    assert {:ok, _returned_user, token} = Sessions.create(user.email, password)
    assert {:ok, returned_user} = Sessions.me(token)

    assert user.email == returned_user.email
  end

  test "return authenticated user" do
    user = user_fixture()
    password = "123456"

    assert {:ok, returned_user, _token} = Sessions.create(user.email, password)
    assert user.email == returned_user.email
  end

  test "throw error when user password is incorrect" do
    user = user_fixture()
    password = "incorrect"

    assert {:error, message} = Sessions.create(user.email, password)
    assert "Email or password is incorrect" == message
  end

  test "throw error when user email is invalid" do
    email = "invalid email"
    password = "incorrect"

    assert {:error, message} = Sessions.create(email, password)
    assert "Email or password is incorrect" == message
  end
end
