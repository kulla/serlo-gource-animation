import fileinput

blacklist = ["packages", "public", "private", "module", "src"]

for line in fileinput.input():
    entries = line.strip().split("|")
    paths = [ p for p in entries[-1].split("/") if p not in blacklist ]

    print("|".join(entries[:-1]) + "|" + "/".join(paths))
