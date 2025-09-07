defmodule HeadsUpWeb.AdminIncidentLive.Form do
  use HeadsUpWeb, :live_view
  import HeadsUpWeb.CoreComponents
  alias HeadsUp.Admin
  alias HeadsUp.Incidents.Incident

  def mount(params, _session, socket) do
    {:ok, socket |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    incident = %Incident{}
    changeset = Admin.change_incident(incident)

    socket
      |> assign(page_title: "New Incident")
      |> assign(incident: incident)
      |> assign(:form, to_form(changeset))
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    incident = Admin.get_incident!(id)
    changeset = Admin.change_incident(incident)

    socket
      |> assign(page_title: "New Incident")
      |> assign(incident: incident)
      |> assign(:form, to_form(changeset))
  end

  def render(assigns) do
    ~H"""
    <.header>
      {@page_title}
    </.header>

    <.simple_form for={@form} id="incident-form" phx-submit="save" phx-change="validate">
      <.input field={@form[:name]} type="text" label="Name" />
      <.input field={@form[:priority]} type="number" label="Priority" />
      <.input
        field={@form[:status]}
        type="select"
        label="Status"
        prompt="Select a Status"
        options={[:pending, :resolved, :canceled]}
      />
      <.input field={@form[:description]} type="textarea" label="Description" phx-debounce="blur" />
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
    {:noreply, socket |> save_incident(socket.assigns.live_action, incident_params)}
  end

  def handle_event("validate", %{"incident" => incident_params}, socket) do
    changeset = Admin.change_incident(socket.assigns.incident, incident_params)
    socket = socket |> assign(:form, to_form(changeset, action: :validate))
    {:noreply, socket}
  end

  defp save_incident(socket, :new, incident_params) do
    case Admin.create_incident(incident_params) do
      {:ok, _incident} ->
        socket
        |> put_flash(:info, "Incident created successfully!")
        |> push_navigate(to: ~p"/admin/incidents")

      {:error, changeset} ->
        socket |> assign(:form, to_form(changeset))
    end
  end

  defp save_incident(socket, :edit, incident_params) do
    case Admin.update_incident(socket.assigns.incident, incident_params) do
      {:ok, _incident} ->
        socket
        |> put_flash(:info, "Incident updated successfully!")
        |> push_navigate(to: ~p"/admin/incidents")

      {:error, changeset} ->
        socket |> assign(:form, to_form(changeset))
    end
  end
end
