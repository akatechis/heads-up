defmodule HeadsUpWeb.IncidentLive.Show do
  use HeadsUpWeb, :live_view

  import HeadsUpWeb.CustomComponents
  alias HeadsUp.Incidents

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    incident = Incidents.get_incident(id)

    socket =
      socket
      |> assign(:page_title, "#{incident.name} Incident Details")
      |> assign(:incident, incident)
      |> assign_async(:urgent_incidents, fn ->
        {:ok, %{urgent_incidents: Incidents.urgent_incidents()}}
      end)

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

      <.async_result :let={results} assign={@incidents}>
        <:loading>
          <div class="loading">
            <div class="spinner" />
          </div>
        </:loading>

        <:failed :let={{:exit, reason}}>
          <div class="failed">
            {reason}
          </div>
        </:failed>

        <ul>
          <.incident_list_item :for={incident <- results} incident={incident} />
        </ul>
      </.async_result>
    </section>
    """
  end

  attr :incident, HeadsUp.Incidents.Incident, required: true

  def incident_list_item(assigns) do
    ~H"""
    <li class="my-2">
      <.link patch={~p"/incidents/#{@incident}"} class="flex items-center gap-2 p-2 hover:bg-gray-100">
        <img src={@incident.image_path} class="inline-block w-1/4" /> {@incident.name}
      </.link>
    </li>
    """
  end
end
