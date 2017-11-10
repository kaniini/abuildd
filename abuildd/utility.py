import asyncio
import contextlib
import os
import logging


logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)


@contextlib.contextmanager
def chdir_context(new_path):
    curdir = os.getcwd()
    try:
        os.chdir(new_path)
        yield
    finally:
        os.chdir(curdir)


async def run_blocking_command(arglist, env=None, log=None):
    if not log:
        log = asyncio.subprocess.PIPE

    proc = await asyncio.create_subprocess_exec(*arglist, env=env, stdout=log, stderr=log)
    return await proc.wait()
