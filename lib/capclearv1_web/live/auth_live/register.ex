defmodule Capclearv1Web.AuthLive.Register do
  use Capclearv1Web, :live_view
  alias Capclearv1.Users
  alias Capclearv1.Accounts.Account

  def mount(_params, _session, socket) do
    form = to_form(%{
      "email" => "",
      "password" => "",
      "password_confirmation" => "",
      "first_name" => "",
      "last_name" => "",
      "type" => "dietitian"
    }, as: "user")

    {:ok,
     assign(socket,
       form: form,
       check_errors: false
     )}
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      %Account{}
      |> Account.changeset(%{
        email: user_params["email"],
        password: user_params["password"],
        password_confirmation: user_params["password_confirmation"]
      })
      |> Map.put(:action, :validate)

    {:noreply,
     assign(socket,
       form: to_form(user_params, as: "user"),
       check_errors: true,
       changeset: changeset
     )}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Users.create_user_with_account(
           Map.drop(user_params, ["password_confirmation"]),
           %{
             "email" => user_params["email"],
             "password" => user_params["password"],
             "password_confirmation" => user_params["password_confirmation"]
           }
         ) do
      {:ok, %{user: _user}} ->
        {:noreply,
         socket
         |> put_flash(:info, "Account created successfully!")
         |> redirect(to: ~p"/login")}

      {:error, :account, changeset, _} ->
        {:noreply,
         socket
         |> put_flash(:error, "Error creating account")
         |> assign(form: to_form(user_params, as: "user"), changeset: changeset)}

      {:error, :user, _changeset, _} ->
        {:noreply,
         socket
         |> put_flash(:error, "Error creating user profile")
         |> assign(form: to_form(user_params, as: "user"))}
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
              Create your account
            </h1>
            <.form
              for={@form}
              phx-change="validate"
              phx-submit="save"
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
                <%= if @check_errors && @changeset.errors[:email] do %>
                  <p class="mt-1 text-sm text-red-600 dark:text-red-500">
                    <%= translate_error(@changeset.errors[:email]) %>
                  </p>
                <% end %>
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
                <%= if @check_errors && @changeset.errors[:password] do %>
                  <p class="mt-1 text-sm text-red-600 dark:text-red-500">
                    <%= translate_error(@changeset.errors[:password]) %>
                  </p>
                <% end %>
              </div>

              <div>
                <label for="password_confirmation" class="block mb-2 text-sm font-medium text-gray-900 dark:text-white">Confirm password</label>
                <input
                  type="password"
                  name="user[password_confirmation]"
                  id="password_confirmation"
                  placeholder="••••••••"
                  class="bg-gray-50 border border-gray-300 text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                  required
                  value={Phoenix.HTML.Form.input_value(@form, :password_confirmation)}
                />
                <%= if @check_errors && @changeset.errors[:password_confirmation] do %>
                  <p class="mt-1 text-sm text-red-600 dark:text-red-500">
                    <%= translate_error(@changeset.errors[:password_confirmation]) %>
                  </p>
                <% end %>
              </div>

              <div>
                <label for="first_name" class="block mb-2 text-sm font-medium text-gray-900 dark:text-white">First name</label>
                <input
                  type="text"
                  name="user[first_name]"
                  id="first_name"
                  class="bg-gray-50 border border-gray-300 text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                  placeholder="John"
                  required
                  value={Phoenix.HTML.Form.input_value(@form, :first_name)}
                />
              </div>

              <div>
                <label for="last_name" class="block mb-2 text-sm font-medium text-gray-900 dark:text-white">Last name</label>
                <input
                  type="text"
                  name="user[last_name]"
                  id="last_name"
                  class="bg-gray-50 border border-gray-300 text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                  placeholder="Doe"
                  required
                  value={Phoenix.HTML.Form.input_value(@form, :last_name)}
                />
              </div>

              <div>
                <label for="type" class="block mb-2 text-sm font-medium text-gray-900 dark:text-white">Account type</label>
                <select
                  id="type"
                  name="user[type]"
                  required
                  class="bg-gray-50 border border-gray-300 text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                  value={Phoenix.HTML.Form.input_value(@form, :type)}
                >
                  <option value="dietitian">Dietitian</option>
                  <option value="patient">Patient</option>
                </select>
              </div>

              <button
                type="submit"
                class="w-full text-white bg-primary-600 hover:bg-primary-700 focus:ring-4 focus:outline-none focus:ring-primary-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800"
              >
                Create account
              </button>
              <p class="text-sm font-light text-gray-500 dark:text-gray-400">
                Already have an account?
                <.link
                  navigate={~p"/login"}
                  class="font-medium text-primary-600 hover:underline dark:text-primary-500"
                >
                  Sign in
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
