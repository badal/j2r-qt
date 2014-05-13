#!/bin/bash

# get the absolute path of the executable
SELF_PATH=$(cd -P -- "$(dirname -- "$0")" >>/dev/null && pwd -P) && SELF_PATH=$SELF_PATH/$(basename -- "$0")

# resolve symlinks
while [ -h $SELF_PATH ]; do
    # echo $SELF_PATH
    # 1) cd to directory of the symlink
    # 2) cd to the directory of where the symlink points
    # 3) get the pwd
    # 4) append the basename
    DIR=$(dirname -- "$SELF_PATH")
    SYM=$(readlink $SELF_PATH)
    SELF_PATH=$(cd $DIR >>/dev/null && cd $(dirname -- "$SYM") >>/dev/null && pwd)/$(basename -- "$SYM")
done

# load environment variables
if [ -s ~gestion/.bash_profile ]; then
    echo "load env from ~gestion"
    source ~gestion/.bash_profile
else
    echo "Unable to load environment variables"
    exit
fi

#  run ruby script
SELF_DIR="$( cd "$( dirname "$SELF_PATH" )" && pwd -P )"
RUN="../lib/j2r/recipes/batch_reporter.rb $1 $2 $3"
ruby $SELF_DIR/$RUN || echo "can not find with Jacinthe gemset"

#type -P ruby-1.9.3-p194@Jacinthe &>/dev/null && ruby-1.9.3-p194@Jacinthe $SELF_DIR/$RUN || echo "can not find with Jacinthe gemset"
#type -P ruby-1.9.3-p194 &>/dev/null && ruby-1.9.3-p194 $SELF_DIR/$RUN || echo "can not find correct ruby version"
