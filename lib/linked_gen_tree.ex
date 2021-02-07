defmodule LinkedGenTree do
  defmacro __using__(_) do
    quote do
      use GenServer

      def start_link(_) do
        GenServer.start_link(__MODULE__, [], name: __MODULE__)
      end

      def new(val) do
        GenServer.call(__MODULE__, {"new", val})
      end

      def init(_) do
        {:ok, nil}
      end

      def handle_call({"new", val}, _from, state) do
        {:reply, val, state}
      end
    end
  end
end
