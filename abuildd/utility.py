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


async def run_blocking_command(arglist, env=None):
    logger.info('command> %r', arglist)
    proc = await asyncio.create_subprocess_exec(*arglist, env=env)
    return await proc.wait()
