defmodule Jobex do
  @moduledoc """
  Behaviour module for implementing an abstraction layer for enqueuing a job with any background job system.


      defmodule ExampleJob do
        use Jobex

        def perform(arg1, arg2) do
        end

        def perform_later(arg1, arg2) do
          enqueue([arg1, arg2])
        end
      end

    # How to use
  """

  @callback enqueue(list()) :: any()

  @callback enqueue_at(list(), any()) :: any()

  @callback enqueue_in(list(), any()) :: any()

  defmacro __using__(options \\ []) do
    quote location: :keep do
      @behaviour unquote(__MODULE__)
      @options unquote(__MODULE__).__enforce_options__(unquote(options), __MODULE__)
      @adapter unquote(__MODULE__).__get_adapter__()

      unquote(__MODULE__).__enqueue__()
      unquote(__MODULE__).__enqueue_at__()
      unquote(__MODULE__).__enqueue_in__()
    end
  end

  defmacro __enqueue__ do
    quote do
      def enqueue(args \\ [])

      def enqueue(args) when not is_list(args) do
        enqueue([args])
      end

      def enqueue(args) do
        @adapter.enqueue(
          __MODULE__,
          args,
          @options
        )
      end
    end
  end

  defmacro __enqueue_at__ do
    quote do
      def enqueue_at(args \\ [], time)

      def enqueue_at(args, time) when not is_list(args) do
        enqueue_at([args], time)
      end

      def enqueue_at(args, time) do
        @adapter.enqueue_at(
          __MODULE__,
          args,
          time,
          @options
        )
      end
    end
  end

  defmacro __enqueue_in__ do
    quote do
      def enqueue_in(args \\ [], offset)

      def enqueue_in(args, offset) when not is_list(args) do
        enqueue_in([args], offset)
      end

      def enqueue_in(args, offset) do
        @adapter.enqueue_in(
          __MODULE__,
          args,
          offset,
          @options
        )
      end
    end
  end

  def __get_adapter__ do
    case Application.get_env(:jobex, :adapter) do
      nil ->
        raise """
        Please specify adapter in your config file: "config :jobex, :adapter, MyApp.Adapter"
        """

      adapter ->
        adapter
    end
  end

  def __enforce_options__(options, module) do
    Application.get_env(:jobex, :enforced_options, [])
    |> Enum.each(fn option ->
      case Keyword.fetch(options, option) do
        :error ->
          raise """
          Enforced Jobex option `:#{option}` is missing for #{module}.
          """

        {:ok, _} ->
          nil
      end
    end)

    options
  end
end
