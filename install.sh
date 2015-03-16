#!/bin/bash

GITDIR=~/gittmp
PUPPETGITDIR=$GITDIR/puppet

sudo yum install -y vim-enhanced mysql-devel ruby

cp Gemfile ~/
mkdir ~/.vim
cp vim/update_bundles ~/.vim/


# install rvm
if ! which rvm ; then
  curl -sSL https://get.rvm.io | bash
  rvm install 2.1
else
  echo "RVM already installed."
fi

source ~/.profile
source ~/.rvm/scripts/rvm

rvm use 2.1 && gem install bundler && bundle install -j4 --gemfile=~/Gemfile

echo "--no-autoloader_layout-check
--no-80chars-check
--no-documentation-check
--no-quoted_booleans-check" > ~/.puppet-lint.rc


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

preprepo git@github.com:jameseck/puppet_repository $PUPPETGITDIR/puppet_repository
preprepo git@github.com:jameseck/puppet-roles $PUPPETGITDIR/modules/roles
preprepo git@github.com:jameseck/puppet-profiles $PUPPETGITDIR/modules/profiles

