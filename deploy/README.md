## Deployment

Deployment is managed with [Tanka](https://tanka.dev/) which makes it possible to easily create the Kubernetes manifests.

### Getting Started

First install the [Tanka](https://tanka.dev/install) CLI tool and also ensure that `kubectl` is properly configure to contact
your cluster.

You need to also setup a `secrets.jsonnet` file inside each environment (e.g. `environments/prod`),
we provide a fake one for testing purposes that you can enable with `cp environments/secrets.jsonnet.sample environments/prod/secrets.jsonnet`,
of course adjusting the values to fit the correct deployment values.

You can easily see all the manifests that are going to be deploying to the cluster with (all commands assumes you are
at the project root):

```
tk show deploy/environments/default
```

> You can filter for specific kind adding `-t deployment/.*` or specific name `-t .*/.*name.*`.

> If you hit an error saying `Error: evaluating jsonnet: RUNTIME ERROR: couldn't open import "secrets.jsonnet"`, you forgot to setup the `secrets.jsonnet` file correctly.

#### Deploying

Deploying is a simply matter of checking the differences with the actual cluster state and then apply it.

```
tk diff deploy/environments/prod
```

And to apply:

```
tk apply deploy/environments/prod
```

### Environments

It's easy to deploy to a staging environment, simply perform a copy of `environments/prod` to for example
`environments/staging` and adjust the `environments/staging/spec.json` accordingly.

### Secrets

Secrets are inlined in the Kubernetes manifest directly for now. This is done by having a `secrets.jsonnet` file that is managed locally by each deployer.

On a production setup, you should check about using a production grade secret management tool like HashiCorp Vault or similar tools.
