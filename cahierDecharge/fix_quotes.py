#!/usr/bin/env python3
"""Fix apostrophe issues in generate_pfe.py by converting problem lines to double-quoted strings."""
import re

with open(r'd:\program\mind_space\cahierDecharge\generate_pfe.py', encoding='utf-8') as f:
    content = f.read()

lines = content.split('\n')
fixed_lines = []
count = 0

for i, line in enumerate(lines):
    stripped = line.strip()
    indent = line[:len(line) - len(line.lstrip())]

    # Match a line that is a single-quoted string continuation: '...' where inner has apostrophe
    if stripped.startswith("'") and stripped.endswith("'"):
        inner = stripped[1:-1]
        # Check for embedded apostrophe not preceded by backslash
        if re.search(r"(?<!\\)'", inner):
            # Escape any existing double quotes in inner
            inner_escaped = inner.replace('"', '\\"')
            new_line = indent + '"' + inner_escaped + '"'
            if new_line != line:
                fixed_lines.append(new_line)
                count += 1
                continue
    fixed_lines.append(line)

new_content = '\n'.join(fixed_lines)
with open(r'd:\program\mind_space\cahierDecharge\generate_pfe.py', 'w', encoding='utf-8') as f:
    f.write(new_content)
print(f'Fixed {count} lines')
