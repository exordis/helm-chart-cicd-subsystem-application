{{- define "subsystem-application.convention.name"  -}}
{{- $ := index . 0 -}}{{- $entity := index . 1 -}}
{{- $args := dict -}}
{{- $_ :=  set $args "id" $entity.id -}}
{{- $_ :=  set $args "type" $entity.entity_type -}}
{{- $_ :=  set $args "parent" ($entity.parent | default dict).id | default "" -}}
{{- $_ :=  set $args "parent_type" ($entity.parent | default dict).entity_type | default "" -}}
{{- $_ :=  set $args "subsystem" $.Values.global.subsystem -}}
{{- $_ :=  set $args "environment" $.Values.global.environment -}}
{{- $_ :=  set $args "application" $.Values.application -}}
{{- $_ :=  set $args "applicationType" $.Values.applicationType -}}
{{- $_ :=  set $args "instanceName" $.Values.instanceName -}}

{{- $template := dig "naming" $entity.entity_type "{{.subsystem}}-{{.application}}" $.Values.global  -}}
{{- $name := tpl $template $args -}}
{{- $name := $name | lower -}}
{{- $name := regexReplaceAll "[^a-z0-9]+"  $name "-" -}} 
{{- $name := regexReplaceAll "^-+|-+$" $name "" -}} 

{{- include "sdk.naming.validate-k8s-name" $name  -}}
{{- end -}}