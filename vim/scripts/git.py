from neovim import attach
import subprocess
import sys

if len(sys.argv) < 3:
    sys.exit(0)
ADDRESS = sys.argv[1]
PWD = sys.argv[2]
nvim = attach('socket', path=ADDRESS)

output = subprocess.Popen("cd %s && git status" % PWD, shell=True, stdout=subprocess.PIPE).stdout.read()
output = output.replace('"', '\\"')
nvim.command('echo "%s"' % output)
