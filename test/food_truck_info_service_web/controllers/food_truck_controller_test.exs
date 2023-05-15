defmodule FoodTruckInfoServiceWeb.FoodTruckControllerTest do
  use FoodTruckInfoServiceWeb.ConnCase

  alias FoodTruckInfoService.FoodTruckInfo
  alias FoodTruckInfoService.RequestUtils

  @key_list ["food_type", "latitude", "longitude", "radius", "limit"]

  @valid_request %{
    "latitude" => "37.799375",
    "longitude" => "-122.399972",
    "radius" => "1",
    "food_type" => "taco"
  }

  @missing_param_req %{
    "latitude" => "37.799375",
    "radius" => "1",
    "food_type" => "taco"
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "Food Truck Search" do
    test "list food_trucks", %{conn: conn} do
      conn = get(conn, Routes.food_truck_path(conn, :index, @valid_request))
      body = json_response(conn, 200)
      query_food = @valid_request["food_type"]
      {:ok, params} = RequestUtils.fetch_params(@valid_request, @key_list)
      {:ok, records} = FoodTruckInfo.get_data(params)

      assert length(body["data"]) == length(records)
    end

    test "Response list food_trucks with specific food type", %{conn: conn} do
      conn = get(conn, Routes.food_truck_path(conn, :index, @valid_request))
      body = json_response(conn, 200)
      query_food = @valid_request["food_type"]
      {:ok, params} = RequestUtils.fetch_params(@valid_request, @key_list)
      {:ok, records} = FoodTruckInfo.get_data(params)

      food_list = hd(body["data"])["available_food_items"]

      assert Enum.any?(food_list, &String.contains?(&1, query_food))
    end

    test "Response with limit of records", %{conn: conn} do
      request_param = Map.put(@valid_request, "limit", "1")

      conn = get(conn, Routes.food_truck_path(conn, :index, request_param))
      body = json_response(conn, 200)

      {:ok, params} = RequestUtils.fetch_params(request_param, @key_list)
      {:ok, records} = FoodTruckInfo.get_data(params)

      assert length(body["data"]) == length(records)
    end

    test "Response with 400 when required parameter missing", %{conn: conn} do
      conn = get(conn, Routes.food_truck_path(conn, :index, @missing_param_req))
      assert json_response(conn, 400)
    end
  end
end
