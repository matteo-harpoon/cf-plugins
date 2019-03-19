#!/bin/bash

# @Author: Matteo Zambon <matteo>
# @Date:   2019-03-19 10:33:43
# @Last modified by:   matteo
# @Last modified time: 2019-03-19 02:42:55


echo " "
echo "= = = = = = = = = = = "
echo "PATH $PATH" | tr ':' '\n'

echo " "
echo "= = = = = = = = = = = "
echo "loading nvm ..."
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

# make nvm available immediately
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

echo " "
echo "= = = = = = = = = = = "
echo "Is nvm installed?"
command -v nvm
nvm --version

# based on this recommendation in the error logs
# nvm is not compatible with the npm config "prefix" option: currently set to "/home/pipeline/.npm-global"
# Run `npm config delete prefix` or `nvm use --delete-prefix v11.2.0` to unset it.
echo " "
echo "= = = = = = = = = = = "
echo "config delete prefix..."
npm config delete prefix


echo " "
echo "= = = = = = = = = = = "
if [ -z "$NODE_VERSION" ]; then
  echo "Installing the 9.1.0 version of nodejs"
  nvm install 9.1.0
else
  echo "Installing the $NODE_VERSION version of nodejs"
  nvm install $NODE_VERSION
fi

# remember to add below directory name to 
# Build Archive Directory field of this configuration
# mkdir build_archive_dir

echo " "
echo "= = = = = = = = = = = "
echo "Which node version is it?"
node -v
npm -v

# do not do this with every build.  It only needs to be added once.
A=$(cat /home/pipeline/.bashrc | grep 'NVM_DIR' | wc -l)
if [ A == 0 ] ; then
  echo " "
  echo "= = = = = = = = = = = = = = = = = = ="
  echo "prepare to load nvm in the next stage"
  echo 'export NVM_DIR="$HOME/.nvm" ' >> /home/pipeline/.bashrc
  echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm ' >> /home/pipeline/.bashrc
  echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion ' >> /home/pipeline/.bashrc
fi

echo " "
echo "= = = = = = = = = = = = = = = = = = ="
echo "contents of /home/pipeline/.bashrc:"
cat /home/pipeline/.bashrc

echo " "
echo "= = = = = = = = = = = = = = = = = = ="
currentDirectory=`pwd`
echo "Contents of directory "$currentDirectory
ls -al

echo " "
