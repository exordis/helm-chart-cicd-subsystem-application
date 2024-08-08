{{- define "subsystem-application.metadata.inceptum-labels" -}}
inceptum/environment: {{ $.Values.global.environment | quote }}
inceptum/product: {{ $.Values.global.product | quote }}
inceptum/subsystem: {{ $.Values.global.subsystem | quote }}
inceptum/application: {{ include "sdk.naming.application-canonical-name" (list $.Values.global.subsystem $.Values.application) | quote }}
inceptum/applicationInstance: {{ $.Values.instanceName | quote }}
inceptum/applicationType: {{ $.Values.applicationType | quote }}
{{- end -}}