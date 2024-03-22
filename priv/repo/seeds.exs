# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     RentCars.Repo.insert!(%RentCars.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias RentCars.Accounts

%{
  first_name: "user first name",
  last_name: "user last name",
  user_name: "user",
  password: "123456",
  password_confirmation: "123456",
  email: "user@email.com",
  drive_license: "ZSH123",
  role: "USER"
}
|> Accounts.create_user()

%{
  first_name: "user first name",
  last_name: "user last name",
  user_name: "admin",
  password: "123456",
  password_confirmation: "123456",
  email: "admin@email.com",
  drive_license: "ZSH456",
  role: "ADMIN"
}
|> Accounts.create_user()
