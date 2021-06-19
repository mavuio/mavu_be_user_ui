defmodule MavuBeUserUi.Live.MavuList.LabelComponent do
  @moduledoc false
  use MavuBeUserUiWeb, :live_component

  @impl true
  def update(%{list: list, name: name} = _assigns, socket) do
    socket =
      socket
      |> assign(MavuList.generate_assigns_for_label_component(list, name))

    {:ok, socket}
  end
end
