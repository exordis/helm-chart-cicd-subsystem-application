{{- define "subsystem-application.configuration.defaults.values" -}}
image: {{ printf "%s/software-development/subsystems/%s/%s-%s" .Values.dockerRegistry .Values.global.subsystem .Values.applicationType  (include "sdk.naming.application-canonical-name" (list .Values.global.subsystem .Values.application))  }}
externalSecretScope: {{ $.Values.global.environment }}
{{- end -}}
