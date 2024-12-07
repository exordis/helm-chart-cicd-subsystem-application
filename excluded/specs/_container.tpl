{{- define "subsystem-application.configuration.defaults.specs._container" -}}
imagePullPolicy: IfNotPresent
resources:
  limits:
    cpu: 200m
    memory: 1024Mi
  requests:
    cpu: 2m
    memory: 70Mi
{{- end }}

{{- define "subsystem-application.configuration.defaults.specs._init-container" -}}
{{- end }}

{{- define "subsystem-application.configuration.defaults.specs._sidecar-container" -}}
{{- end }}

{{- define "subsystem-application.configuration.defaults.specs._job-container" -}}
{{- end }}



{{- define "subsystem-application.configuration.defaults.specs._application-container" -}}
startupProbe:
  failureThreshold: 20
  httpGet:
    path: /healthcheck/live
    port: 8080
  initialDelaySeconds: 10
  periodSeconds: 10
  timeoutSeconds: 10
livenessProbe:
  failureThreshold: 5
  httpGet:
    path: /healthcheck/live
    port: 8080
  initialDelaySeconds: 10
  periodSeconds: 10
  timeoutSeconds: 10
readinessProbe:
  httpGet:
    path: /healthcheck/ready
    port: 8080
  initialDelaySeconds: 10
  periodSeconds: 10
  timeoutSeconds: 10
{{- end }}

{{- define "subsystem-application.configuration.defaults.specs.init-container" -}}
  {{- $container:= (include "subsystem-application.configuration.defaults.specs._container" $) | fromYaml -}}
  {{- $initContainer := (include "subsystem-application.configuration.defaults.specs._init-container" $ ) | fromYaml -}}
  {{- mustMergeOverwrite (deepCopy $container) $initContainer | toYaml -}}
{{- end }}

{{- define "subsystem-application.configuration.defaults.specs.sidecar-container" -}}
  {{- $container:= (include "subsystem-application.configuration.defaults.specs._container" $) | fromYaml -}}
  {{- $sidecarContainer := (include "subsystem-application.configuration.defaults.specs._sidecar-container" $ ) | fromYaml -}}
  {{- mustMergeOverwrite (deepCopy $container) $sidecarContainer | toYaml -}}
{{- end }}

{{- define "subsystem-application.configuration.defaults.specs.application-container" -}}
  {{- $container:= (include "subsystem-application.configuration.defaults.specs._container" $) | fromYaml -}}
  {{- $applicationContainer := (include "subsystem-application.configuration.defaults.specs._application-container" $ ) | fromYaml -}}
  {{- mustMergeOverwrite (deepCopy $container) $applicationContainer | toYaml -}}
{{- end }}


{{- define "subsystem-application.configuration.defaults.specs.job-container" -}}
  {{- $container:= (include "subsystem-application.configuration.defaults.specs._container" $) | fromYaml -}}
  {{- $jobContainer := (include "subsystem-application.configuration.defaults.specs._job-container" $ ) | fromYaml -}}
  {{- mustMergeOverwrite (deepCopy $container) $jobContainer | toYaml -}}
{{- end }}

