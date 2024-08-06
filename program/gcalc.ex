defmodule GCalc do
  use GenServer

  @moduledoc """
  A calculator module implemented using GenServer.

  This module provides functions to perform basic arithmetic operations
  (addition, subtraction, multiplication, and division) using a GenServer.
  """

  ## Client API

  @doc """
  Starts the GenServer.

  ## Examples

      iex> {:ok, pid} = DCalc.start_link()
      {:ok, #PID<0.123.0>}

  """
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
  Sends a request to add two numbers.

  ## Parameters

    - `a`: The first number.
    - `b`: The second number.

  ## Examples

      iex> DCalc.suma(1, 2)
      3

  """
  def suma(a, b) do
    GenServer.call(__MODULE__, {:suma, a, b})
  end

  @doc """
  Sends a request to subtract two numbers.

  ## Parameters

    - `a`: The first number.
    - `b`: The second number.

  ## Examples

      iex> DCalc.resta(5, 3)
      2

  """
  def resta(a, b) do
    GenServer.call(__MODULE__, {:resta, a, b})
  end

  @doc """
  Sends a request to multiply two numbers.

  ## Parameters

    - `a`: The first number.
    - `b`: The second number.

  ## Examples

      iex> DCalc.multiplicacion(4, 3)
      12

  """
  def multiplicacion(a, b) do
    GenServer.call(__MODULE__, {:multiplicacion, a, b})
  end

  @doc """
  Sends a request to divide two numbers.

  ## Parameters

    - `a`: The first number.
    - `b`: The second number.

  ## Examples

      iex> DCalc.division(10, 2)
      5.0

  """
  def division(a, b) do
    GenServer.call(__MODULE__, {:division, a, b})
  end

 ## Server Callbacks

 @impl true
 @doc """
 Initializes the GenServer state.

 ## Parameters

   - `:ok`: Initial state.

 ## Returns

   - `{:ok, state}`: The initial state of the GenServer.

 ## Examples

     iex> {:ok, state} = DCalc.init(:ok)
     {:ok, %{}}

 """
 def init(:ok) do
   {:ok, %{}}
 end

 @impl true
 @doc """
 Handles synchronous requests to add two numbers.

 ## Parameters

   - `{:suma, a, b}`: Tuple containing the operation and the two numbers.
   - `_from`: The process that sent the request.
   - `state`: The current state of the GenServer.

 ## Returns

   - `{:reply, result, state}`: The result of the addition and the current state.

 ## Examples

     iex> {:reply, result, state} = DCalc.handle_call({:suma, 1, 2}, self(), %{})
     {:reply, 3, %{}}

 """
 def handle_call({:suma, a, b}, _from, state) do
   {:reply, a + b, state}
 end

 @impl true
 @doc """
 Handles synchronous requests to subtract two numbers.

 ## Parameters

   - `{:resta, a, b}`: Tuple containing the operation and the two numbers.
   - `_from`: The process that sent the request.
   - `state`: The current state of the GenServer.

 ## Returns

   - `{:reply, result, state}`: The result of the subtraction and the current state.

 ## Examples

     iex> {:reply, result, state} = DCalc.handle_call({:resta, 5, 3}, self(), %{})
     {:reply, 2, %{}}

 """
 def handle_call({:resta, a, b}, _from, state) do
   {:reply, a - b, state}
 end

 @impl true
 @doc """
 Handles synchronous requests to multiply two numbers.

 ## Parameters

   - `{:multiplicacion, a, b}`: Tuple containing the operation and the two numbers.
   - `_from`: The process that sent the request.
   - `state`: The current state of the GenServer.

 ## Returns

   - `{:reply, result, state}`: The result of the multiplication and the current state.

 ## Examples

     iex> {:reply, result, state} = DCalc.handle_call({:multiplicacion, 4, 3}, self(), %{})
     {:reply, 12, %{}}

 """
 def handle_call({:multiplicacion, a, b}, _from, state) do
   {:reply, a * b, state}
 end

 @impl true
 @doc """
 Handles synchronous requests to divide two numbers.

 ## Parameters

   - `{:division, a, b}`: Tuple containing the operation and the two numbers.
   - `_from`: The process that sent the request.
   - `state`: The current state of the GenServer.

 ## Returns

   - `{:reply, result, state}`: The result of the division and the current state.
   - `{:reply, {:error, "No se puede dividir por cero"}, state}`: Error tuple if division by zero is attempted.

 ## Examples

     iex> {:reply, result, state} = DCalc.handle_call({:division, 10, 2}, self(), %{})
     {:reply, 5.0, %{}}

     iex> {:reply, result, state} = DCalc.handle_call({:division, 10, 0}, self(), %{})
     {:reply, {:error, "No se puede dividir por cero"}, %{}}

 """
 def handle_call({:division, _a, 0}, _from, state) do
    raise ArgumentError, message: "No se puede dividir por cero"
   {:reply, {:error, "No se puede dividir por cero"}, state}
 end

 def handle_call({:division, a, b}, _from, state) do
   {:reply, a / b, state}
 end

 @impl true
 @doc """
 Handles all other messages.

 ## Parameters

   - `_msg`: The message received.
   - `state`: The current state of the GenServer.

 ## Returns

   - `{:noreply, state}`: The current state of the GenServer.

 ## Examples

     iex> {:noreply, state} = DCalc.handle_info(:some_message, %{})
     {:noreply, %{}}

 """
 def handle_info(_msg, state) do
   {:noreply, state}
 end
 @impl true
 def handle_cast({:suma, a, b, caller}, state) do
    Process.send_after(caller, {:result, a + b}, 2000)
    {:noreply, state}
  end
  @impl true
  def handle_cast({:resta, a, b, caller}, state) do
    Process.send_after(caller, {:result, a - b}, 2000)
    {:noreply, state}
  end
  @impl true
  def handle_cast({:multiplicacion, a, b, caller}, state) do
    Process.send_after(caller, {:result, a * b}, 2000)
    {:noreply, state}
  end
  @impl true
  def handle_cast({:division, _a, 0, caller}, state) do
    Process.send_after(caller, {:error, "No se puede dividir por cero"}, 2000)
    {:noreply, state}
  end
  @impl true
  def handle_cast({:division, a, b, caller}, state) do
    Process.send_after(caller, {:result, a / b}, 2000)
    {:noreply, state}
  end
end
