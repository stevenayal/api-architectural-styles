# Exporta el .docx generado a PDF usando Word (COM). Entregable final de la tarea.
#
# Word abre en Vista Protegida los archivos que estan en unidades de red (el
# proyecto vive en Z:) y eso deja la automatizacion COM colgada esperando un
# clic. Por eso se trabaja sobre una copia local en %TEMP% y luego se devuelve
# el PDF al repositorio.
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$src = Join-Path $root 'docs\Tarea3-EstilosIntegracionAPIs.docx'
$dst = Join-Path $root 'docs\Tarea3-EstilosIntegracionAPIs.pdf'

if (-not (Test-Path $src)) { throw "Falta el documento: $src (ejecuta build_docx.py)" }

$work = Join-Path $env:TEMP ('ieee-export-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Force -Path $work | Out-Null
$localDocx = Join-Path $work 'articulo.docx'
$localPdf = Join-Path $work 'articulo.pdf'
Copy-Item $src $localDocx
try { Unblock-File $localDocx } catch {}

$word = New-Object -ComObject Word.Application
$word.Visible = $false
$word.DisplayAlerts = 0
try {
    $doc = $word.Documents.Open($localDocx, [ref]$false, [ref]$false)
    $doc.Fields.Update() | Out-Null       # refresca numeracion de secciones
    $doc.Repaginate()
    $pages = $doc.ComputeStatistics(2)    # 2 = wdStatisticPages
    $words = $doc.ComputeStatistics(0)    # 0 = wdStatisticWords
    $doc.ExportAsFixedFormat($localPdf, 17)   # 17 = wdExportFormatPDF
    $doc.Close([ref]0)
} finally {
    $word.Quit()
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($word) | Out-Null
}

Copy-Item $localPdf $dst -Force
Remove-Item $work -Recurse -Force
"PDF -> $dst"
"Paginas: $pages   Palabras segun Word (incluye tablas y referencias): $words"
