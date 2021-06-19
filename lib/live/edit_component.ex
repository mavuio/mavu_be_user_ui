defmodule MavuBeUserUi.Live.EditComponent do
  @moduledoc false
  use MavuBeUserUiWeb, :live_component

  # alias MyApp.BeAccounts
  alias MyApp.BeAccounts.BeUser
  alias MyApp.Repo

  def accounts_module(assigns), do: assigns[:context][:be_user_ui_conf][:accounts_module]
  def be_user_module(assigns), do: assigns[:context][:be_user_ui_conf][:be_user_module]

  @impl true
  def update(assigns, socket) do
    rec =
      case assigns.rec_id do
        "new" -> generate_default_rec(assigns)
        rec_id -> accounts_module(assigns).get_be_user!(MavuUtils.to_int(rec_id))
      end

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(
        rec: rec,
        changeset: get_changeset(rec, %{}, assigns)
      )
    }
  end

  @impl true
  def handle_event("validate", %{"fdata" => incoming_data} = _msg, socket) do
    changeset =
      socket.assigns.rec
      |> get_changeset(incoming_data, socket.assigns)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"fdata" => incoming_data}, %{assigns: %{rec_id: "new"}} = socket) do
    socket.assigns.rec
    |> get_changeset(incoming_data, socket.assigns)
    |> Repo.insert()
    |> case do
      {:ok, _reservation} ->
        {:noreply,
         socket
         |> put_flash(:info, "BeUserlist created successfully")
         |> push_patch(to: return_path(socket))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def handle_event("save", %{"fdata" => incoming_data}, socket) do
    socket.assigns.rec
    |> get_changeset(incoming_data, socket.assigns)
    |> Repo.update()
    |> case do
      {:ok, _reservation} ->
        {:noreply,
         socket
         |> put_flash(:info, "BeUserlist updated successfully")
         |> push_patch(to: return_path(socket))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def handle_event("modal_hide", _, socket) do
    {:noreply,
     socket
     |> push_patch(to: return_path(socket))}
  end

  def get_changeset(model, params, assigns) when is_map(assigns) do
    be_user_module(assigns).edit_changeset(model, params)
  end

  def return_path(socket) do
    socket.assigns.base_path.(%{})
  end

  def generate_default_rec(assigns) when is_map(assigns) do
    struct(
      be_user_module(assigns),
      %{
        email: "",
        hashed_password: Ecto.UUID.generate()
      }
    )
  end
end
