{{- define "subsystem-application.configuration.engine" -}}
modules:
  # - external-secrets
  # - deployment
  # - data-folders
  - networking
  - storage
  # - cronjobs
entities:
  containers: {}
  volumes: {}
  initContainers: {}
  configMaps: {}
  externalSecrets: {}
  secrets: {}
  services: {}
  ingresses: {}
  serviceMonitors: {}
  pvcs: {}
  cronjobs: {}
shared_ids:
  - ["initContainers", "containers"]
logging: true
values_defaults_template: "subsystem-application.configuration.defaults.values"
{{- end -}}





