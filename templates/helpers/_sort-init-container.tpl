{{- define "subsystem-application.helpers.sort-init-container" -}}
{{- $ := index . 0 -}}
{{- $workload := index . 1 -}}

{{- $orderMap := dict -}}
{{- $orders := list -}}
{{- range $name, $container := $workload.initContainers -}}
  {{- $orderStr := printf "%03d-%s" ($container.order | default 0) $name -}}  
  {{- $orders = append $orders $orderStr -}}
  {{- $_ := set $orderMap $orderStr $container -}}
{{- end -}}

{{- $sortedOrders := sortAlpha $orders -}}

{{- range $i, $order := $sortedOrders }}
- {{ (index $orderMap $order).spec | toYaml | nindent 2 | trim }}
{{- end }}
{{- end }}