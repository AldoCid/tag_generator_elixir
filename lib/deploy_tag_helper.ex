defmodule DeployTagHelper do
  alias Tagger

  @repo %Git.Repository{path: "."}

  def deploy_new_tag(env) when env in ["dev", "rc"] do
    Tagger.fetch_repo(@repo)

    result =
      env
      |> Tagger.fetch_latest_tag(@repo)
      |> Tagger.increment_env_tag(env)
      |> Tagger.create_tag(@repo)
      |> Tagger.push_tag(@repo)

    {:ok, result}
  end

  def deploy_new_tag(_), do: {:error, :invalid_env_argument}
end
