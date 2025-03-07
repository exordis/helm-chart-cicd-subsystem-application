{{- define "subsystem-application.metadata.exordis-labels" -}}
exordis/environment: {{ $.Values.global.environment | quote }}
exordis/product: {{ $.Values.global.product | quote }}
exordis/subsystem: {{ $.Values.global.subsystem | quote }}
exordis/application: {{ include "sdk.naming.conventions.metadata" (list $ "application-canonical-name") | quote }}
exordis/application-instance: {{ $.Values.instance | quote }}
exordis/application-type: {{ $.Values.applicationType | quote }}
{{- end -}}