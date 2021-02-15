import os
import requests
import subprocess

def main():
    repos_dir = os.path.join(os.path.dirname(__file__), "repos")

    download_repos(repos_dir)
    update_repos(repos_dir)

def update_repos(repos_dir):
    for repo_name in os.listdir(repos_dir):
        info("Update " + repo_name)
        subprocess.run(["git", "pull"], check=True,
                cwd=os.path.join(repos_dir, repo_name))

def download_repos(repos_dir):
    os.makedirs(repos_dir, exist_ok=True)

    repos = requests.get("https://api.github.com/orgs/serlo/repos", headers = {
        "Accept": "application/vnd.github.v3+json"
    }).json()

    info("%s repositories found" % len(repos))

    for repo in repos:
        target_dir = os.path.join(repos_dir, repo["name"])

        if not os.path.isdir(target_dir):
            info("Download " + repo["name"])

            subprocess.run(["git", "clone", repo["html_url"], repo["name"]],
                    check=True, cwd=repos_dir)

def info(message):
    print("INFO: %s" % message)

if __name__ == "__main__":
    main()
