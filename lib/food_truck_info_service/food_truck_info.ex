defmodule FoodTruckInfoService.FoodTruckInfo do
  import Geocalc

  defstruct [
    :address,
    :facility_type,
    :location,
    :food_items,
    :schedule,
    :direction,
    :days_hours
  ]

  defp data_stream() do
    NimbleCSV.define(MyParser, separator: ",", escape: "\"")

    file_path =
      Application.get_env(:food_truck_info_service, :csv_file_path, "./priv/data/food_truck.csv")

    file_path
    |> File.stream!()
    |> MyParser.parse_stream(skip_headers: false)
    |> Stream.transform(nil, fn
      headers, nil -> {[], headers}
      row, headers -> {[Enum.zip(headers, row) |> Map.new()], headers}
    end)
  end

  def get_data(options) do
    data =
      data_stream()
      |> filter_approved_food_truck()
      |> filter_by_food_item(options[:food_type])
      |> Enum.map(fn item -> convert_to_struct(item) end)
      |> filter_and_sort_near_by(options)

    case options[:limit] do
      nil -> {:ok, data}
      _ -> {:ok, Enum.take(data, String.to_integer(options.limit))}
    end
  end

  defp filter_approved_food_truck(list) do
    Enum.filter(list, fn list -> list["Status"] == "APPROVED" end)
  end

  defp filter_and_sort_near_by(list, %{latitude: 0, longitude: 0}), do: list
  defp filter_and_sort_near_by(list, %{sort_by_distance: false}), do: list

  defp filter_and_sort_near_by(list, %{latitude: latitude, longitude: longitude} = params) do
    radius = if params["radius"] == nil, do: 5, else: String.to_integer(params["radius"])

    list
    |> Enum.filter(fn food_truck ->
      get_distance(latitude, longitude, food_truck.location) <= radius * 1609
    end)
    |> Enum.sort_by(fn food_truck -> get_distance(latitude, longitude, food_truck.location) end)
  end

  defp get_distance(latitude, longitude, food_truck_location) do
    distance_between(
      %{latitude: String.to_float(latitude), longitude: String.to_float(longitude)},
      food_truck_location
    )
  end

  defp filter_by_food_item(list, nil), do: list

  defp filter_by_food_item(list, type) do
    Enum.filter(list, fn item ->
      item["FoodItems"]
      |> String.downcase()
      |> String.contains?(String.downcase(type)) || String.trim(type) == ""
    end)
  end

  defp convert_to_struct(%{} = item) do
    latitude = if item["Latitude"] == "0", do: 0.0, else: String.to_float(item["Latitude"])
    longitude = if item["Longitude"] == "0", do: 0.0, else: String.to_float(item["Longitude"])

    %__MODULE__{
      address: item["LocationDescription"] || item["Address"],
      facility_type: item["FacilityType"],
      location: %{
        latitude: latitude,
        longitude: longitude
      },
      food_items: String.split(item["FoodItems"], ":", trim: true) |> Enum.map(&String.trim/1),
      schedule: item["Schedule"],
      direction: get_place_direction(item["Latitude"], item["Longitude"]),
      days_hours: item["dayshours"]
    }
  end

  defp get_place_direction(latitude, longitude),
    do: "https://www.google.com/maps/place/#{latitude},#{longitude}"
end
