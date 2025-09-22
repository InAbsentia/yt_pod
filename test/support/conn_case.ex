defmodule YTPodWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use YTPodWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  alias AshAuthentication.Plug.Helpers
  alias YTPod.Accounts.User

  using do
    quote do
      use YTPodWeb, :verified_routes

      # Import conveniences for testing with connections
      import Phoenix.ConnTest
      import PhoenixTest
      import Plug.Conn
      import YTPodWeb.ConnCase

      # The default endpoint for testing
      @endpoint YTPodWeb.Endpoint
    end
  end

  setup tags do
    YTPod.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  def register_user do
    email = default_email()
    password = default_password()

    {:ok, hashed_password} = AshAuthentication.BcryptProvider.hash(password)

    Ash.Seed.seed!(User, %{
      email: email,
      hashed_password: hashed_password
    })
  end

  def register_and_log_in_user(%{conn: conn} = context) do
    %User{} = register_user()

    strategy = AshAuthentication.Info.strategy!(User, :password)

    {:ok, user} =
      AshAuthentication.Strategy.action(strategy, :sign_in, %{
        email: default_email(),
        password: default_password()
      })

    new_conn =
      conn
      |> Phoenix.ConnTest.init_test_session(%{})
      |> Helpers.store_in_session(user)

    %{context | conn: new_conn}
  end

  def default_email, do: "user@example.com"
  def default_password, do: "password"
end
