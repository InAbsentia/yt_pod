defmodule YTPod.Accounts.User.Senders.SendMagicLinkEmail do
  @moduledoc """
  Sends a magic link email
  """

  use AshAuthentication.Sender
  use YTPodWeb, :verified_routes

  import Swoosh.Email

  alias AshAuthentication.Sender
  alias YTPod.Mailer

  @impl Sender
  def send(user_or_email, token, _) do
    # if you get a user, its for a user that already exists.
    # if you get an email, then the user does not yet exist.
    email =
      case user_or_email do
        %{email: email} -> email
        email -> email
      end

    name = :yt_pod |> Application.fetch_env!(Mailer) |> Keyword.fetch!(:send_from_name)
    address = :yt_pod |> Application.fetch_env!(Mailer) |> Keyword.fetch!(:send_from_address)

    new()
    |> from({name, address})
    |> to(to_string(email))
    |> subject("Your login link")
    |> html_body(body(token: token, email: email))
    |> Mailer.deliver!()
  end

  defp body(params) do
    # NOTE: You may have to change this to match your magic link acceptance URL.

    """
    <p>Hello, #{params[:email]}! Click this link to sign in:</p>
    <p><a href="#{url(~p"/magic_link/#{params[:token]}")}">#{url(~p"/magic_link/#{params[:token]}")}</a></p>
    """
  end
end
