```elixir
defmodule MyApp.JobexAdapter do
  @behaviour Jobex.Adapter

  @impl true
  def enqueue(module, arguments, [queue: _queue] = options) do
    options_map = Enum.into(options, %{})

    %Verk.Job{options_map | class: module, args: arguments}
    |> Verk.enqueue()
  end


  @impl true
  def enqueue_at(module, arguments, time, [queue: _queue] = options) do
    options_map = Enum.into(options, %{})

    %Verk.Job{options_map | class: module, args: arguments}
    |> Verk.schedule(time)
  end

  @impl true
  def enqueue_in(module, arguments, offset, [queue: _queue] = options) do
    options_map = Enum.into(options, %{})
    time = Timex.shift(Timex.now, seconds: offset)

    %Verk.Job{options_map | class: module, args: arguments}
    |> Verk.schedule(time)
  end
end
```
