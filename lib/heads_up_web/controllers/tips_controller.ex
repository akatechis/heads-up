defmodule HeadsUpWeb.TipsController do
  use HeadsUpWeb, :controller

  alias HeadsUp.Tips

  def index(conn, _params) do
    tips = Tips.list_tips()
    emojis = ~w(💚 💜 💙) |> Enum.random() |> String.duplicate(5)

    render(conn, :index, tips: tips, emojis: emojis)
  end
end
