defmodule FoodTruckInfoServiceWeb.PageController do
  use FoodTruckInfoServiceWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
