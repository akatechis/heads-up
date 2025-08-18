defmodule HeadsUpWeb.SignupLive do
  use HeadsUpWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Sign Up")}
  end

  def render(assigns) do
    ~H"""
    <div class="signup">
      <h1>Sign Up</h1>
      <p>Join our community to stay updated with the latest incidents and efforts.</p>
      <form phx-submit="signup">
        <label for="email">
          Email:
          <input type="email" name="email" id="email" required />
        </label>
        <button type="submit">Sign Up</button>
      </form>
    </div>
    """
  end

  def handle_event("signup", %{"email" => email}, socket) do
    IO.puts("User signed up with email: #{email}")

    put_flash(socket, :info, "Thank you for signing up!")
    {:reply, %{}, socket}
  end
end
