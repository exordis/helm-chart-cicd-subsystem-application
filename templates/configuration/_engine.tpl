{{- define "subsystem-application.configuration.engine" -}}
modules:
  - external-secrets
  - deployment
  - data-folders
  - networking
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
shared_ids:
  - ["initContainers", "containers"]
logging: true
values_defaults_template: "subsystem-application.configuration.defaults.values"
{{- end -}}





