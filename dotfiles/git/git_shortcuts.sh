#!/bin/bash
# git_shortcuts.sh

# alias gstlast='git ls-files --other --modified --exclude-standard|while read filename; do  echo -n "$(stat -c%y -- $filename 2> /dev/null) "; echo $filename;  done|sort'

# GIT GLOBALS
# if you're currently in a git repository
# function ingit_source() {
#   inside_git_repo="$(git rev-parse --is-inside-work-tree 2>/dev/null)"
#   if [ "$inside_git_repo" ]; then
#     source "$1"
#   else
#     GIT_ERROR="${Red}Are you in a git repo?"
#   fi
# }

alias git=hub

# GIT COMMANDS ONLY AVAILABLE IN GIT REPOS
inside_git_repo="$(git rev-parse --is-inside-work-tree 2>/dev/null)"
if [ "$inside_git_repo" ]; then

  # TODO: fix the errors when you `src` in a git repo that hasn't been initialized yet
  # Current Branch / HEAD Commit Hash (if not on branch, return the tip hash)
  HEAD="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
  # if on commit hash
  if [[ $HEAD == 'HEAD' ]]; then
    HEAD="$(cat .git/HEAD)"
  fi

  # Project Root
  PROJECT_ROOT=$(git rev-parse --show-toplevel)

  # GitHub Aliases / Functions  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Git Exclude
  alias .ge="vim $PROJECT_ROOT/.git/info/exclude"

  # Git Add Commit All (gac = git <add> <commit>)
  function gac() {
    cd $PROJECT_ROOT
    git add -A
    # if 1 argument (i.e. gac `you commit message`)
    if [ "$#" == 1 ]; then
      git commit -a -m "$1"
      # if 2 arguments (i.e. gac `-n` "your commit message")
    elif [ "$#" == 2 ]; then
      git commit "$1"am "$2"
    fi
    cd -
  }

  function gpr () {
    # local repo=`git remote -v | grep -m 1 "(push)" | sed -e "s/.*github.com[:/]\(.*\)\.git.*/\1/"`
    # local repo="$(current_repo)"
    local repo="$(parse_repo_path)"
    local branch=`git name-rev --name-only HEAD`
    echo "... creating pull request for branch \"$branch\" in \"$repo\""
    open https://github.com/$repo/pull/new/$branch
  }


  # Git Quick Update Pull & Push  (gacpp = git <add> <commit> <pull> <push>)
  function gacpp() {
    # if 1 argument (i.e. gac `you commit message`)
    if [ "$#" == 1 ]; then
      cd $PROJECT_ROOT
      git add -A
      git commit -a -m "$1"
      # if 2 arguments (i.e. gac `-n` "your commit message")
    elif [ "$#" == 2 ]; then
      cd $PROJECT_ROOT
      git add -A
      git commit "$1"am "$2"
    fi
    git pull origin "$HEAD";
    git push origin "$HEAD";
    cd -
  }

  # Git Quick Add Commit Push
  function gacp() { # EX: gacp "commit message" branchName
    # if 1 argument (i.e. gac `you commit message`)
    if [ "$#" == 1 ]; then
      git commit -a -m "$1"
      # if 2 arguments (i.e. gac `-n` "your commit message")
    elif [ "$#" == 2 ]; then
      git commit "$1"am "$2"
    fi
    git push origin "$HEAD";
  }

else
  GIT_ERROR="${Red}Are you in a git repo?"
fi

alias gt='git tag'

function gtag() {
  git tag "$@"
  git push origin --tags
}

# Git Delete Branch (or: git push origin :<branchName>)
# alias gdb="git push origin --delete $@"
function gdb() {
  git push origin --delete "$@"
  git branch -d "$@"
}

# Set Global Git Ignore  (help: http://bit.ly/1DhMjhi)
alias set_global_gitignore="git config --global core.excludesfile '~/.gitignore'"

# Location of my global .gitignore
alias my_global_gitignore="git config --get core.excludesfile"

# Git Yolo
alias yolo='git commit -a -m "DEAL WITH IT" && git push -f origin master'

# Git Branch (shows the git branches)
alias gb='git branch'

# New Branch
alias gchb='git checkout -b'

# Git Pull Origin Master
alias glm='git pull origin master'

# Git Checkout
# alias gch='git checkout ${1-\-}'
# alias gch='git checkout ${1--}'
alias gch='git checkout'
# TODO: add functionality where if there are changes made to current commit/branch, stash, then checkout.  Also, use gch to go back to previous commit and run stash pop
# function gch() {
#   re='^[0-9]+$'
#   # if you want to go back to the last commit/branch you were at
#   # EX: gch
#   if [ -z "${1+xxx}" ]; then
#     git checkout -
#   # if you want to checkout a specific head
#   # EX: gch 1
#   elif [[ "$1" =~ $re ]] ; then
#       git checkout HEAD@{"$1"}
#   else
#       git checkout "$@"
#   fi
# }

# Git Clone
function gcl() {
  if [[ $(num_of_occurences $1 '/') == 1 ]]; then
    # ex: gcl visionmedia/express
    git clone --recursive "git@github.com:$@"
  else
    git clone --recursive $@
  fi
  repo_name="$(parse_repo_name $1)"
  cd $repo_name
  # if there's a package.json, run npm install
  if [ -f ./package.json ]; then
    npm install
  elif [ -f ./requirements.txt ] && [ -d ./lib ]; then
    pip install -r requirements.txt -t lib
  fi
}


