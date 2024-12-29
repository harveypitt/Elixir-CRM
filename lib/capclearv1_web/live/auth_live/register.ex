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
    <div class="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div class="max-w-md w-full space-y-8">
        <div>
          <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">
            Create your account
          </h2>
        </div>
        <.form
          for={@form}
          phx-change="validate"
          phx-submit="save"
          class="mt-8 space-y-6"
        >
          <div class="rounded-md shadow-sm space-y-4">
            <div>
              <label for="email" class="block text-sm font-medium text-gray-700">Email address</label>
              <input
                type="email"
                name="user[email]"
                id="email"
                required
                class="mt-1 focus:ring-primary-500 focus:border-primary-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md"
                value={Phoenix.HTML.Form.input_value(@form, :email)}
              />
              <%= if @check_errors && @changeset.errors[:email] do %>
                <p class="mt-1 text-sm text-red-600">
                  <%= translate_error(@changeset.errors[:email]) %>
                </p>
              <% end %>
            </div>

            <div>
              <label for="password" class="block text-sm font-medium text-gray-700">Password</label>
              <input
                type="password"
                name="user[password]"
                id="password"
                required
                class="mt-1 focus:ring-primary-500 focus:border-primary-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md"
                value={Phoenix.HTML.Form.input_value(@form, :password)}
              />
              <%= if @check_errors && @changeset.errors[:password] do %>
                <p class="mt-1 text-sm text-red-600">
                  <%= translate_error(@changeset.errors[:password]) %>
                </p>
              <% end %>
            </div>

            <div>
              <label for="password_confirmation" class="block text-sm font-medium text-gray-700">Confirm password</label>
              <input
                type="password"
                name="user[password_confirmation]"
                id="password_confirmation"
                required
                class="mt-1 focus:ring-primary-500 focus:border-primary-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md"
                value={Phoenix.HTML.Form.input_value(@form, :password_confirmation)}
              />
              <%= if @check_errors && @changeset.errors[:password_confirmation] do %>
                <p class="mt-1 text-sm text-red-600">
                  <%= translate_error(@changeset.errors[:password_confirmation]) %>
                </p>
              <% end %>
            </div>

            <div>
              <label for="first_name" class="block text-sm font-medium text-gray-700">First name</label>
              <input
                type="text"
                name="user[first_name]"
                id="first_name"
                required
                class="mt-1 focus:ring-primary-500 focus:border-primary-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md"
                value={Phoenix.HTML.Form.input_value(@form, :first_name)}
              />
            </div>

            <div>
              <label for="last_name" class="block text-sm font-medium text-gray-700">Last name</label>
              <input
                type="text"
                name="user[last_name]"
                id="last_name"
                required
                class="mt-1 focus:ring-primary-500 focus:border-primary-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md"
                value={Phoenix.HTML.Form.input_value(@form, :last_name)}
              />
            </div>

            <div>
              <label for="type" class="block text-sm font-medium text-gray-700">Account type</label>
              <select
                id="type"
                name="user[type]"
                required
                class="mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-primary-500 focus:border-primary-500 sm:text-sm"
                value={Phoenix.HTML.Form.input_value(@form, :type)}
              >
                <option value="dietitian">Dietitian</option>
                <option value="patient">Patient</option>
              </select>
            </div>
          </div>

          <div>
            <button
              type="submit"
              class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
            >
              Create account
            </button>
          </div>

          <div class="flex items-center justify-between">
            <div class="text-sm">
              <.link
                navigate={~p"/login"}
                class="font-medium text-primary-600 hover:text-primary-500"
              >
                Already have an account? Sign in
              </.link>
            </div>
          </div>
        </.form>
      </div>
    </div>
    """
  end
end
