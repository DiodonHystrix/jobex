# Jobex WIP

[![Build Status](https://travis-ci.org/DiodonHystrix/jobex.svg?branch=master)](https://travis-ci.org/DiodonHystrix/jobex)
[![Coverage Status](https://coveralls.io/repos/github/DiodonHystrix/jobex/badge.svg?branch=master)](https://coveralls.io/github/DiodonHystrix/jobex?branch=master)

Jobex is an abstraction layer for enqueuing background jobs. Jobex allows to:
  
* Switch between background jobs providers with ease.  
This is done thanks to Adapter which contains enqueuing logic specific to used backgroung job system
* Ability to enqueue jobs with usage of types.  
Many background job systems want arguments to be passed as a list. Jobex instead allows you to create an additional function that will pass the arguments as a list inside Job module. This function can be then called from other modules just like you would call the original (in many cases `perform`) function.
```elixir 

* Easily test if a job was enqueued with using a proper Adapter.

## Installation

Add `jobex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:jobex, "~> 0.1.0"}
  ]
end
```

Run `mix deps.get` to install it.

## Getting started

### Adapter

First define an adapter that connects enqueueing jobs with your background job system.  
You can check existing examples:

- [Exq](docs/adapters/exq.md)
- [Verk](docs/adapters/verk.md)
- [Que](docs/adapters/que.md)
- [Rihanna](docs/adapters/rihanna.md)

Feel free to implement `Adapter` with `Jobex.Adapter behaviour` by yourself:

```elixir
defmodule MyApp.JobexAdapter do
  @behaviour Jobex.Adapter

  @impl true
  def enqueue(module, arguments, options) do
    # Enqueue a job with your background job package
  end

  @impl true
  def enqueue_at(module, arguments, time, options) do
    # Enqueue a job at specific time with your background job package
  end

  @impl true
  def enqueue_in(module, arguments, offset, options) do
      # Enqueue a job after specified offset with your background job package
  end
end
```

Add created adapter to `config/config.exs`:

```elixir
config :jobex, :adapter, MyApp.JobexAdapter
```

### Job's Module

```elixir
defmodule MyApp.MyJob do
  use Jobex, queue: :default

  @spec perform(any(), any()) :: any()
  def perform(arg1, arg2) do
    # body
  end

  # Define perform_later, perform_at, perform_in when needed

  @spec perform_later(any(), any()) :: any()
  def perform_later(arg1, arg2) do
    enqueue([arg1, arg2])
  end

  @spec perform_at(any(), any(), any()) :: any()
  def perform_at(arg1, arg2, time) do
    enqueue_at([arg1, arg2], time)
  end

  @spec perform_in(any(), any(), any()) :: any()
  def perform_in(arg1, arg2, offset) do
    enqueue_in([arg1, arg2], offset)
  end
end

```

Now you can enqueue the job like this:
```elixir
defmodule MyApp.SomeModule do
  def some_fn(arg1) do
    # some code here
    
    MyApp.MyJob.perform_later(arg1, arg2)
  end
end
```

## Enforced options

You can enforce options that are passed to `Jobex` like this:

```elixir
config :jobex,
  adapter: MyApp.JobexAdapter,
  enforced_options: [:queue]
```

```elixir
# this is gonna raise an error during compilation
defmodule ThisWillFail do
  use Jobex
end

# this is gonna work, because :queue is present
defmodule ThisWillWork do
  use Jobex, queue: :default
end
```

## How does it exactly work

By implementing `Jobex` behaviour, you can call enqueue/1
