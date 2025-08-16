defmodule HeadsUpWeb.TipsHTML do
  use HeadsUpWeb, :html

  embed_templates "tips_html/*"

  def show(assigns) do
    ~H"""
    <div class="tip">
      <h1>Tip {@tip.id}</h1>

      <p>{@tip.text}</p>
      <a href="/tips">Back to Tips</a>
    </div>
    """
  end
end
