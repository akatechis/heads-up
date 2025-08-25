defmodule HeadsUpWeb.IncidentLive.Index do
  use HeadsUpWeb, :live_view
  alias HeadsUp.Incidents
  import HeadsUpWeb.CustomComponents

  def mount(_params, _session, socket) do
    {:ok, assign(socket, incidents: Incidents.list_incidents(), page_title: "Incidents")}
  end

  def render(assigns) do
    ~H"""
    <h1>Incidents</h1>

    <div class="incident-index">
      <div class="incidents">
        <.incident_card :for={incident <- @incidents} incident={incident} />
      </div>
    </div>
    """
  end

  attr :incident, HeadsUp.Incidents.Incident, required: true
  def incident_card(assigns) do
    ~H"""
    <.link navigate={~p"/incidents/#{@incident}"}>
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
