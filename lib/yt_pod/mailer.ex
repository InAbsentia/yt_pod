defmodule YTPod.Mailer do
  use Swoosh.Mailer, otp_app: :yt_pod

  def auth_sender do
    :yt_pod
    |> Application.fetch_env!(__MODULE__)
    |> Keyword.fetch!(:auth_sender)
  end
end
