import Config

config :libcluster,
  topologies: [
    vsrex: [
      strategy: Cluster.Strategy.Epmd,
      config: [hosts: [:a@localhost, :b@localhost]]
    ]
  ]
