defmodule HeadsUpWeb.IncidentLive.Index do
  use HeadsUpWeb, :live_view
  alias HeadsUp.Incidents
  import HeadsUpWeb.CustomComponents

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    socket = socket
      |> assign(page_title: "Incidents")
      |> stream(:incidents, Incidents.filter_incidents(params), reset: true)
      |> assign(:form, to_form(params))

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Incidents</h1>

    <div class="incident-index">
      <.incident_filters form={@form} />
      <div class="incidents" id="incidents" phx-update="stream">
        <div id="empty" class="no-results only:block hidden">
          No raffles found. Try changing your filters.
        </div>
        <.incident_card :for={{dom_id, incident} <- @streams.incidents} incident={incident} id={dom_id} />
      </div>
    </div>
    """
  end

  def incident_filters(assigns) do
    ~H"""
    <.form for={@form} id="filter-form" phx-change="filter" phx-submit="filter">
      <.input field={@form[:q]} type="text" placeholder="Search..." autocomplete="off" phx-debounce="500" />
      <.input field={@form[:status]} type="select" prompt="Status" options={Ecto.Enum.values(Incidents.Incident, :status)} />
      <.input field={@form[:sort_by]} type="select" prompt="Sort by" options={[
        "Name": "name_asc",
        "Priority (high to low)": "priority_desc",
        "Priority (low to high)": "priority_asc"
      ]} />
      <.link patch={~p"/incidents"}>Reset</.link>
    </.form>
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

  def handle_event("filter", params, socket) do
    query_params = params
      |> Map.take(~w(q status sort_by))
      |> Map.reject(fn {_k, v} -> v in [nil, ""] end)

    socket = push_patch(socket, to: ~p"/incidents?#{query_params}")

    {:noreply, socket}
  end
end
