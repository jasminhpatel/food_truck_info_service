defmodule FoodTruckInfoServiceWeb.FoodTruckController do
  use FoodTruckInfoServiceWeb, :controller

  alias FoodTruckInfoService.FoodTruckInfo
  alias FoodTruckInfoService.RequestUtils

  action_fallback(FoodTruckInfoServiceWeb.FallbackController)
  @key_list ["food_type", "latitude", "longitude", "radius", "limit"]

  def index(conn, params) do
    with :ok <- RequestUtils.validate(params),
         {:ok, params} <- RequestUtils.fetch_params(params, @key_list),
         {:ok, food_trucks} <- FoodTruckInfo.get_data(params) do
      render(conn, "index.json", food_trucks: food_trucks)
    end
  end
end
