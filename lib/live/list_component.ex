defmodule MavuBeUserUi.Live.ListComponent do
  @moduledoc false
  use MavuBeUserUiWeb, :live_component

  alias MyApp.Repo
  require Ecto.Query

  import MavuBeUserUi, only: [get_conf_val: 2]

  def accounts_module(assigns),
    do: get_conf_val(assigns[:context][:be_user_ui_conf], :accounts_module)

  @impl true
  def update(%{id: id, context: context} = assigns, socket) do
    items_query = accounts_module(assigns).get_query(assigns, context)
    # first load
    {:ok,
     socket
     |> assign(assigns)
     |> assign(
       items_query: items_query,
       items_filtered:
         MavuList.process_list(
           items_query,
           id,
           listconf(),
           socket.assigns[:items_filtered][:tweaks]
         )
     )}
  end

  def listconf() do
    %{
      columns: [
        %{name: :id, label: "ID"},
        %{name: :email, label: "email"},
        %{name: :is_active, label: "is_active"},
        %{name: :inserted_at, label: "created", type: :datetime}
      ],
      repo: MyApp.Repo,
      filter: &listfilter/3
    }
  end

  def listfilter(source, _conf, tweaks) do
    keyword = tweaks[:keyword]

    if MavuUtils.present?(keyword) do
      kwlike = "%#{keyword}%"

      source
      |> Ecto.Query.where(
        [o],
        ilike(o.email, ^kwlike)
      )
    else
      source
    end
  end

  def handle_event("add_item", _msg, socket) do
    {:noreply,
     socket
     |> push_patch(to: socket.assigns.base_path.(%{"rec" => "new"}))}
  end

  def handle_event("edit_item", %{"id" => rec_id}, socket) do
    {:noreply,
     socket
     |> push_patch(to: socket.assigns.base_path.(%{"rec" => rec_id}))}
  end

  def handle_event("delete_item", %{"id" => rec_id}, socket) do
    accounts_module(socket.assigns).get_user!(
      !MavuUtils.to_int(rec_id)
      |> Repo.delete()
    )

    {:noreply,
     socket
     |> push_redirect(to: socket.assigns.base_path.(%{}))}
  end

  @impl true
  def handle_event("list." <> event, msg, socket) do
    {:noreply,
     assign(socket,
       items_filtered:
         MavuList.handle_event(
           event,
           msg,
           socket.assigns.items_query,
           socket.assigns.items_filtered
         )
     )}
  end
end
