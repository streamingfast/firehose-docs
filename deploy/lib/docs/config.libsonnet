{
  _config+:: {
    project: 'firehose-docs',
    version: error 'version must be set to docker image version',
    domain: 'firehose.streamingfast.io',
    imageTemplate: 'gcr.io/eoscanada-shared-services/%s:%s.linux-amd64',

    frontend: {
      port: 8080,
      name: 'docs-frontend',
    },
  },
}
