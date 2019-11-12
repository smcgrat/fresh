#!/bin/bash

# this file is only for use with the Trinity Centre for High Performance
# Computing, (https://www.tchpc.tcd.ie/), clusters. Do not use it anywhere else.
# It may be useful as a reference though.

## modules

. /etc/profile.d/modules.sh

## either this module

module load tcin freesurfer/6.0
source $FREESURFER_HOME/SetUpFreeSurfer.sh

## Or the following is used

module rm freesurfer/6.0
module load tcin freesurfer/6-dev-20180918
export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=8
source $FREESURFER_HOME/SetUpFreeSurfer.sh


exit 0
