defmodule RentCars.Shared.TokenrTest do
  use RentCars.DataCase

  alias RentCars.Shared.Tokenr
  import RentCars.AccountsFixtures

  test "create auth token" do
    user = user_fixture()

    token = Tokenr.generate_auth_token(user)

    assert {:ok, returned_user} = Tokenr.verify_auth_token(token)
    assert user == returned_user
  end

  test "verify expired auth token" do
    user = user_fixture()

    token = Tokenr.generate_auth_token(user)

    # Simulate shorter lifespan with custom max_age (e.g., 1 second)
    :timer.sleep(1_000)
    assert {:error, :expired} == Tokenr.verify_auth_token(token, 1)
  end

  test "create forgot email token" do
    user = user_fixture()

    token = Tokenr.generate_forgot_email_token(user)

    assert {:ok, returned_user} = Tokenr.verify_forgot_email_token(token)
    assert user == returned_user
  end
end
