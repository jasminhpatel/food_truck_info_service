defmodule FoodTruckInfoService.RequestUtils do
  def validate(params) do
    schema = %{
      "food_type" => [:string, :not_required],
      "latitude" => [:string, :required, &validate_latitude/1],
      "longitude" => [:string, :required, &validate_longitude/1],
      "radius" => [:string, :not_required, &validate_radius/1],
      "limit" => [:string, :not_required, &validate_limit/1]
    }

    Skooma.valid?(params, schema)
  end

  def fetch_params(params, keys) do
    required_params = Map.take(params, keys)

    map_with_atom_key =
      Map.new(Enum.map(required_params, fn {k, v} -> {String.to_atom(k), v} end))

    {:ok, map_with_atom_key}
  end

  defp validate_latitude(latitude) do
    latitude_regex = ~r/^(-?[1-8]?\d(?:\.\d{1,})?|90(?:\.0{1,6})?)$/
    Regex.match?(latitude_regex, latitude)
  end

  defp validate_radius(radius) do
    case Integer.parse(radius) do
      :error -> {:error, ["invalid radius value. #{radius}"]}
      _ -> :ok
    end
  end

  defp validate_limit(limit) do
    case Integer.parse(limit) do
      :error -> {:error, ["invalid limit value. #{limit}"]}
      _ -> :ok
    end
  end

  defp validate_longitude(longitude) do
    longitude_regex = ~r/^(-?(?:1[0-7]|[1-9])?\d(?:\.\d{1,})?|180(?:\.0{1,6})?)$/
    Regex.match?(longitude_regex, longitude)
  end
end
