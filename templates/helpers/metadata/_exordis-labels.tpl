{{- define "subsystem-application.metadata.exordis-labels" -}}
exordis/environment: {{ $.Values.global.environment | quote }}
exordis/product: {{ $.Values.global.product | quote }}
exordis/subsystem: {{ $.Values.global.subsystem | quote }}
exordis/application: {{ include "sdk.naming.application-canonical-name" (list $.Values.global.subsystem $.Values.application) | quote }}
exordis/applicationInstance: {{ $.Values.instanceName | quote }}
exordis/applicationType: {{ $.Values.applicationType | quote }}
{{- end -}}