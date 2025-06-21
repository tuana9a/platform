{{- define "ingress.annotations" }}
  annotations:
  {{- if .Values.ingress.annotations }}
    {{- $tp := typeOf .Values.ingress.annotations }}
    {{- if eq $tp "string" }}
      {{- tpl .Values.ingress.annotations . | nindent 4 }}
    {{- else }}
      {{- toYaml .Values.ingress.annotations | nindent 4 }}
    {{- end }}
  {{- end }}
{{- end -}}
