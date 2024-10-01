defmodule GsCalculadora do
  use GenServer

  def init(initialSate) do
    IO.puts("Inicializando el gen server")
    IO.inspect(initialSate)
    {:ok, %{counter: 0}}
  end

  def handle_info(msg, state) do
    IO.puts("Recibiendo un mensaje")
    IO.inspect(msg)
    {:noreply, %{state | counter: state.counter + msg}}
  end

  def handle_call(:getCounter, _from, state) do
    {:reply, state.counter, state}
  end

  def handle_cast({:suma, firstParam, secondParam}, state) do
    newState = %{state | counter: firstParam + secondParam}
    {:noreply, newState}
  end

  def handle_cast({:resta, param}, state) do
    newState = %{state | counter: state.counter - param}
    {:noreply, newState}
  end


end
