defmodule MavuBeUserUi do
  @moduledoc false

  def conf(local_conf \\ %{}) do
    %{accounts_module: MyApp.BeAccounts, be_user_module: MyApp.BeAccounts.BeUser}
    |> Map.merge(local_conf)
  end
end
