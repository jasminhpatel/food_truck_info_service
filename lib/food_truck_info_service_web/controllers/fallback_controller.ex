defmodule FoodTruckInfoServiceWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use FoodTruckInfoServiceWeb, :controller

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(FoodTruckInfoServiceWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, [msg]}) do
    conn
    |> put_status(:bad_request)
    |> put_view(FoodTruckInfoServiceWeb.ErrorView)
    |> render("400.json", %{message: msg})
  end

  def call(conn, msg) do
    conn
    |> put_status(500)
    |> put_view(FoodTruckInfoServiceWeb.ErrorView)
    |> render("500.json", %{message: "Internal Server Error. We are looking into it."})
  end
end
