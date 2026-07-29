# Descarga la plantilla oficial IEEE Conference (A4) exigida por la tarea.
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$assets = Join-Path $root 'assets'
$dst = Join-Path $assets 'ieee-conference-template-a4.docx'
$url = 'https://ieee-org.widen.net/content/ge5anzdecd/original/conference-template-a4.docx'

New-Item -ItemType Directory -Force -Path $assets | Out-Null
Invoke-WebRequest -Uri $url -OutFile $dst -UseBasicParsing -TimeoutSec 60
"Plantilla descargada -> $dst ($((Get-Item $dst).Length) bytes)"
