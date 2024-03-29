defmodule RentCars.Mail.ForgotPasswordEmailTest do
  use RentCars.DataCase
  import RentCars.AccountsFixtures
  import Swoosh.TestAssertions
  alias RentCars.Mail.ForgotPasswordEmail

  test "send email to reset password" do
    user = user_fixture()
    token = "asdfsadf"
    email = ForgotPasswordEmail.create_email(user, token)
    assert email.to == [{user.first_name, user.email}]
    assert_email_not_sent(email)
  end

  test "sent email to reset password" do
    user = user_fixture()
    token = "sadafasdfsaff"
    ForgotPasswordEmail.send_forgot_password_email(user, token)

    assert {:email, email_result} = assert_email_sent()
    assert [{user.first_name, user.email}] == email_result.to
  end
end
