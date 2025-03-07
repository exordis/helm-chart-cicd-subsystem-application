{{- define "subsystem-application.configuration.envs.exordis-metadata-environment-variables" -}}
EXORDIS_PRODUCT: {{ $.Values.global.product | quote }}
EXORDIS_SUBSYSTEM: {{ $.Values.global.subsystem | quote }}
EXORDIS_APPLICATION: {{ include "sdk.naming.conventions.metadata" (list $ "application-canonical-name") | quote }}
EXORDIS_INSTANCE: {{ $.Values.instance | quote }}
EXORDIS_ENVIRONMENT: {{ $.Values.global.environment | quote }}
{{- end -}}
