defmodule FoodTruckInfoServiceWeb.FoodTruckView do
  use FoodTruckInfoServiceWeb, :view
  alias FoodTruckInfoServiceWeb.FoodTruckView
  alias FoodTruckInfoService.Schema.FoodTruckInfo

  def render("index.json", %{food_trucks: food_trucks}) do
    %{data: render_many(food_trucks, FoodTruckView, "food_truck.json")}
  end

  def render("show.json", %{food_truck: food_truck}) do
    %{data: render_one(food_truck, FoodTruckView, "food_truck.json")}
  end

  def render("food_truck.json", %{food_truck: food_truck}) do
    %{
      facility_type: food_truck.facility_type,
      available_food_items: food_truck.food_items,
      direction_link: food_truck.direction,
      address: food_truck.address,
      schedule: food_truck.schedule,
      business_hours: food_truck.days_hours
    }
  end
end
