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
      <:actions>
        <.link class="button primary" phx-link="redirect" navigate={~p"/admin/incidents/new"}>
          New Incident
        </.link>
      </:actions>
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
        <:action :let={{_dom_id, incident}}>
          <.link phx-link="redirect" navigate={~p"/admin/incidents/#{incident}/edit"}>
            <.icon name="hero-pencil" class="h-4 w-4" /> Edit
          </.link>
        </:action>
        <:action :let={{_dom_id, incident}}>
          <.link phx-click="delete" phx-value-id={incident.id} data-confirm="Are you sure?">
            <.icon name="hero-trash" class="h-4 w-4" /> Delete
          </.link>
        </:action>
      </.table>
    </div>
    """
  end

  def handle_event("delete", %{"id" => id}, socket) do
    incident = Admin.get_incident!(id)
    {:ok, _} = Admin.delete_incident(incident)

    {:noreply, socket |> stream_delete(:incidents, incident) |> put_flash(:info, "Incident deleted successfully")}
  end
end
