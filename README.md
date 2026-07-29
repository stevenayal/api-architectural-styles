# Tarea 3 — Estilos de integración de APIs (artículo IEEE)

Informe técnico en formato de artículo IEEE (plantilla oficial A4, dos columnas), estructura
IMRyD, en español. Tema: comparativa de **SOAP, REST, gRPC y GraphQL**.

Autores: Steven Ayala y Ana Duarte.

## Entregable

`docs/Tarea3-EstilosIntegracionAPIs.pdf` — se obtiene exportando el `.docx` generado (ver abajo).

## Estructura

| Ruta | Qué es |
|---|---|
| `docs/articulo.md` | Texto completo del artículo. **Fuente de verdad**: cualquier cambio se hace aquí. |
| `docs/Tarea3-EstilosIntegracionAPIs.docx` | Documento generado sobre la plantilla IEEE. |
| `assets/ieee-conference-template-a4.docx` | Plantilla oficial descargada de ieee.org. |
| `assets/ieee-template-transitional.docx` | La misma plantilla reguardada por Word (ver nota). |
| `scripts/` | Descarga, conversión, generación y verificación. |

## Regenerar

```bash
python scripts/build_docx.py && python scripts/wordcount.py && python scripts/verify_docx.py
```

Para rehacerlo todo desde cero (solo hace falta la primera vez):

```bash
powershell -File scripts/fetch_template.ps1; powershell -File scripts/convert_template.ps1; python scripts/build_docx.py
```

## Obtener el PDF

Abrir `docs/Tarea3-EstilosIntegracionAPIs.docx` en Word y usar
**Archivo → Guardar como → PDF**, guardándolo en `docs/` con el mismo nombre.

`scripts/export_pdf.ps1` automatiza ese paso vía COM, pero **en este equipo Word se queda
colgado** en `ExportAsFixedFormat` (reproducido también con un documento trivial de una línea:
no es un problema del artículo, sino del entorno). Se conserva el script por si el bloqueo
desaparece en otra máquina.

## Notas técnicas

- La plantilla que publica IEEE está en OOXML **Strict** (namespaces `purl.oclc.org`) y
  `python-docx` solo entiende **Transitional**; por eso `convert_template.ps1` la reguarda con
  Word antes de usarla.
- `build_docx.py` no reconstruye el formato IEEE: reutiliza los estilos de la plantilla
  (`paper title`, `Author`, `Abstract`, `Keywords`, `Heading 1..5`, `Body Text`, `table head`,
  `table copy`, `references`) y conserva los saltos de sección que definen las columnas.
- Las tres tablas se aíslan en secciones de una sola columna para que ocupen el ancho de página,
  como es habitual en IEEE.
- Las referencias siguen **APA 7** (el enunciado remite a la guía APA), por lo que se anula la
  numeración automática `[1]` que trae el estilo `references` de la plantilla.
- El límite de 2000–4000 palabras aplica al texto, no a tablas ni referencias:
  `scripts/wordcount.py` cuenta solo el cuerpo. Actualmente: **3054 palabras**.

## Revisión antes de entregar

- Confirmar afiliación y correos de ambos autores en `docs/articulo.md` (`%author:`).
- En el PDF: título y autores a ancho completo, cuerpo a dos columnas, las tres tablas legibles
  y sin desbordar, referencias al final.
