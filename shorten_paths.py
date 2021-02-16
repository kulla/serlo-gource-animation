import fileinput

def with_repo_group(path):
    if path.startswith("/infrastructure"):
        return "/infrastructure" + path
    if path.startswith("/api/"):
        return path
    if path.startswith("/api") or path.startswith("/serlo.org-database-layer"):
        return "/api" + path
    if path.startswith("/serlo.org-cloudflare-worker") or path.startswith("/serlo.org-legal"):
        return "/cloudflare" + path
    if path.startswith("/serlo.org"):
        return path.replace("serlo.org", "serlo.org-legacy")
    if path.startswith("/frontend"):
        return path

    return "/other" + path

BLACKLIST = ["packages", "public", "private", "module", "plugins",
             "serlo.org-cloudflare-worker", "templates", "api.serlo.org"]
MAX_PATH_DEPTH = 5

for line in fileinput.input():
    entries = line.strip().split("|")
    path = with_repo_group(entries[-1])
    paths = [ p for p in path.split("/") if p not in BLACKLIST ]

    #if (len(paths) > MAX_PATH_DEPTH):
    #    path = "/".join(paths[:MAX_PATH_DEPTH] + ["-".join(paths[MAX_PATH_DEPTH:])])
    #else:
    #    path = "/".join(paths)

    print("|".join(entries[:-1]) + "|" + "/".join(paths[:MAX_PATH_DEPTH+1]))
    #print("|".join(entries[:-1]) + "|" + path)
