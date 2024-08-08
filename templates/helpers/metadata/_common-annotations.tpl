{{- define "subsystem-application.metadata.common-annotations" -}}
inceptum/subsystemDescription: {{ printf "%s subsystem" $.Values.global.subsystem | quote }}
{{- end }}