import Config

alias Swoosh.Adapters.Test

config :ash, policies: [show_policy_breakdowns?: true], disable_async?: true

config :bcrypt_elixir, log_rounds: 1

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# In test we don't send emails
config :yt_pod, YTPod.Mailer, adapter: Test

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :yt_pod, YTPod.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "yt_pod_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :yt_pod, YTPodWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "BO9DnSN7z4NDdtNyM4TOo7TAN2hwoB//PsJ45IbFCmPuFVieLDXGAgaoFGC10Xgv",
  server: false

config :yt_pod, token_signing_secret: "PCRlZ2nmXZZMgo5hajDcDYsgmjcHIo8r"
