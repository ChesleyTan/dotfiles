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

def finish():
    nvim.command('let g:gitInfo="%s"' % s)
    sys.exit(0)

# Ported from ~/.vimrc, so we're not using python's regex libraries
########## Git Branch ##########
output = subprocess.Popen("cd '%s' && git branch | grep '*' | grep -o '[^* ]*'" % PWD, shell=True, stdout=subprocess.PIPE).stdout.read().replace('"', '\\"').replace('\n','')
if output == "" or "fatal" in output:
    sys.exit(0)
else:
    branch_name = output
    s += "[Git][" + branch_name + " " # Excludes trailing newline

########## Git Status ##########
output = subprocess.Popen("cd '%s' && git status" % PWD, shell=True, stdout=subprocess.PIPE).stdout.read().replace('"', '\\"')
if output == "":
    pass
else:
    if "Changes to be committed" in output:
        s += "\u2718"
    else:
        s += "\u2714"
    if "modified" in output:
        s += " \u0394"

########## Git Stash ##########
output = subprocess.Popen("cd '%s' && git stash list | wc -l" % PWD, shell=True, stdout=subprocess.PIPE).stdout.read().replace('"', '\\"').replace('\n', '')
if output != "0":
    s += " \u26c1 " + output

s += "]"

########## Git Remote ##########
output = subprocess.Popen("cd '%s' && git remote" % PWD, shell=True, stdout=subprocess.PIPE).stdout.read().replace('"', '\\"')
remotes = output.split(' ')
if remotes == []:
    s += "no remotes"
else:
    remote_name = remotes[0].strip() # Get the name of the first remote
    output = subprocess.Popen("cd '%s' && git remote show '%s' | grep '%s'" % (PWD,
        remote_name, branch_name), shell=True, stdout=subprocess.PIPE).stdout.read().replace('"', '\\"')
    if output == "" or "fatal" in output:
        pass
    elif "local out of date" in output:
        s += "(!)Local repo out of date"
    else:
        pass # Local is up to date

finish()
