defmodule Tsex.Pro do
  @url "http://api.tushare.pro"
  @timeout 10

  # @doc query
  def query(api_name, params, fields \\ "", timeout \\ @timeout) do
    p =
      %{
        "api_name" => api_name,
        "fields" => fields,
        "params" => params,
        "token" => token()
      }
      |> Jason.encode!()

    HTTPoison.post(@url, p, [], timeout: timeout)
    |> response()
  end

  defp token(), do: Application.get_env(:tsex, :token, nil)

  defp response({:ok, %HTTPoison.Response{status_code: 200, body: body}}),
    do: body |> Jason.decode()

  defp response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end

  def vaild!({:ok, body}) do
    case body do
      %{"code" => 0} ->
        body

      _ ->
        raise(body["msg"])
    end
  end

  def vaild!({:error, error}), do: raise(error)
end
