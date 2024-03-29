defmodule RentCars.AccountsTest do
  alias RentCars.Accounts.Avatar
  use RentCars.DataCase
  alias RentCars.Accounts
  import RentCars.AccountsFixtures

  describe "upload avatar" do
    test "upload avatar image" do
      user = user_fixture()

      photo = %Plug.Upload{
        content_type: "image/png",
        filename: "avatar.png",
        path: "test/support/fixtures/avatar.png"
      }

      assert {:ok, filename} = Accounts.upload_photo(user.id, photo)

      assert filename == "avatar.png"

      assert Avatar.url({"avatar.png", user}, :original) ==
               "/#{Avatar.storage_dir(nil, {filename, user})}/original.png"

      assert :ok = Avatar.delete({photo.filename, user})

      File.rm_rf!("uploads")
    end
  end

  describe "get_user" do
    test "get_user/1" do
      user = user_fixture()

      assert Accounts.get_user!(user.id).email == user.email
    end
  end

  describe "create users" do
    test "create_user/1 with valid data" do
      valid_attrs = %{
        first_name: "user first name",
        last_name: "user last name",
        user_name: "user user_name",
        password: "123456",
        password_confirmation: "123456",
        email: "User@email.com",
        drive_license: "ABC"
      }

      assert {:ok, user} = Accounts.create_user(valid_attrs)

      assert user.first_name == valid_attrs.first_name
      assert user.last_name == valid_attrs.last_name
      assert user.user_name == valid_attrs.user_name
      assert user.password == valid_attrs.password
      assert user.password_confirmation == valid_attrs.password_confirmation
      assert user.email == String.downcase(valid_attrs.email)
      assert user.drive_license == valid_attrs.drive_license
    end

    test "create_user/1 throw an error when fields are not unique" do
      valid_attrs = %{
        first_name: "user first name",
        last_name: "user last name",
        user_name: "user user_name",
        password: "123456",
        password_confirmation: "123456",
        email: "User@email.com",
        drive_license: "ABC"
      }

      Accounts.create_user(valid_attrs)
      assert {:error, changeset} = Accounts.create_user(valid_attrs)
      assert %{user_name: ["has already been taken"]} = errors_on(changeset)
    end

    test "create_user/1 throw an error with invalid email" do
      attrs = %{
        first_name: "user first name",
        last_name: "user last name",
        user_name: "user user_name",
        password: "123456",
        password_confirmation: "123456",
        email: "invalid email",
        drive_license: "ABC"
      }

      assert {:error, changeset} = Accounts.create_user(attrs)
      assert "invalid email format" in errors_on(changeset).email
    end

    test "create_user/1 throw an error with invalid password" do
      attrs = %{
        first_name: "user first name",
        last_name: "user last name",
        user_name: "user user_name",
        password: "12345",
        password_confirmation: "12345",
        email: "user@email.com",
        drive_license: "ABC"
      }

      assert {:error, changeset} = Accounts.create_user(attrs)
      assert "should be at least 6 character(s)" in errors_on(changeset).password
    end

    test "create_user/1 throw an error with invalid password confirmation" do
      attrs = %{
        first_name: "user first name",
        last_name: "user last name",
        user_name: "user user_name",
        password: "123456",
        password_confirmation: "wrong password confirmation",
        email: "user@email.com",
        drive_license: "ABC"
      }

      assert {:error, changeset} = Accounts.create_user(attrs)
      assert "does not match confirmation" in errors_on(changeset).password_confirmation
    end
  end
end
