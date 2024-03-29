ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(RentCars.Repo, :manual)

defmodule RentCars.Helper do
  @default_options [deep: true]

  def transform_response(map) do
    if is_list(map) do
      for item <- map, do: transform_response(item)
    else
      atomize_keys(map)
    end
  end

  defp atomize_keys(map, opts \\ [])

  defp atomize_keys(map, opts) do
    opts = Keyword.merge(@default_options, opts)

    Enum.reduce(map, %{}, fn {k, v}, m ->
      v =
        case is_map(v) && opts[:deep] do
          true -> atomize_keys(v, opts)
          false -> v
        end

      map_atom_put(m, k, v)
    end)
  end

  defp map_atom_put(m, k, v) do
    if is_binary(k) do
      Map.put(m, String.to_atom(k), v)
    else
      Map.put(m, k, v)
    end
  end
end
