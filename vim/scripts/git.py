from neovim import attach
import subprocess
import sys

# Reads the socket address for the neovim instance and the PWD from arguments
if len(sys.argv) < 3:
    sys.exit(0)
ADDRESS = sys.argv[1]
PWD = sys.argv[2]
nvim = attach('socket', path=ADDRESS)

CHECK = "\u2714"
CROSS = "\u2718"
DELTA = "\u0394"
STASH = "\u26c1"

s = ""
branch_name = ""
remote_name = ""
state_icons = []
stash_size = ""
remote_status = ""

def finish():
    nvim.command('let g:gitInfo="%s"' % s)
    sys.exit(0)

def run_cmd(cmd):
    return subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, cwd=PWD)\
                     .stdout.read().strip().replace('"', '\\"')

# Ported from ~/.vimrc, so we're not using python's regex libraries
########## Git Branch ##########
output = run_cmd("git branch | grep '*' | grep -o '[^* ]*'")
if not output or "fatal" in output:
    sys.exit(0)
else:
    branch_name = output.strip()

########## Git Status ##########
output = run_cmd("git status")
if not output:
    pass
else:
    if "Changes to be committed" in output:
        state_icons.append(CROSS)
    else:
        state_icons.append(CHECK)
    if "modified" in output:
        state_icons.append(DELTA)

########## Git Stash ##########
output = run_cmd("git stash list | wc -l").strip()
if output != "0":
    stash_size = output

########## Git Remote ##########
output = run_cmd("git remote")
remotes = output.split(' ')
if remotes == []:
    remote_status = "no remotes"
else:
    remote_name = remotes[0].strip() # Get the name of the first remote
    output = run_cmd("GIT_TERMINAL_PROMPT=0 git remote show '%s' | grep '%s'" % (remote_name, branch_name))
    if not output or "fatal" in output:
        pass
    elif "local out of date" in output:
        remote_status = "(!) Local out of date"

components = [branch_name, ' '.join(state_icons)]
if stash_size:
    components.append(STASH + ' ' + stash_size)
if remote_status:
    components.append(remote_status)
s += "[Git][{}]".format(' '.join(components))

finish()
