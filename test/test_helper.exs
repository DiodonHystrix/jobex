defmodule TestAdapter do
  @behaviour Jobex.Adapter

  @impl true
  def enqueue(module, arguments, options) do
    %{module: module, arguments: arguments, options: options}
  end

  @impl true
  def enqueue_at(module, arguments, time, options) do
    %{module: module, arguments: arguments, time: time, options: options}
  end

  @impl true
  def enqueue_in(module, arguments, offset, options) do
    %{module: module, arguments: arguments, offset: offset, options: options}
  end
end

ExUnit.start()
