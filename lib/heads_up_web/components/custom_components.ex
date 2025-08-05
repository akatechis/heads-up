defmodule HeadsUpWeb.CustomComponents do
  use HeadsUpWeb, :html

  attr :text, :atom, required: true, values: [:pending, :resolved, :canceled]
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(id style)

  def badge(assigns) do
    ~H"""
    <span class={[
      "rounded-md px-2 py-1 text-xs font-medium uppercase inline-block border",
      @text == :resolved && "text-lime-600 border-lime-600",
      @text == :pending && "text-amber-600 border-amber-600",
      @text == :canceled && "text-gray-600 border-gray-600",
      @class
    ]}>
      {@text}
    </span>
    """
  end

  slot :inner_block, required: true
  slot :tagline

  def headline(assigns) do
    assigns = assign_new(assigns, :vibe, fn -> ~w(😎 🤩 🥳) |> Enum.random() end)

    ~H"""
    <div class="headline">
      <h1>
        {render_slot(@inner_block)}
      </h1>
      
      <div :for={tagline <- @tagline} class="tagline">
        {render_slot(tagline, @vibe)}
      </div>
    </div>
    """
  end
end
