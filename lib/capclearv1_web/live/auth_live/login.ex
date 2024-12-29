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
    <section class="min-h-screen bg-white">
      <div class="flex flex-col items-center justify-start px-6 pt-16 mx-auto min-h-screen">
        <a href="/" class="flex items-center mb-6 text-2xl font-semibold text-gray-900 dark:text-white">
          <img class="w-8 h-8 mr-2" src="https://flowbite.s3.amazonaws.com/blocks/marketing-ui/logo.svg" alt="logo">
          CapClear
        </a>
        <div class="w-full md:mt-0 sm:max-w-md xl:p-0">
          <div class="p-6 space-y-4 md:space-y-6 sm:p-8 bg-white rounded-xl shadow-[0_4px_20px_-4px_rgba(0,0,0,0.1)] dark:shadow-[0_4px_20px_-4px_rgba(255,255,255,0.1)] dark:bg-gray-800">
            <h1 class="text-xl font-bold leading-tight tracking-tight text-gray-900 md:text-2xl dark:text-white">
              Sign in to your account
            </h1>
            <.form
              for={@form}
              phx-submit="login"
              phx-change="validate"
              class="space-y-4 md:space-y-6"
            >
              <div>
                <label for="email" class="block mb-2 text-sm font-medium text-gray-900 dark:text-white">Your email</label>
                <input
                  type="email"
                  name="user[email]"
                  id="email"
                  class="bg-gray-50 border border-gray-300 text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                  placeholder="name@company.com"
                  required
                  value={Phoenix.HTML.Form.input_value(@form, :email)}
                />
              </div>
              <div>
                <label for="password" class="block mb-2 text-sm font-medium text-gray-900 dark:text-white">Password</label>
                <input
                  type="password"
                  name="user[password]"
                  id="password"
                  placeholder="••••••••"
                  class="bg-gray-50 border border-gray-300 text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                  required
                  value={Phoenix.HTML.Form.input_value(@form, :password)}
                />
              </div>
              <button
                type="submit"
                class="w-full text-white bg-primary-600 hover:bg-primary-700 focus:ring-4 focus:outline-none focus:ring-primary-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800"
              >
                Sign in
              </button>
              <p class="text-sm font-light text-gray-500 dark:text-gray-400">
                Don't have an account yet?
                <.link
                  navigate={~p"/register"}
                  class="font-medium text-primary-600 hover:underline dark:text-primary-500"
                >
                  Sign up
                </.link>
              </p>
            </.form>
          </div>
        </div>
      </div>
    </section>
    """
  end
end
