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
alias RentCars.Accounts.User
alias RentCars.Repo

# %{
#   first_name: "user first name",
#   last_name: "user last name",
#   user_name: "user",
#   password: "123456",
#   password_confirmation: "123456",
#   email: "user@email.com",
#   drive_license: "ZSH123",
#   role: "USER"
# }
# |> Accounts.create_user()

# %{
#   first_name: "user first name",
#   last_name: "user last name",
#   user_name: "admin",
#   password: "123456",
#   password_confirmation: "123456",
#   email: "admin@email.com",
#   drive_license: "ZSH456",
#   role: "ADMIN"
# }
# |> Accounts.create_user()

defmodule UserGenerator do
  def generate_random_user do
    first_names = ["João", "Maria", "Pedro", "Ana", "José"]
    last_names = ["Anacleto", "Ribeiro", "Drumond", "Silva"]

    first_name = Enum.random(first_names)
    last_name = Enum.random(last_names)
    user_name = "user_#{:rand.uniform(10_000)}"
    password = "123456"
    password_confirmation = "123456"
    email = "#{first_name}.#{:rand.uniform(10_000)}@email.com"

    drive_license =
      "ASDF-#{:rand.uniform(10_000)}"

    role = Enum.random(["USER", "ADMIN"])

    %{
      first_name: first_name,
      last_name: last_name,
      user_name: user_name,
      password: password,
      password_confirmation: password_confirmation,
      email: email,
      drive_license: drive_license,
      role: role
    }
  end
end

# Gera 20 usuários
for i <- 1..20 do
  user = UserGenerator.generate_random_user()
  Accounts.create_user(user)
end
