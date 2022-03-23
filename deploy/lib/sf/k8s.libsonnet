local sf(k) = {
  deployment+: {
    local deployment = k.apps.v1.deployment,

    new(name, replicas, containers, labels)::
      deployment.new(name, replicas, containers, labels) +
      deployment.mixin.metadata.withLabels(labels) +
      deployment.mixin.spec.withMinReadySeconds(10) +
      deployment.mixin.spec.withRevisionHistoryLimit(10) +
      deployment.mixin.spec.withProgressDeadlineSeconds(600) +
      deployment.mixin.spec.strategy.withType('RollingUpdate') +
      deployment.mixin.spec.strategy.rollingUpdate.withMaxSurge(1) +
      deployment.mixin.spec.strategy.rollingUpdate.withMaxUnavailable(1) +
      deployment.mixin.spec.template.spec.withTerminationGracePeriodSeconds(30),
  },

  service+: {
    local service = k.core.v1.service,
    local servicePort = k.core.v1.servicePort,

    newPublic(name, selector, ports, backendConfig=null)::
      service.new(name, selector, ports) +
      service.metadata.withAnnotationsMixin({ 'cloud.google.com/neg': '{"ingress": true}' }) +
      (
        if backendConfig == null
        then {}
        else service.metadata.withAnnotationsMixin({ 'beta.cloud.google.com/backend-config': '{"default": "%s"}' % backendConfig })
      ) +
      service.mixin.spec.withType('NodePort'),
  },

  backendConfig+: {
    new(service, healthCheck=null, labels={}, mixin={}):: {
      apiVersion: 'cloud.google.com/v1',
      kind: 'BackendConfig',
      metadata: {
        labels: labels,
        name: service,
      },
      spec: {
        healthCheck: healthCheck,
      },
    } + mixin,

    healthCheckHttp(port, requestPath='/', checkIntervalSec=10, timeoutSec=3)::
      self.healthCheck('HTTP', port, requestPath, checkIntervalSec, timeoutSec),

    healthCheckHttps(port, requestPath='/', checkIntervalSec=10, timeoutSec=3)::
      self.healthCheck('HTTPS', port, requestPath, checkIntervalSec, timeoutSec),

    healthCheck(type, port, requestPath='/', checkIntervalSec=10, timeoutSec=3):: {
      type: type,
      port: port,
      requestPath: requestPath,
      checkIntervalSec: checkIntervalSec,
      timeoutSec: timeoutSec,
    },

    mixin: {
      spec: {
        withTimeoutSec(sec):: {
          spec+: {
            timeoutSec: sec,
          },
        },
      },
    },
  },

  ingress+: {
    path(path, service, port):: {
      backend: {
        service: {
          name: service,
          port: {
            number: port,
          },
        },
      },
      path: path,
      pathType: 'ImplementationSpecific',
    },
  },
};

sf((import 'ksonnet-util/kausal.libsonnet')) + {
  withK(k):: sf(k),
}
