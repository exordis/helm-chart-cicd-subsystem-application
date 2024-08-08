{{- define "subsystem-application.validations.validation-message" -}}
{{- $messages := list -}}
{{- $messages = append $messages (include "subsystem-application.validations.application-name" .) -}}
{{- $messages = without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{- printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- else }}
{{- printf "Validation is correct" -}}
{{- end }}
{{- end }}