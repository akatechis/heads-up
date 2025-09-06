defmodule HeadsUpWeb.AdminIncidentLive.Form do
  use HeadsUpWeb, :live_view
  import HeadsUpWeb.CoreComponents
  alias HeadsUp.Admin

  def mount(_params, _session, socket) do
    socket = socket
      |> assign(page_title: "New Incident")
      |> assign(:form, to_form(%{}, as: "incident"))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.header>
      {@page_title}
    </.header>
    <.simple_form for={@form} id="incident-form" phx-submit="save">
      <.input field={@form[:name]} type="text" label="Name" />
      <.input field={@form[:priority]} type="number" label="Priority" />
      <.input field={@form[:status]}
        type="select"
        label="Status"
        prompt="Select a Status"
        options={[:pending, :resolved, :canceled]}
      />
      <.input field={@form[:description]} type="textarea" label="Description" />
      <.input field={@form[:image_path]} label="Image path" placeholder="/images/placeholder.jpg" />
      <:actions>
        <.button phx-disable-with="Saving...">
          Save Incident
        </.button>
      </:actions>
    </.simple_form>
    <.back navigate={~p"/admin/incidents"}>
      Back to Incidents
    </.back>
    """
  end

  def handle_event("save", %{"incident" => incident_params}, socket) do
    _incident = Admin.create_incident(incident_params)

    socket = push_navigate(socket, to: ~p"/admin/incidents")

    {:noreply, socket}
  end
end
