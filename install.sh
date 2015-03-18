#!/bin/bash

GITDIR=~/gittmp
PUPPETGITDIR=$GITDIR/puppet

sudo yum install -y vim-enhanced mysql-devel ruby

cp Gemfile ~/
mkdir ~/.vim
cp vim/update_bundles ~/.vim/

bash -c "cd ~/.vim && ./update_bundles"

cp git-prompt.sh ~/.git-prompt.sh

# install rvm
if ! which rvm ; then
  curl -sSL https://get.rvm.io | bash -s stable --auto-dotfiles
  rvm install 2.1
else
  echo "RVM already installed."
fi

if ! grep rvm\/scripts\/rvm ~/.bashrc >/dev/null 2>&1; then
  echo "[[ -s \"$HOME/.rvm/scripts/rvm\" ]] && source \"$HOME/.rvm/scripts/rvm\" # Load RVM into a shell session *as a function*" >> ~/.bashrc
fi

source ~/.profile
source ~/.rvm/scripts/rvm

rvm use 2.1 && gem install bundler && bundle install -j4 --gemfile=~/Gemfile

echo "--no-autoloader_layout-check
--no-80chars-check
--no-documentation-check
--no-quoted_booleans-check
--no-class_inherits_from_params_class-check" > ~/.puppet-lint.rc

git config --global --add alias.lol "log --graph --decorate --pretty=oneline --abbrev-commit --all"


function preprepo ()
{
  repourl=$1
  repopath=$2
  echo
  echo "Cloning repo $url"
  rm -rf $repopath
  git clone $repourl $repopath
  rm -rf $repopath/.git/hooks
  git clone https://github.com/drwahl/puppet-git-hooks.git $repopath/.git/hooks

}

# initialise personal puppet repos
mkdir -p $GITDIR
mkdir -p $PUPPETGITDIR
mkdir -p $PUPPETGITDIR/modules

#preprepo git@github.com:jameseck/puppet_repository $PUPPETGITDIR/puppet_repository
#preprepo git@github.com:jameseck/puppet-roles $PUPPETGITDIR/modules/roles
#preprepo git@github.com:jameseck/puppet-profiles $PUPPETGITDIR/modules/profiles

echo
echo "Add the following manually to .bashrc or similar:"
echo
echo source ~/.git-prompt.sh
echo export PS1="\[\033[01;34m\]\[\033[01;32m\]\u@\h\[\033[00m\]:\$([ -f ~/.rvm/bin/rvm-prompt ] && ~/.rvm/bin/rvm-prompt) \[\033[01;32m\]\w\[\033[00;33m\]\$(type __git_ps1 2>/dev/null| head -1 | grep -q '__git_ps1 is a function' &&__git_ps1 \" (%s)\") \[\033[01;36m\]\$\[\033[00m\] "
echo
