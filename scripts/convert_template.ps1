# La plantilla oficial de IEEE viene en OOXML *Strict* (namespaces purl.oclc.org)
# y python-docx solo entiende Transitional. Word la reguarda en Transitional.
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$src = Join-Path $root 'assets\ieee-conference-template-a4.docx'
$dst = Join-Path $root 'assets\ieee-template-transitional.docx'

if (-not (Test-Path $src)) { throw "Falta la plantilla: $src (ejecuta fetch_template.ps1)" }

$word = New-Object -ComObject Word.Application
$word.Visible = $false
$word.DisplayAlerts = 0
try {
    $doc = $word.Documents.Open($src, [ref]$false, [ref]$true)
    $doc.SaveAs2([ref]$dst, [ref]12)   # 12 = wdFormatXMLDocument (Transitional)
    $doc.Close([ref]0)
} finally {
    $word.Quit()
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($word) | Out-Null
}
"Plantilla convertida -> $dst"
