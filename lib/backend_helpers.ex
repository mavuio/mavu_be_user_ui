defmodule MavuBeUserUi.BackendHelpers do
  use Phoenix.HTML

  def tw_class(class_name, opts \\ [])

  def tw_class(:narrow_container, _), do: "max-w-md  mx-auto"
  def tw_class(_, _), do: ""

  def remove_tag_params(html, tags_to_remove) when is_list(tags_to_remove) do
    {:safe,
     Phoenix.HTML.html_escape(html)
     |> Phoenix.HTML.safe_to_string()
     |> Floki.parse_fragment!()
     |> Floki.find_and_update(
       "input",
       fn
         {name, attributes, children} ->
           {name, remove_attributes(attributes, tags_to_remove), children}

         {name, attributes} ->
           {name, remove_attributes(attributes, tags_to_remove)}

         other ->
           other
       end
     )
     |> Floki.raw_html()}
  end

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
