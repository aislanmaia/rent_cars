defmodule RentCars.Mail.ForgotPasswordEmail do
  import Swoosh.Email
  import Phoenix.Component
  alias Floki
  alias Phoenix.HTML.Safe

  alias RentCars.Mailer

  def create_email(user, token) do
    url = "/sessions/reset_password?token=#{token}"
    template = email_content(%{url: url})
    html = heex_to_html(template)
    _text = html_to_text(html)

    new()
    |> to({user.first_name, user.email})
    |> from({"RentCars ELXPRO", "aislan.sousamaia@gmail.com"})
    |> subject("RentCars - Reset Password")
    |> html_body(html)
  end

  def send_forgot_password_email(user, token) do
    Task.async(fn ->
      user
      |> create_email(token)
      |> Mailer.deliver()
    end)
  end

  defp email_content(assigns) do
    ~H"""
    <h1>Hey there!</h1>

    <p>Please use this link to reset your password:</p>

    <a href={@url}><%= @url %></a>

    <p>If you didn't request this email, feel free to ignore this.</p>
    """
  end

  defp heex_to_html(template) do
    template
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  defp html_to_text(html) do
    html
    |> Floki.parse_document!()
    |> Floki.find("body")
    |> Floki.text(sep: "\n\n")
  end
end
