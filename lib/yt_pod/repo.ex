defmodule YTPod.Repo do
  use Ecto.Repo,
    otp_app: :yt_pod,
    adapter: Ecto.Adapters.Postgres
end
