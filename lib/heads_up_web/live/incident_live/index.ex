defmodule HeadsUpWeb.IncidentLive.Index do
  use HeadsUpWeb, :live_view
  alias HeadsUp.Incidents
  import HeadsUpWeb.CustomComponents

  def mount(_params, _session, socket) do
    socket = socket
      |> assign(page_title: "Incidents")
      |> stream(:incidents, Incidents.list_incidents())

    # IO.inspect(socket, label: "IncidentLive.Index MOUNT")
    # socket = attach_hook(socket, :log_stream, :after_render, fn socket ->
    #   IO.inspect(socket.assigns.streams, label: "Streams after render")
    #   socket
    # end)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Incidents</h1>

    <div class="incident-index">
      <div class="incidents" id="incidents" phx-update="stream">
        <.incident_card :for={{dom_id, incident} <- @streams.incidents} incident={incident} id={dom_id} />
      </div>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :incident, HeadsUp.Incidents.Incident, required: true
  def incident_card(assigns) do
    ~H"""
    <.link navigate={~p"/incidents/#{@incident}"} id={@id}>
      <div class="card">
        <img src={@incident.image_path} />
        <h2>{@incident.name}</h2>

        <div class="details">
          <.badge text={@incident.status} />
          <div class="priority">
            {@incident.priority}
          </div>
        </div>
      </div>
    </.link>
    """
  end
end
