local k = import 'ksonnet-util/kausal.libsonnet';
local sf = import 'sf/k8s.libsonnet';

// Reference documentation to find the right thing to call https://jsonnet-libs.github.io/k8s-libsonnet/1.20
local deployment = k.apps.v1.deployment;
local container = k.core.v1.container;
local port = k.core.v1.containerPort;
local service = k.core.v1.service;
local servicePort = k.core.v1.servicePort;
local ingress = k.networking.v1.ingress;

(import 'config.libsonnet') + {
  // alias our params, too long to type every time
  local c = $._config,

  docs: {
    frontend: {
      local labels = { project: c.project, app: c.frontend.name },

      deployment:
        sf.deployment.new(
          name=c.frontend.name,
          replicas=2,
          labels=labels,
          containers=[
            container.new(c.frontend.name, c.imageTemplate % [c.frontend.name, c.version]) +
            container.withImagePullPolicy('Always') +
            container.withPorts([port.new('ui', c.frontend.port)]) +
            k.util.resourcesRequests('100m', '50Mi') +
            k.util.resourcesLimits('500m', '200Mi'),
          ],
        ),

      service:
        k.util.serviceFor(self.deployment) +
        service.mixin.spec.withType('NodePort'),

      backendConfig:
        sf.backendConfig.new(
          service=self.service.metadata.name,
          labels=labels,
          healthCheck=sf.backendConfig.healthCheckHttp(port=c.frontend.port, requestPath='/'),
        ),

      publicService:
        sf.service.newPublic(
          name='public-' + c.frontend.name,
          selector=labels,
          ports=[servicePort.newNamed('ui', c.frontend.port, c.frontend.port)],
          backendConfig=self.backendConfig.metadata.name,
        ),
    },

    local publicFrontendServiceName = $.docs.frontend.publicService.metadata.name,

    ingress:
      ingress.new(name=c.project) +
      ingress.metadata.withAnnotations({
        'kubernetes.io/ingress.class': 'gce',
        'networking.gke.io/managed-certificates': std.join(', ', [
          $.docs.managedCertificate.metadata.name,
        ]),
      }) +
      ingress.spec.withRules([{
        host: c.domain,
        http: {
          paths: [
            sf.ingress.path(path='/*', service=publicFrontendServiceName, port=c.frontend.port),
          ],
        },
      }]),

    managedCertificate: {
      apiVersion: 'networking.gke.io/v1',
      kind: 'ManagedCertificate',
      metadata: {
        name: std.strReplace(c.domain, '.', '-'),
      },
      spec: {
        domains: [c.domain],
      },
    },
  },

}
