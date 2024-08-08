{{- define "subsystem-application.validations.application-name" -}}
{{- if hasPrefix ($.Values.global.subsystem | printf "%s-") $.Values.application }}
subsystemApplication: foo
    `.Values.application` is expected to contain application specific name,
    but starts with "{{ $.Values.global.subsystem }}-" likely canonical application name is provided instead of specific one
{{- end }}
{{- end }}