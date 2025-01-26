{{- define "subsystem-application.metadata.selector-labels" -}}
exordis/subsystem: {{ $.Values.global.subsystem | quote }}
exordis/environment: {{ $.Values.global.environment | quote }}
exordis/application: {{ include "subsystem-application.naming.conventions.metadata" (list $ "application-canonical-name") | quote }}
exordis/application-instance: {{ $.Values.instance | default "" | quote }}
{{- end -}}