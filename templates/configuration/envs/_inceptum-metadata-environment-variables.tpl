{{- define "subsystem-application.configuration.envs.inceptum-metadata-environment-variables" -}}
INCEPTUM_PRODUCT: {{ $.Values.global.product | quote }}
INCEPTUM_SUBSYSTEM: {{ $.Values.global.subsystem | quote }}
INCEPTUM_APPLICATION: {{ include "sdk.naming.application-canonical-name" (list $.Values.global.subsystem $.Values.application) | quote }}
INCEPTUM_INSTANCE: {{ $.Values.instanceName | quote }}
INCEPTUM_ENVIRONMENT: {{ $.Values.global.environment | quote }}
{{- end -}}
