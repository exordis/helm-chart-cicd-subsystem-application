{{- define "subsystem-application.metadata.selector-labels" -}}
exordis/subsystem: {{ $.Values.global.subsystem | quote }}
exordis/environment: {{ $.Values.global.environment | quote }}
exordis/application: {{ include "sdk.naming.application-canonical-name" (list $.Values.global.subsystem $.Values.application) | quote }}
exordis/application-instance: {{ $.Values.instanceName | default "" | quote }}
{{- end -}}