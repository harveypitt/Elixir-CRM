defmodule Capclearv1Web.AuthLive.Login do
  use Capclearv1Web, :live_view
  alias Capclearv1.Accounts

  def mount(_params, _session, socket) do
    {:ok, assign(socket,
      form: to_form(%{"email" => "", "password" => ""})
    )}
  end

  def handle_event("validate", %{"user" => params}, socket) do
    {:noreply, assign(socket, form: to_form(params))}
  end

  def handle_event("login", %{"user" => %{"email" => email, "password" => password}}, socket) do
    case Accounts.authenticate_account(email, password) do
      {:ok, _account} ->
        {:noreply,
         socket
         |> put_flash(:info, "Welcome back!")
         |> redirect(to: ~p"/")}

      {:error, :unauthorized} ->
        {:noreply,
         socket
         |> put_flash(:error, "Invalid email or password")
         |> assign(form: to_form(%{"email" => email, "password" => ""}))}

      {:error, :not_found} ->
        {:noreply,
         socket
         |> put_flash(:error, "Invalid email or password")
         |> assign(form: to_form(%{"email" => email, "password" => ""}))}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div class="max-w-md w-full space-y-8">
        <div>
          <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">
            Sign in to your account
          </h2>
        </div>
        <.form
          for={@form}
          phx-submit="login"
          phx-change="validate"
          class="mt-8 space-y-6"
        >
          <div class="-space-y-px rounded-md shadow-sm">
            <div>
              <label for="email" class="sr-only">Email address</label>
              <input
                id="email"
                name="user[email]"
                type="email"
                required
                class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-t-md focus:outline-none focus:ring-primary-500 focus:border-primary-500 focus:z-10 sm:text-sm"
                placeholder="Email address"
                value={Phoenix.HTML.Form.input_value(@form, :email)}
              />
            </div>
            <div>
              <label for="password" class="sr-only">Password</label>
              <input
                id="password"
                name="user[password]"
                type="password"
                required
                class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-b-md focus:outline-none focus:ring-primary-500 focus:border-primary-500 focus:z-10 sm:text-sm"
                placeholder="Password"
                value={Phoenix.HTML.Form.input_value(@form, :password)}
              />
            </div>
          </div>

          <div>
            <button
              type="submit"
              class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
            >
              Sign in
            </button>
          </div>

          <div class="flex items-center justify-between">
            <div class="text-sm">
              <.link
                navigate={~p"/register"}
                class="font-medium text-primary-600 hover:text-primary-500"
              >
                Don't have an account? Sign up
              </.link>
            </div>
          </div>
        </.form>
      </div>
    </div>
    """
  end
end
