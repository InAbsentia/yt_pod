defmodule YTPod.Accounts do
  use Ash.Domain,
    otp_app: :yt_pod

  alias YTPod.Accounts.Token
  alias YTPod.Accounts.User

  resources do
    resource Token
    resource User
  end
end
