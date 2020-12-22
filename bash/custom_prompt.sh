# Custom Command prompt add to last of ~/.bashrc

WHITE='\[\033[1;37m\]'
LIGHTGRAY='\[\033[0;37m\]'
GRAY='\[\033[1;30m\]'
BLACK='\[\033[0;30m\]'
RED='\[\033[0;31m\]'
LIGHTRED='\[\033[1;31m\]'
GREEN='\[\033[0;32m\]'
LIGHTGREEN='\[\033[1;32m\]'
BROWN='\[\033[0;33m\]' #Orange
YELLOW='\[\033[1;33m\]'
BLUE='\[\033[0;34m\]'
LIGHTBLUE='\[\033[1;34m\]'
PURPLE='\[\033[0;35m\]'
PINK='\[\033[1;35m\]' #Light Purple
CYAN='\[\033[0;36m\]'
LIGHTCYAN='\[\033[1;36m\]'
DEFAULT='\[\033[0m\]'
VIOLET='\[\033[01;35m\]'

cLINES=$GRAY #Lines and Arrow
cBRACKETS=$GRAY # Brackets around each data item
cERROR=$LIGHTRED # Error block when previous command did not return 0
cSUCCESS=$GREEN  # When last command ran successfully and return 0
cTIME=$LIGHTGRAY # The current time
cSSH=$PINK # Color for brackets if session is an SSH session
cUSR=$LIGHTBLUE # Color of user
cUHS=$CYAN # Color of the user and hostname separator, probably '@'
cHST=$LIGHTGREEN # Color of hostname
cRWN=$RED # Color of root warning
cPWD=$BLUE # Color of current directory
cCMD=$DEFAULT # Color of the command you type


UHS="@"

function parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

function promptcmd()
{
        PREVRET=$?

        #=========================================================
        #check if user is in ssh session
        #=========================================================
        if [[ $SSH_CLIENT ]] || [[ $SSH2_CLIENT ]]; then
                lSSH_FLAG=1
        else
                lSSH_FLAG=0
        fi

        #=========================================================
        # Insert a new line to clear space from previous command
        #=========================================================
        PS1="\n"
        
        #=========================================================
        # Beginning of first line (arrow wrap around and color setup)
        #=========================================================
        PS1="${PS1}${VIOLET}\342\224\214\342\224\200"

        #=========================================================
        # First Dynamic Block - Previous Command Error
        #=========================================================
        if [ $PREVRET -ne 0 ] ; then
                PS1="${PS1} 😩 "
        else
                PS1="${PS1} 😎 "
        fi

        #=========================================================
        # First static block - Current time
        #=========================================================
        PS1="${PS1}${cBRACKETS}[${cTIME}\D{%H:%M}${cBRACKETS}]${cLINES}\342\224\200"

        #=========================================================
        # Second Static block - User@host
        #=========================================================
        # set color for brackets if user is in ssh session
        if [ $lSSH_FLAG -eq 1 ] ; then
                sesClr="$cSSH"
        else
                sesClr="$cBRACKETS"
        fi
        # don't display user if root
        if [ $EUID -eq 0 ] ; then
                PS1="${PS1}${sesClr}[${cRWN}!"
        else
                PS1="${PS1}${sesClr}[${cUHS}\u"
        fi
        # Host Section
        PS1="${PS1}${cUHS}${UHS}\h${sesClr}]${cLINES}\342\224\200"

        #=========================================================
        # Third Static Block - Current Directory 
        #=========================================================
        PS1="${PS1}[${cPWD}\w${cBRACKETS}]"

        #=========================================================
        # conda information and git
        #=========================================================
        if [[ ! -z "$CONDA_DEFAULT_ENV" ]]; then
                PS1="${PS1} ${cSUCCESS}$(parse_git_branch) ${cBRACKETS}venv:${VIOLET}${CONDA_DEFAULT_ENV}"
        else
                PS1="${PS1} ${cSUCCESS}$(parse_git_branch)"
        fi

        #=========================================================
        # Second Line
        #=========================================================
        PS1="${PS1}\n${VIOLET}\342\224\224\342\224\200\342\224\200> ${cCMD}"
}

function load_prompt () {
    PROMPT_COMMAND=promptcmd
    export PS1 PROMPT_COMMAND
}

load_prompt