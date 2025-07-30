defmodule YTPod.Accounts.User.Senders.SendNewUserConfirmationEmail do
  @moduledoc """
  Sends an email for a new user to confirm their email address.
  """

  use AshAuthentication.Sender
  use YTPodWeb, :verified_routes

  import Swoosh.Email

  alias AshAuthentication.Sender
  alias YTPod.Mailer

  @impl Sender
  def send(user, token, _) do
    name = :yt_pod |> Application.fetch_env!(Mailer) |> Keyword.fetch!(:send_from_name)
    address = :yt_pod |> Application.fetch_env!(Mailer) |> Keyword.fetch!(:send_from_address)

    new()
    |> from({name, address})
    |> to(to_string(user.email))
    |> subject("Confirm your email address")
    |> html_body(body(token: token))
    |> Mailer.deliver!()
  end

  defp body(params) do
    url = url(~p"/confirm_new_user/#{params[:token]}")

    """
    <p>Click this link to confirm your email:</p>
    <p><a href="#{url}">#{url}</a></p>
    """
  end
end
