{{- define "subsystem-application.metadata.exordis-labels" -}}
exordis/environment: {{ $.Values.global.environment | quote }}
exordis/product: {{ $.Values.global.product | quote }}
exordis/subsystem: {{ $.Values.global.subsystem | quote }}
exordis/application: {{ include "sdk.naming.application-canonical-name" (list $.Values.global.subsystem $.Values.application) | quote }}
exordis/application-instance: {{ $.Values.instanceName | quote }}
exordis/application-type: {{ $.Values.applicationType | quote }}
{{- end -}}