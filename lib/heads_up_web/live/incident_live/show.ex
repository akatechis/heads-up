defmodule HeadsUpWeb.IncidentLive.Show do
  use HeadsUpWeb, :live_view

  alias HeadsUp.Incidents
  import HeadsUpWeb.CustomComponents

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    incident = Incidents.get_incident(id)
    socket =
      socket
      |> assign(:page_title, "#{incident.name} Incident Details")
      |> assign(:incident, incident)
      |> assign(:urgent_incidents , Incidents.urgent_incidents(incident))

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="incident-show">
      <div class="incident">
        <img src={@incident.image_path} />
        <section>
          <.badge text={@incident.status} />
          <header>
            <h2>{@incident.name}</h2>
            <div class="priority">
              {@incident.priority}
            </div>
          </header>
          <div class="description">
            {@incident.description}
          </div>
        </section>
      </div>
      <div class="activity">
        <div class="left"></div>
        <div class="right">
          <.urgent_incidents incidents={@urgent_incidents} />
        </div>
      </div>
    </div>
    """
  end

  def urgent_incidents(assigns) do
    ~H"""
    <section>
      <h4>Urgent Incidents</h4>
      <ul>
        <.incident_card :for={incident <- @incidents} incident={incident} />
      </ul>
    </section>
    """
  end

  def incident_card(assigns) do
    ~H"""
    <li class="my-2 align-left">
      <.link navigate={~p"/incidents/#{@incident}"}>
        <img src={@incident.image_path} class="inline-block w-1/4" />
        {@incident.name}
      </.link>
    </li>
    """
  end
end
