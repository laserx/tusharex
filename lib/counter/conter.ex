defmodule Tusharex.Counter do
  use Agent

  @beats 60

  defstruct stamp: Time.utc_now(), times: 0

  def start_link do
    Agent.start_link(fn -> %__MODULE__{} end, name: __MODULE__)
  end

  def called do
    time_compare()
    |> recycle()

    Agent.update(__MODULE__, &update/1)
  end

  def value do
    time_compare()
    |> recycle()

    %{times: times} = get()

    times
  end

  defp get, do: Agent.get(__MODULE__, & &1)

  defp time_compare do
    %{stamp: stamp} = get()
    if Time.diff(Time.utc_now(), stamp) > @beats, do: true, else: false
  end

  defp recycle(true),
    do: Agent.update(__MODULE__, &struct(&1, times: 0, stamp: Time.utc_now()))

  defp recycle(false), do: nil

  defp update(s) do
    s |> struct(times: s.times + 1)
  end
end
