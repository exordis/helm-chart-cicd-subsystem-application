{{- define "subsystem-application.metadata.selector-labels" -}}
inceptum/subsystem: {{ $.Values.global.subsystem | quote }}
inceptum/environment: {{ $.Values.global.environment | quote }}
inceptum/application: {{ include "sdk.naming.application-canonical-name" (list $.Values.global.subsystem $.Values.application) | quote }}
inceptum/applicationInstance: {{ $.Values.instanceName | default "" | quote }}
{{- end -}}