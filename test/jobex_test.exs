defmodule JobexTest do
  use ExUnit.Case
  doctest Jobex

  defmodule TestWorker do
    use Jobex, queue: "default", max_retries: 10, foo: :bar
  end

  describe "enqueue/0" do
    test "without arguments" do
      assert(
        TestWorker.enqueue() == %{
          module: TestWorker,
          arguments: [],
          options: [queue: "default", max_retries: 10, foo: :bar]
        }
      )
    end
  end

  describe "enqueue/1" do
    test "with a list" do
      assert(
        TestWorker.enqueue(["b"]) == %{
          module: TestWorker,
          arguments: ["b"],
          options: [queue: "default", max_retries: 10, foo: :bar]
        }
      )
    end

    test "with not a list" do
      assert(
        TestWorker.enqueue("b") == %{
          module: TestWorker,
          arguments: ["b"],
          options: [queue: "default", max_retries: 10, foo: :bar]
        }
      )
    end
  end

  describe "enqueue_at/1" do
    test "without arguments and only with time" do
      assert(
        TestWorker.enqueue_at("time") == %{
          module: TestWorker,
          arguments: [],
          time: "time",
          options: [queue: "default", max_retries: 10, foo: :bar]
        }
      )
    end
  end

  describe "enqueue_at/2" do
    test "with a list" do
      assert(
        TestWorker.enqueue_at(["b"], "time") == %{
          module: TestWorker,
          arguments: ["b"],
          time: "time",
          options: [queue: "default", max_retries: 10, foo: :bar]
        }
      )
    end

    test "with not a list" do
      assert(
        TestWorker.enqueue_at("b", "time") == %{
          module: TestWorker,
          arguments: ["b"],
          time: "time",
          options: [queue: "default", max_retries: 10, foo: :bar]
        }
      )
    end
  end

  describe "enqueue_in/1" do
    test "without arguments and only with time" do
      assert(
        TestWorker.enqueue_in("time") == %{
          module: TestWorker,
          arguments: [],
          offset: "time",
          options: [queue: "default", max_retries: 10, foo: :bar]
        }
      )
    end
  end

  describe "enqueue_in/2" do
    test "with a list" do
      assert(
        TestWorker.enqueue_in(["b"], "time") == %{
          module: TestWorker,
          arguments: ["b"],
          offset: "time",
          options: [queue: "default", max_retries: 10, foo: :bar]
        }
      )
    end

    test "with not a list" do
      assert(
        TestWorker.enqueue_in("b", "time") == %{
          module: TestWorker,
          arguments: ["b"],
          offset: "time",
          options: [queue: "default", max_retries: 10, foo: :bar]
        }
      )
    end
  end

  describe "config" do
    test "missing encforced option is raising an error" do
      error_message =
        "Enforced Jobex option `:queue` is missing for Elixir.JobexTest.TestWorkerWithoutQueue.\n"

      Application.put_env(:jobex, :enforced_options, [:queue])

      assert_raise RuntimeError, error_message, fn ->
        defmodule TestWorkerWithoutQueue do
          use Jobex
        end
      end

      Application.delete_env(:jobex, :enforced_options)
    end

    test "missing adapter is raising an error" do
      Application.delete_env(:jobex, :adapter)

      error_message =
        "Please specify adapter in your config file: \"config :jobex, :adapter, MyApp.Adapter\"\n"

      assert_raise RuntimeError, error_message, fn ->
        defmodule TestWorkerWithoutAdapter do
          use Jobex
        end
      end

      Application.put_env(:jobex, :adapter, TestAdapter)
    end
  end
end
