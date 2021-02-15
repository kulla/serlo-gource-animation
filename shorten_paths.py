import fileinput

BLACKLIST = ["packages", "public", "private", "module", "plugins"]
MAX_PATH_DEPTH = 5

for line in fileinput.input():
    entries = line.strip().split("|")
    paths = [ p for p in entries[-1].split("/") if p not in BLACKLIST ]

    print("|".join(entries[:-1]) + "|" + "/".join(paths[:MAX_PATH_DEPTH+1]))
