defmodule RentCars.Mail.ForgotPasswordEmailTest do
  use RentCars.DataCase
  import RentCars.AccountsFixtures
  alias RentCars.Mail.ForgotPasswordEmail

  test "send email to reset password" do
    user = user_fixture()
    token = "asdfsadf"
    email = ForgotPasswordEmail.create_email(user, token)
    assert email.to == [{user.first_name, user.email}]
  end
end
