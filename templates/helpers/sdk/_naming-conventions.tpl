{{- define "subsystem-application.naming.conventions.kind"  -}}
{{- $ := index . 0 -}}
{{- $args := dict -}}

{{- $_ :=  set $args "id"   ( index . 1 )  -}}
{{- $_ :=  set $args "kind" ( index . 2 )  -}}

{{- $_ :=  set $args "subsystem"       ( $.Values.global.subsystem   | default "" ) -}}
{{- $_ :=  set $args "environment"     ( $.Values.global.environment | default "" ) -}}
{{- $_ :=  set $args "application"     ( $.Values.application        | default "" ) -}}
{{- $_ :=  set $args "applicationType" ( $.Values.applicationType    | default "" ) -}}
{{- $_ :=  set $args "instance"        ( $.Values.instance           | default "" ) -}}

{{- $template := dig "naming" "kinds" $args.kind "{{.subsystem}}-{{.application}}-{{.instance}}-{{.id}}" $.Values.global  -}}
{{- $name := tpl $template $args -}}
{{- $name := $name | lower -}}
{{- $name := regexReplaceAll "[^a-z0-9]+"  $name "-" -}} 
{{- $name := regexReplaceAll "^-+|-+$" $name "" -}} 

{{- include "sdk.naming.validate-k8s-name" $name  -}}
{{- end -}}


{{- define "subsystem-application.naming.conventions.component"  -}}
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

{{- $template := dig "naming" "components" $args.kind "fallback-{{.subsystem}}-{{.application}}-{{.instance}}-{{.id}}" $.Values.global  -}}
{{- $name := tpl $template $args -}}
{{- $name := $name | lower -}}
{{- $name := regexReplaceAll "[^a-z0-9]+"  $name "-" -}} 
{{- $name := regexReplaceAll "^-+|-+$" $name "" -}} 

{{- include "sdk.naming.validate-k8s-name" $name  -}}
{{- end -}}


{{- define "subsystem-application.naming.conventions.metadata"  -}}
{{- $ := index . 0 -}}{{- $name := index . 1 -}}
{{- $args := dict -}}


{{- $_ :=  set $args "subsystem"       ( $.Values.global.subsystem   | default "" ) -}}
{{- $_ :=  set $args "environment"     ( $.Values.global.environment | default "" ) -}}
{{- $_ :=  set $args "application"     ( $.Values.application        | default "" ) -}}
{{- $_ :=  set $args "applicationType" ( $.Values.applicationType    | default "" ) -}}
{{- $_ :=  set $args "instance"        ( $.Values.instance           | default "" ) -}}
{{- $_ :=  set $args "name"            ( $name                       | default "" ) -}}

{{- $template := dig "naming" "metadata" $name "fallback-{{.subsystem}}-{{.application}}-{{.instance}}-{{.name}}" $.Values.global  -}}
{{- $name := tpl $template $args -}}
{{- $name := regexReplaceAll "-+"  $name "-" -}} 
{{- $name := regexReplaceAll "^-+|-+$" $name "" -}} 


{{- $name  -}}
{{- end -}}





