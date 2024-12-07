

{{- define "subsystem-application.entities.applicationContainer.spec.defaults" -}}
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
{{- end -}}