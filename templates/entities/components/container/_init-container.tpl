{{- define "subsystem-application.entities.init-container.collection" -}}initContainers{{- end -}}
{{- define "subsystem-application.entities.initContainers.entity" -}}init-container{{- end -}}

{{- define "subsystem-application.entities.init-container.defaults" -}}
order: 1000
{{ include "subsystem-application.entities.container-base.defaults" . -}}
{{- end -}}

{{- define "subsystem-application.entities.init-container.create" -}}
{{- include "subsystem-application.entities.container-base.create" . -}}
{{- end -}}

{{- define "subsystem-application.entities.init-container.process" -}}
{{- include "subsystem-application.entities.container-base.process" . -}}
{{- end }}