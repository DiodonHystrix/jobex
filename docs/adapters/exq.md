```elixir
defmodule MyApp.JobexAdapter do
  @behaviour Jobex.Adapter

  @impl true
  def enqueue(module, arguments, [queue: queue] = options) do
    Exq.enqueue(Exq, queue, module, arguments, options)
  end


  @impl true
  def enqueue_at(module, arguments, time, [queue: queue] = options) do
    Exq.enqueue_at(Exq, queue, time, module, arguments, options)
  end

  @impl true
  def enqueue_in(perform_in, module, arguments, offset, [queue: _queue] = options) do
    Exq.enqueue_in(Exq, queue, offset, module, arguments, options)
  end
end
```
