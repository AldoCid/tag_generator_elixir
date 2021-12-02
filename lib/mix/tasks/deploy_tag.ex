defmodule Mix.Tasks.Deploy do
  @moduledoc """
   Generates tag for git repository when user requests `mix deploy`. Accepts arguments

   Examples:\n
    `mix deploy dev`\n
    `mix deploy stage`\n
    `mix deploy prod`

  """

  alias DeployTagHelper
  use Mix.Task

  @impl Mix.Task
  def run(args) do
    case DeployTagHelper.deploy_new_tag(List.first(args)) do
      {:ok, _result} -> IO.puts("Success!")
      {:error, error} -> IO.warn(error)
    end
  end
end
