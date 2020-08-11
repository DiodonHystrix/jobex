defmodule Jobex.Adapter do
  @moduledoc """
  Behaviour module for implementing background job Adapter.

  Adapter's purpose is to enqueuing #TODO: fix this
  """

  @type arguments() :: list()
  @type options() :: Keyword.t()
  @type time() :: term()

  @doc """
  Enqueues a job.

  It takes three arguments that are passed from Jobex behaviour and they should be forwarded to a background job system.
  """
  @callback enqueue(module(), arguments(), options()) :: term()

  @doc """
  Enqueues a job at specified time.

  It takes three arguments that are passed from Jobex behaviour and they should be forwarded to a background job system.
  """
  @callback enqueue_at(module(), arguments(), time(), options()) :: term()

  @doc """
  Enqueues a job after specified time.

  It takes three arguments that are passed from Jobex behaviour and they should be forwarded to a background job system.
  """
  @callback enqueue_in(module(), arguments(), time(), options()) :: term()
end
