import csv
import json
import threading
import urllib.request
import concurrent.futures

import zstandard
import rich.progress
import conda_package_streaming.url


with urllib.request.urlopen("https://repo.anaconda.com/pkgs/main/linux-64/repodata.json.zst") as fh:
    data = zstandard.decompress(fh.read())
    repodata = json.loads(data)

packages = [*repodata["packages.conda"].keys()]

files = {}
failed = 0
success = 0
lock = threading.Lock()

def get_files(url, progress):
    global failed
    global success

    _failed = False
    data = None
    try:
        for tar, member in conda_package_streaming.url.stream_conda_info(url):
            if member.name == "info/paths.json":
                fh = tar.extractfile(member)
                data = fh.read()
                fh.close()
                break
        else:
            print(f"{url}: No info/paths.json")
            _failed = True
        tar.close()
    except Exception as exc:
        print(f"Failed {package}: {exc}")
        _failed = True

    with lock:
        if _failed:
            failed += 1
        else:
            success += 1
        progress.update(task, advance=1, numfailed=failed, numsuccess=success)

    return url, data


pool = concurrent.futures.ThreadPoolExecutor(max_workers=50)

count = 0
paths = ['_path,path_type,sha256,size_in_bytes,url']

with rich.progress.Progress(
    rich.progress.TextColumn("[progress.description]{task.description}"),
    rich.progress.BarColumn(),
    rich.progress.TextColumn("{task.completed}/{task.total} ([green]success={task.fields[numsuccess]}[/], [red]failed={task.fields[numfailed]}[/])"),
    rich.progress.TimeRemainingColumn(),
    rich.progress.TimeElapsedColumn(),
) as progress:
    task = progress.add_task("Processing...", total=len(packages), numfailed=0, numsuccess=0)
    futures = []

    for package in packages:
        # if count == 1000:
        #     break
        # if package.startswith("_"):
        #     continue

        futures.append(pool.submit(get_files, f"https://repo.anaconda.com/pkgs/main/linux-64/{package}", progress))
        # count += 1

    with open("paths.csv", "w") as fh:
        writer = csv.writer(fh, delimiter=",", lineterminator="\n")
        writer.writerow(["path", "type", "file_mode", "prefix_placeholder", "sha256", "size", "url"])
        for future in futures:
            url, data = future.result()

            if not data:
                continue

            data = json.loads(data)
            for entry in data.get("paths", []):
                writer.writerow([entry["_path"], entry["path_type"], entry.get('file_mode', ''), entry.get('prefix_placeholder', ''), entry["sha256"], entry["size_in_bytes"], url])
            fh.flush()
            del future, url, data