function parse_repo_name() {
  # Resources:
  # - https://git-scm.com/docs/git-clone#_git_urls_a_id_urls_a
  # - regex: http://www.regexr.com/3drvn
  # Gotchas:
  # - figure out a way to see the .gitconfig so if there's any special configurations, things will still work
  # Cases:
  # 1. ssh://[user@]host.xz[:port]/path/to/repo.git/
  # 2. git://host.xz[:port]/path/to/repo.git/
  # 3. http[s]://host.xz[:port]/path/to/repo.git/
  # 4. ftp[s]://host.xz[:port]/path/to/repo.git/
  # 5. visionmedia/express
  # 6. git@github.com:tableco/profilesvc
  # 7. https://github.com/tableco/appengine
  # Find Name Options
  #   1. visionmedia/express
  #   2. search for repo.git 
  local repo_name="$(basename -s .git $1)"
  # if [[ $1 == *'.git'* ]]; then
    # remove the file extension
    # repo_name="${repo_name%.git}"
  # fi
  echo "$repo_name"
}

function parse_repo_path() {
  
  # if an argument is passed
  if [ "$#" == 1 ]; then
    url="$1"
  else
    url="$(git config -- remote.origin.url)"
  fi

  # should always return: user_or_org/repo_name
  periods="${url//[^.]}"
  num_of_periods="${#periods}"
  is_already_path="$(($num_of_periods == 0))"
  if (( $is_already_path )); then
    echo "$url"
    return
  fi

  # Initial case examples: 'git@example.com:user/project', 'https://example.com:8080/scm/user/project.git/'
  # Trim "/" and ".git" from the end of the url
  giturl=${url%/} giturl=${giturl%.git}

  # Trim before last '@' and protocol (*://) from beginning
  uri=${giturl##*@} uri=${uri##*://}

  # Trims before first ':' or '/' to get path
  local path=${uri#*[/:]}
  echo "$path"
}


# Git Stash
alias gs='git stash'

# Git Stash List
alias gsl='git stash list'

# Git Stash Apply
function gsa() {
  if [ "$#" -e 1 ]; then
    git stash apply stash@{"$1"}
  else
    git stash apply
  fi
}

# Git Stash Pop
alias gsp='git stash pop'

# Git Pull Push
# function gpp() {
#   git pull origin "$HEAD"
#   git push origin "$HEAD"
# }

# Git Pull
function gpl() {
  git pull origin "$1"
}

# Git Update Master
function gum() {
  git stash;
  git checkout master;
  git pull origin master;
  git checkout -
}

# Git Reset
alias grs='git reset'

alias grsh='git reset --hard'

# Git Ref Log
alias grf='git reflog'

# Pretty Git Log
alias glog='git log --graph -C -M --pretty=format:"<%h> %ad [%an] %Cgreen%d%Creset %s" --all --date=short'

# Pretty Git Log For Me!
alias glme="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(red)- %an%C(reset)' --all  --author=alex-cory"

# Pretty Git Log All
# alias gla="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(red)- %an%C(reset)' --all"
alias gl1="git log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"

# Pretty Git Log All Detailed
alias glad="git log --graph --abbrev-commit --decorate --date=relative --all"

# Git Amend
function gam() {
  # If no argument is set (i.e. gam)
  if [ -z "${1+xxx}" ]; then 
    git commit --amend
  # if 1 argument (i.e. OR gam -m)
  elif [ "$#" == 1 ] && [ "$1" == -* ]; then
    git commit --amend "$1"
  # if 1 argument (i.e. gam `you commit message`)
  elif [ "$#" == 1 ] && [ "$1" != -* ]; then
    git commit --amend -m "$1"
  # if 2 arguments (i.e. gam -m "your commit message")
  elif [ "$#" == 2 ] || [ "$1" == *-* ]; then
    git commit --amend "$1" "$2"
  fi
}


# Git Pull Origin
function glo() {
  git pull origin "$1"
}

#Git Push Origin <branch>
function gpo() {
  git push origin "$1"
}

# Git Checkout Master
alias gcm="git checkout master"

# Git Quick Update Pull & Push  (gacfrp = git <add> <commit> <fetch> <rebase> <force push>)
function gacfrp() {
  git add --all && git commit -a -m "$1" && git fetch && git rebase origin "$2" && git push -f origin "$3"
}

# Remove file/dir from remote repo (http://bit.ly/1EPhAaH)
function gcrm() {
  git rm -r --cached "$1" && git commit -m "Remove the now ignored file/dir '$1'" && git push origin "$2"
}

# Git Pull
alias gpl='git pull'

# Git Status
alias gst='git status -s'

# Git Overwrite local Changes
function gol() {
  git fetch origin && git reset --hard origin/master
}

# Setup a new repository
function gsetup() {
  echo "${Yellow}git init${Off}"
  git init &&
  echo "${Yellow}git add .${Off}"
  git add . &&
  echo "${Yellow}git commit -m "first commit"${Off}"
  git commit -m "first commit" &&
  echo "${Yellow}git remote add origin $1 ${Off}"
  git remote add origin "$1" &&
  echo "${Yellow}git pull origin master${Off}"
  git pull origin master
  echo "${Yellow}git push origin master${Off}"
  git push origin master
}
