{{- define "subsystem-application.metadata.common-annotations" -}}
exordis/subsystemDescription: {{ printf "%s subsystem" $.Values.global.subsystem | quote }}
{{- end }}