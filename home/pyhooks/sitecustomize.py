# ~/pyhooks/sitecustomize.py
import subprocess
import os

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

        print("\n=== subprocess command ===")
        print(f"CMD: {cmd_str}")
        print(f"CWD: {cwd}")
        print(f"{env_log}")
        print("==========================\n", flush=True)

        super().__init__(args, *a, **kw)

subprocess.Popen = LoggedPopen
