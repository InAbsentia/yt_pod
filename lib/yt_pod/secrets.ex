defmodule YTPod.Secrets do
  @moduledoc false

  use AshAuthentication.Secret

  alias YTPod.Accounts.User

  def secret_for([:authentication, :tokens, :signing_secret], User, _opts, _context) do
    Application.fetch_env(:yt_pod, :token_signing_secret)
  end
end
