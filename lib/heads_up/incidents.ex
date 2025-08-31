defmodule HeadsUp.Incidents do
  require Ecto.Query
  alias HeadsUp.Incidents.Incident
  alias HeadsUp.Repo
  import Ecto.Query

  def list_incidents do
    Repo.all(Incident)
  end

  def get_incident(id) do
    Repo.get(Incident, id)
  end

  def urgent_incidents() do
    query = Incident |> where([i], i.priority >= 3 and i.status != :resolved) |> order_by(:name) |> limit(3)
    Repo.all(query)
  end
end
