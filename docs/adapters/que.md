```elixir
defmodule MyApp.JobexAdapter do
  @behaviour Jobex.Adapter

  @impl true
  def enqueue(module, [argument], options) do
    Que.add(module, argument)
  end

  @impl true
  def enqueue_at(_, _, _, _), do: nil

  @impl true
  def enqueue_in(_, _, _, _), do: nil
end
```
