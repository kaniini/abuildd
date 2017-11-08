import asyncio
import tempfile
import logging
import os


from .utility import chdir_context, run_blocking_command


logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)


class APKBuildRepository:
    """A repository object which represents a GIT repository containing APKBUILDs."""
    def __init__(self, path=None, url=None, branch=None):
        self.path = path
        self.url = url
        self.branch = branch

        if not self.path:
            self.path = tempfile.mkdtemp(prefix='abuildd-checkout.', dir='/buildfs')
            self._tempdir = True

    @classmethod
    def from_path(cls, path, branch=None):
        return cls(path=path, branch=branch)

    @classmethod
    def from_url(cls, url, branch=None):
        return cls(url=url, branch=branch)

    async def update(self):
        if self._tempdir:
            return await self.checkout()

        with chdir_context(self.path):
            logger.info('Updating git repository: %s', self.path)
            arglist = ['/usr/bin/git', 'update']
            return await run_blocking_command(arglist)

        return None

    async def checkout(self):
        logger.info('Checking out git repository: %s -> %s', self.url, self.path)

        arglist = ['/usr/bin/git', 'clone', '--depth=50']
        if self.branch:
            arglist += ['--branch={branch}'.format(branch=self.branch)]
        arglist += [self.url, self.path]

        with chdir_context(self.path):
            return await run_blocking_command(arglist)

    async def build(self, target, output):
        logger.info('Trying to build: %s', target)

        environment = os.environ
        environment['APORTSDIR'] = self.path
        environment['REPODEST'] = output

        # this is needed to make `git describe` work in the sandbox
        environment['GIT_DISCOVERY_ACROSS_FILESYSTEM'] = '1'

        target_srcdir = '/'.join([self.path, target])
        logger.info('Target srcdir: %s', target_srcdir)

        with chdir_context(target_srcdir):
            result = await run_blocking_command(['/usr/bin/abuild', 'rootbld'], environment)

        logger.info('Build result: %r', result)
        return result
