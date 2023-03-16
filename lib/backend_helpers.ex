defmodule MavuBeUserUi.BackendHelpers do
  use Phoenix.HTML

  def tw_class(class_name, opts \\ [])

  def tw_class(:narrow_container, _), do: "max-w-md  mx-auto"
  def tw_class(_, _), do: ""

  def remove_attributes(attributes, tags_to_remove) when is_list(tags_to_remove) do
    attributes
    |> Enum.filter(fn {key, _val} ->
      key not in tags_to_remove
    end)
  end

  defdelegate if_empty(val, default_val), to: MavuUtils
  defdelegate if_nil(val, default_val), to: MavuUtils
  defdelegate present?(term), to: MavuUtils
  defdelegate empty?(term), to: MavuUtils
  defdelegate true?(term), to: MavuUtils
  defdelegate false?(term), to: MavuUtils
end
