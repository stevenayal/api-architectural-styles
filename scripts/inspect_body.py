"""Mapa del cuerpo de la plantilla: orden real de elementos y donde caen los saltos de seccion."""
from pathlib import Path

import docx
from docx.oxml.ns import qn

TEMPLATE = Path(__file__).resolve().parents[1] / "assets" / "ieee-template-transitional.docx"
doc = docx.Document(str(TEMPLATE))
body = doc.element.body

for i, el in enumerate(body.iterchildren()):
    tag = el.tag.split("}")[1]
    if tag == "p":
        style = el.find(qn("w:pPr"))
        st = None
        if style is not None:
            s = style.find(qn("w:pStyle"))
            st = s.get(qn("w:val")) if s is not None else None
        has_sect = style is not None and style.find(qn("w:sectPr")) is not None
        txt = "".join(n.text or "" for n in el.iter(qn("w:t")))
        cols = ""
        if has_sect:
            c = style.find(qn("w:sectPr")).find(qn("w:cols"))
            cols = f"  <<< SECT BREAK cols={c.get(qn('w:num')) if c is not None else 1}"
        print(f"[{i:3}] p   style={str(st):22} {txt[:60]!r}{cols}")
    elif tag == "tbl":
        print(f"[{i:3}] TBL")
    elif tag == "sectPr":
        c = el.find(qn("w:cols"))
        print(f"[{i:3}] FINAL sectPr cols={c.get(qn('w:num')) if c is not None else 1}")
    else:
        print(f"[{i:3}] <{tag}>")

print("\n=== numPr en estilos clave ===")
for name in ("Heading 1", "Heading 2", "references", "bullet list"):
    st = doc.styles[name]
    ppr = st.element.find(qn("w:pPr"))
    numpr = ppr.find(qn("w:numPr")) if ppr is not None else None
    print(f"  {name}: numPr={'SI' if numpr is not None else 'no'}")
