# NodePool

Load distribution facility.

This module adds extensions to Erlang's pool module.

The module can be used to run a set of BEAM nodes as a pool of computational processors.
It is organized as a master and a set of slave nodes and includes the following features:

The slave nodes send regular reports to the master about their current load.
Queries can be sent to the master to determine which node will have the least load.
The BIF statistics(run_queue) is used for estimating future loads. It returns the length
of the queue of ready to run processes in the Erlang runtime system.

Differing from the Erlang version, the .hosts.erlang file is not consulted.
Instead, the pool can be started various ways.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `node_pool` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:node_pool, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/node_pool](https://hexdocs.pm/node_pool).

