"""Cuenta las palabras del CUERPO del articulo.

El enunciado limita el texto a 2000-4000 palabras y excluye tablas y referencias.
Aqui tambien se excluyen titulo, autores, resumen y palabras clave, que son
metadatos de la plantilla IEEE y no cuerpo del ensayo.
"""
import re
import sys
from pathlib import Path

ART = Path(__file__).resolve().parents[1] / "docs" / "articulo.md"

MIN_WORDS, MAX_WORDS = 2000, 4000


def body_words(text: str) -> tuple[int, dict[str, int]]:
    per_section: dict[str, int] = {}
    current = "(preambulo)"
    total = 0
    in_refs = False
    for raw in text.splitlines():
        line = raw.strip()
        if not line:
            continue
        if line.startswith("%references"):
            in_refs = True
            continue
        if in_refs:
            continue
        if line.startswith("|") or line.startswith("%tablehead:"):
            continue
        if line.startswith("%"):  # title / author / abstract / keywords
            continue
        if line.startswith("#"):
            current = line.lstrip("#").strip()
            per_section.setdefault(current, 0)
            continue
        n = len(re.findall(r"[\wÀ-ɏ'`-]+", line))
        per_section[current] = per_section.get(current, 0) + n
        total += n
    return total, per_section


def main() -> int:
    total, per_section = body_words(ART.read_text(encoding="utf-8"))
    width = max(len(s) for s in per_section)
    for section, n in per_section.items():
        print(f"  {section:<{width}}  {n:>5}")
    print(f"\n  {'TOTAL CUERPO':<{width}}  {total:>5}   (limite {MIN_WORDS}-{MAX_WORDS})")
    if not MIN_WORDS <= total <= MAX_WORDS:
        print("\n  FUERA DE RANGO")
        return 1
    print("  EN RANGO")
    return 0


if __name__ == "__main__":
    sys.exit(main())
