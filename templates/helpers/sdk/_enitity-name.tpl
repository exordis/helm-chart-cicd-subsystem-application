{{- define "subsystem-application.convention.name"  -}}
{{- $ := index . 0 -}}
{{- $args := dict -}}

{{- $_ :=  set $args "id"   ( index . 1 )  -}}
{{- $_ :=  set $args "kind" ( index . 2 )  -}}

{{- if gt (len .) 3 -}}{{- $_ :=  set $args "parent_id"   ( index . 3 ) -}}{{- end }}
{{- if gt (len .) 4 -}}{{- $_ :=  set $args "parent_kind" ( index . 4 ) -}}{{- end }}

{{- $_ :=  set $args "subsystem"       ( $.Values.global.subsystem   | default "" ) -}}
{{- $_ :=  set $args "environment"     ( $.Values.global.environment | default "" ) -}}
{{- $_ :=  set $args "application"     ( $.Values.application        | default "" ) -}}
{{- $_ :=  set $args "applicationType" ( $.Values.applicationType    | default "" ) -}}
{{- $_ :=  set $args "instance"        ( $.Values.instance           | default "" ) -}}

{{- $template := dig "naming" $args.kind "{{.subsystem}}-{{.application}}-{{.instance}}-{{.id}}" $.Values.global  -}}
{{- $name := tpl $template $args -}}
{{- $name := $name | lower -}}
{{- $name := regexReplaceAll "[^a-z0-9]+"  $name "-" -}} 
{{- $name := regexReplaceAll "^-+|-+$" $name "" -}} 

{{- include "sdk.naming.validate-k8s-name" $name  -}}
{{- end -}}