```elixir
defmodule MyApp.JobexAdapter do
  @behaviour Jobex.Adapter

  @impl true
  def enqueue(module, arguments, _options) do
    Rihanna.enqueue(module, arguments)
  end


  @impl true
  def enqueue_at(module, arguments, time, [queue: queue] = options) do
    Rihanna.schedule(module, arguments, at: time)
  end

  @impl true
  def enqueue_in(perform_in, module, arguments, offset, [queue: _queue] = options) do
    Rihanna.schedule(module, arguments, in: :timer.seconds(offset))
  end
end
```
