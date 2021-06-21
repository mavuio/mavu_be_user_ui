defmodule MavuBeUserUi do
  @moduledoc false

  def default_conf(local_conf \\ %{}) do
    %{
      accounts_module: MyApp.BeAccounts,
      be_user_module: MyApp.BeAccounts.BeUser
    }
    |> Map.merge(local_conf)
  end

  def get_conf_val(conf, key) when is_atom(key) do
    conf =
      if MavuUtils.empty?(conf) do
        default_conf()
      else
        conf
      end

    conf[key]
  end
end
