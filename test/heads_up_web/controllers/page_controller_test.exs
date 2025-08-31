defmodule HeadsUpWeb.PageControllerTest do
  use HeadsUpWeb.ConnCase
  import Phoenix.LiveViewTest

  describe "Incidents List" do
    test "GET /", %{conn: conn} do
      HeadsUp.SeedData.seed_incidents()

      {:ok, _view, html} = live(conn, ~p"/")

      assert html =~ "Lost Dog"
      assert html =~ "Flat Tire"
      assert html =~ "Bear In The Trash"
    end

  end
end
