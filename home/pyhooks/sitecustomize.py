# ~/pyhooks/sitecustomize.py
import subprocess
import os
import sys

class LoggedPopen(subprocess.Popen):
    def __init__(self, args, *a, **kw):
        # Format the command
        if isinstance(args, (list, tuple)):
            cmd_str = ' '.join(str(arg) for arg in args)
        else:
            cmd_str = str(args)

        # Determine cwd (working directory)
        cwd = kw.get("cwd", os.getcwd())

        # Determine environment
        env = kw.get("env", os.environ)
        changes = {
            key: val
            for key, val in env.items()
            if os.environ.get(key) != val
        }

        env_summary = ", ".join(f"{k}={v!r}" for k, v in changes.items())
        env_log = f"ENV: {env_summary}" if changes else "ENV: (inherited)"

        # Log to stderr, not stdout: some subprocesses (e.g. docker's
        # credential helper, which execs gcloud) have their stdout read as a
        # machine-parsed protocol by their caller. Printing to stdout here
        # corrupts that when this hook cascades into grandchild processes.
        print("\n=== subprocess command ===", file=sys.stderr)
        print(f"CMD: {cmd_str}", file=sys.stderr)
        print(f"CWD: {cwd}", file=sys.stderr)
        print(f"{env_log}", file=sys.stderr)
        print("==========================\n", file=sys.stderr, flush=True)

        super().__init__(args, *a, **kw)

subprocess.Popen = LoggedPopen
