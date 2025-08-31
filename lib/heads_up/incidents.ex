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

  def filter_incidents(filter) do
    Incident
    |> with_status(filter["status"])
    |> search_by(filter["q"])
    |> sort(filter["sort_by"])
    |> Repo.all()
  end

  defp with_status(query, status) when status in ~w(pending resolved canceled) do
    where(query, status: ^status)
  end
  defp with_status(query, _), do: query

  defp search_by(query, q) when is_binary(q) and byte_size(q) > 0 do
    where(query, [i], ilike(i.name, ^"%#{q}%"))
  end
  defp search_by(query, _), do: query

  defp sort(query, "name_asc"), do: order_by(query, asc: :name)
  defp sort(query, "priority_asc"), do: order_by(query, asc: :priority)
  defp sort(query, "priority_desc"), do: order_by(query, desc: :priority)
  defp sort(query, _), do: order_by(query, :id)

  def urgent_incidents() do
    Incident
    |> where([i], i.priority >= 3 and i.status == :pending)
    |> order_by(:name)
    |> limit(3)
    |> Repo.all()
  end
end
