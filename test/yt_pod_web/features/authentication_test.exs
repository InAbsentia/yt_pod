defmodule YTPodWeb.Features.AuthenticationTest do
  use YTPodWeb.ConnCase, async: true

  describe "when signed out" do
    test "can register a new account", %{conn: conn} do
      conn
      |> visit(~p"/")
      |> click_link("Register")
      |> fill_in(
        "#user-password-register-with-password_email",
        "Email",
        with: default_email()
      )
      |> fill_in(
        "#user-password-register-with-password_password",
        "Password",
        with: default_password()
      )
      |> fill_in(
        "#user-password-register-with-password_password_confirmation",
        "Password Confirmation",
        with: default_password()
      )
      |> submit()
      |> assert_has("#flash-info", text: "signed in")
    end

    test "can sign in", %{conn: conn} do
      register_user()

      conn
      |> visit(~p"/")
      |> click_link("Sign in")
      |> fill_in("#user-password-sign-in-with-password_email", "Email", with: default_email())
      |> fill_in("#user-password-sign-in-with-password_password", "Password", with: default_password())
      |> submit()
      |> assert_has("#flash-info", text: "signed in")
    end
  end

  describe "when logged in" do
    setup :register_and_log_in_user

    test "GET /sign-out logs user out and forwards to home page", %{conn: conn} do
      conn
      |> visit(~p"/")
      |> click_link("Sign out")
      |> assert_has("#flash-info", text: "signed out")
    end
  end
end
