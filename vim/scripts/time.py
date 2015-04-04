from neovim import attach
import subprocess
import sys

if len(sys.argv) < 2:
    sys.exit(0)
ADDRESS = sys.argv[1]
nvim = attach('socket', path=ADDRESS)
time = subprocess.Popen("date", stdout=subprocess.PIPE).stdout.read()
time = time.replace('\n', '')
nvim.command('echo "%s"' % (time,))
