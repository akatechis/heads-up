defmodule HeadsUpWeb.EffortLive do
  use HeadsUpWeb, :live_view

  @initial_responders 0
  @initial_minutes_per_responder 10

  def mount(_params, _session, socket) do
    schedule_tick()

    {:ok,
     assign(socket,
       responders: @initial_responders,
       minutes_per_responder: @initial_minutes_per_responder
     )}
  end

  def render(assigns) do
    ~H"""
    <div class="effort">
      <h1>Community Love</h1>
      
      <p>This calculator will help you estimate the total time needed to respond to an event</p>
      
      <section>
        <button phx-click="add" phx-value-quantity="3">+3</button>
        <div>{@responders}</div>
        &times;
        <div>{@minutes_per_responder}</div>
        =
        <div>{@responders * @minutes_per_responder} minutes</div>
      </section>
      
      <form phx-submit="set-minutes">
        <label>Minutes per responder:</label>
        <input type="number" name="minutes_per_responder" value={@minutes_per_responder} />
      </form>
    </div>
    """
  end

  def handle_event("add", %{"quantity" => quantity}, socket) do
    socket = update(socket, :responders, &(&1 + String.to_integer(quantity)))
    {:noreply, socket}
  end

  def handle_event("set-minutes", %{"minutes_per_responder" => minutes}, socket) do
    socket = assign(socket, :minutes_per_responder, String.to_integer(minutes))
    {:noreply, socket}
  end

  def schedule_tick do
    Process.send_after(self(), :tick, 2000)
  end

  def handle_info(:tick, socket) do
    schedule_tick()
    {:noreply, update(socket, :responders, &(&1 + 10))}
  end
end
