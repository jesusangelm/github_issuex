defmodule Issues.GithubIssues do
  require Logger
  @user_agent [{"User-agent", "Necris 6.6.6"}]

  def fetch(user, project) do
    Logger.info("Obteniendo el proyecto #{project} de #{user}")

    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def issues_url(user, project) do
    "https://api.github.com/repos/#{user}/#{project}/issues"
  end

  def handle_response({_, %{status_code: status_code, body: body}}) do
    Logger.info("Respuesta obtenida: codigo de estado: #{status_code}")
    Logger.debug(fn -> inspect(body) end)
    {
      status_code |> check_for_error,
      body        |> Poison.Parser.parse!(%{})
    }
  end
  
  defp check_for_error(200), do: :ok
  defp check_for_error(_), do: :error

end
