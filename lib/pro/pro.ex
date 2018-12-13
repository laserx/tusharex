defmodule Tusharex.Pro do
  @url "http://api.tushare.pro"
  @timeout 10
  @freq 150

  @doc """
  api request
  """
  def query(api_name, params \\ %{}, fields \\ "", timeout \\ @timeout) do
    if Tusharex.Counter.value() >= @freq do
      {:freq, "api frequency more than " <> to_string(@freq)}
    else
      p = serialize(api_name, params, fields)

      HTTPoison.post(@url, p, [], timeout: timeout)
      |> response()
    end
  end

  @doc false
  defp serialize(api_name, params, fields) do
    %{
      "api_name" => api_name,
      "fields" => fields,
      "params" => params,
      "token" => token()
    }
    |> Jason.encode!()
  end

  @doc false
  defp token(), do: Application.get_env(:tusharex, :token, nil)

  @doc false
  defp response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    Tusharex.Counter.called()

    body |> Jason.decode()
  end

  @doc false
  defp response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end

  @doc """
  response check
  """
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
