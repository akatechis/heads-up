defmodule HeadsUpWeb.AdminIncidentLive.Form do
  use HeadsUpWeb, :live_view
  import HeadsUpWeb.CoreComponents
  alias HeadsUp.Admin
  alias HeadsUp.Incidents.Incident

  def mount(_params, _session, socket) do
    changeset = Admin.change_incident(%Incident{})

    socket =
      socket
      |> assign(page_title: "New Incident")
      |> assign(:form, to_form(changeset))

    {:ok, socket}
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
    socket = case Admin.create_incident(incident_params) do
      {:ok, _incident} ->
        socket
        |> put_flash(:info, "Incident created successfully")
        |> push_navigate(to: ~p"/admin/incidents")

      {:error, changeset} ->
        socket |> assign(:form, to_form(changeset))
    end
    {:noreply, socket}
  end

  def handle_event("validate", %{"incident" => incident_params}, socket) do
    changeset = Admin.change_incident(%Incident{}, incident_params)
    socket = socket |> assign(:form, to_form(changeset, action: :validate))
    {:noreply, socket}
  end
end
