import sys
import jinja2
import yaml

print("sys.argv", " ".join(sys.argv))

var_file = sys.argv[1]
template_files = sys.argv[2:]

if not var_file:
    print("var_file is missing")
    exit(1)

if not template_files:
    print("template_files is missing")
    exit(1)

with open(var_file) as fuck:
    variables = yaml.safe_load(fuck)
    print("variables", variables)

for filepath in template_files:
    if not filepath.endswith(".j2"):
        print(f"skiping: {filepath} (should ends with .j2)")
        continue
    with open(filepath) as fuck:
        template = jinja2.Template(fuck.read())
        out = template.render(**variables)
        outpath = filepath[:-3]
        print(f"--- {outpath} ---\n{out}")
        with open(outpath, mode="w") as yeah:
            yeah.write(out)
