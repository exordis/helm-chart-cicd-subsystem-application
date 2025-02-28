{{- define "subsystem-application.configuration.engine" -}}
modules:
  - configuration
  - deployment
  - networking
  - cronjobs
  - storage
  - security
  # - data-folders
entities:
  configMaps: {}
  externalSecrets: {}
  secrets: {}
  services: {}
  ingresses: {}
  serviceMonitors: {}
  pvcs: {}
  cronjobs: {}
  deployments: {}
  clusterRoles: {}
  serviceAccounts: {}
shared_ids:
  - ["initContainers", "containers"]
  - ["secrets", "externalSecrets"]
logging: true
values_defaults_template: "subsystem-application.configuration.defaults.values"
{{- end -}}





