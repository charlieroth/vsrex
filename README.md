# `vsrex`

Elixir implementation of the Viewstamped Replication Protocol

## TODO

- `Mailroom` module
  - Always routes a message to primary replica no matter which replica receives it
  - Can be used as a simulation tool

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `vsrex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:vsrex, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/vsrex>.
