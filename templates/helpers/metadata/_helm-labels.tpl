{{- define "subsystem-application.metadata.helm-labels" -}}
{{- $chart_version := printf "%s-%s" $.Chart.Name  ( $.Chart.Version | replace "+" "_" ) -}}
helm.sh/chart: {{ $chart_version | trunc 63 | trimSuffix "-" | trimSuffix "." | quote }}
{{- end -}}