defmodule HeadsUpWeb.AdminIncidentLive.Index do
  use HeadsUpWeb, :live_view
  alias HeadsUp.Admin
  import HeadsUpWeb.CustomComponents

  def mount(_params, _session, socket) do
    socket = socket
      |> assign(page_title: "Incidents")
      |> stream(:incidents, Admin.list_incidents(), reset: true)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.header>
      {@page_title}
    </.header>
    <div class="admin-index">
      <.table id="incidents-table" rows={@streams.incidents}>
        <:col label="Name" :let={{_dom_id, incident}}>
          <.link navigate={~p"/incidents/#{incident}"}>
            {incident.name}
          </.link>
        </:col>
        <:col label="Status" :let={{_dom_id, incident}}>
          <.badge text={incident.status} />
        </:col>
        <:col label="Priority" :let={{_dom_id, incident}}>
          <p>{incident.priority}</p>
        </:col>
      </.table>
    </div>
    """
  end
end
