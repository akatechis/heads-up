defmodule HeadsUpWeb.PageControllerTest do
  use HeadsUpWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    resp = html_response(conn, 200)
    assert resp =~ "Lost Dog"
    assert resp =~ "Flat Tire"
    assert resp =~ "Bear In The Trash"
  end
end
