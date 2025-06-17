{{/*
Generate a fully qualified app name
*/}}
{{- define "base-chart.fullname" -}}
{{- printf "%s" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Common labels used across all resources
*/}}
{{- define "base-chart.labels" -}}
app.kubernetes.io/name: {{ include "base-chart.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
