from neovim import attach
import subprocess
import sys

# Reads the socket address for the neovim instance and the PWD from arguments
if len(sys.argv) < 3:
    sys.exit(0)
ADDRESS = sys.argv[1]
PWD = sys.argv[2]
nvim = attach('socket', path=ADDRESS)

s = ""
branch_name = ""
remote_name = ""
# Ported from ~/.vimrc, so we're not using python's regex libraries
########## Git Branch ##########
output = subprocess.Popen("cd %s && git branch | grep '*' | grep -o '[^* ]*'" % PWD, shell=True, stdout=subprocess.PIPE).stdout.read().replace('"', '\\"').replace('\n','')
if output == "" or "fatal" in output:
    pass
else:
    branch_name = output
    s += "[Git][" + branch_name + " " # Excludes trailing newline

########## Git Status ##########
output = subprocess.Popen("cd %s && git status" % PWD, shell=True, stdout=subprocess.PIPE).stdout.read().replace('"', '\\"')
if "fatal" in output:
    pass
else:
    if "Changes to be committed" in output:
        s += "\u2718"
    else:
        s += "\u2714"
    if "modified" in output:
        s += " \u0394"
    s += "]"

########## Git Remote ##########
output = subprocess.Popen("cd %s && git remote" % PWD, shell=True, stdout=subprocess.PIPE).stdout.read().replace('"', '\\"')
remotes = output.split(' ')
if remotes == []:
    s += "no remotes"
else:
    remote_name = remotes[0] # Get the name of the first remote
    output = subprocess.Popen("cd %s && git remote show %s | grep '%s'" % (PWD,
        remote_name, branch_name), shell=True, stdout=subprocess.PIPE).stdout.read().replace('"', '\\"')
    if output == "" or "fatal" in output:
        pass
    elif "local out of date" in output:
        s += "(!)Local repo out of date"
    else:
        pass # Local is up to date

nvim.command('let g:gitInfo="%s"' % s)
