# fresh

```
 __                _
/ _|              | |
| |_ _ __ ___  ___| |___
|  _| '__/ _ \/ __| '_  \
| | | | |  __/\__ \ | | |
|_| |_|  \___||___/_| |_|

```

Bash scripting to automate FreeSurfer usage.

## Usage

```
Bash scripting to automate FreeSurfer usage
Use at your own risk, no warranty is provided
Flags explained
        -s <Subject ID>
        -d <Directory where subject data is located> (if not specified assumes current directory)
        -f <NII file to work on> (multiple instances of this flag possible)
        -w <wave/time_series> (multiple instances of this flag possible)
        -l [Only the longitudinal pipelines are run, the recon-all -all are skipped]
        -r [Only the recon-all -all pipelines are run, the longitudinal are skipped]
        -n <number of processor cores to work with for parallel pipelines> (if not set defaults to slurm setting)
        -a <afni input file> (multiple instances of this flag possible)
        -u [Print this help message]
        -h [Print this help message]
```

## Example Usage

### slurm submission example for Trinity College Clusters

#### Run all workflows
```
#!/bin/sh
#SBATCH -N 1
#SBATCH -p compute
#SBATCH -J "fresh"
#SBATCH -t 4-00:00:00

cd $dir

module load apps fresh

fresh -f s5519_w1_T1_GR_FP.nii.gz -f s5519_w1_T2_GR_FP.nii.gz -f s5519_w2_T1_GR_FP.nii.gz -f s5519_w2_T2_GR_FP.nii.gz -f s5519_w3_T1_GR_FP.nii.gz -f s5519_w3_T2_GR_F
P.nii.gz
```

This runs all the pre-processing, `recon-all -all` and longitudinal steps for the supplied files. 

#### Run reccon-all -all workflows only

Specify the `-r` flag with `fresh`. Leave the other settings, such as the `#SBATCH` directives, etc, as is.

E.g.
```
fresh -r -f s5519_w1_T1_GR_FP.nii.gz -f s5519_w1_T2_GR_FP.nii.gz -f s5519_w2_T1_GR_FP.nii.gz -f s5519_w2_T2_GR_FP.nii.gz -f s5519_w3_T1_GR_FP.nii.gz -f s5519_w3_T2_GR_F
P.nii.gz
```

Only the recon-all -all pipelines are run, the longitudinal are skipped

#### Run longitudinal workflows only

Specify the `-l` flag with `fresh`. Leave the other settings, such as the `#SBATCH` directives, etc, as is.

E.g.
```
fresh -l -f s5519_w1_T1_GR_FP.nii.gz -f s5519_w1_T2_GR_FP.nii.gz -f s5519_w2_T1_GR_FP.nii.gz -f s5519_w2_T2_GR_FP.nii.gz -f s5519_w3_T1_GR_FP.nii.gz -f s5519_w3_T2_GR_F
P.nii.gz
```

Only the longitudinal pipelines are run, the recon-all -all are skipped.

## frwap

Simple, interactive, wrapper for running fresh on the contents of a directory.

It will look for the relevant file types in a supplied directory and submit them all to the queue for you.

### fwrap flags

* `-d` `<directory>` directory to work in, defaults to current working directory if not specified
* `-f` `<file signifier>` file signifier, defaults to GR_FP.nii.gz if not set
* `-s` `<subject id>` Subject ID, optional. If not specified processes for all subject id's it finds
* `-e` `<email address>, optional, the queue will send emails to this address`
* `-v` verbose mode"

### fwrap usage

Firstly, load the module: `module load apps fresh`

To just work in the current directory: `fwrap` and it will guide you through the process.

Specify a different directory: `fwrap -d /path/to/directory`

Specify a certain Subject ID so other Subject ID's will be ignored: `fwrap -s 1234`

Specify an email address to receive notifications from slurm about the job: `fwrap -e user@email.com`

First you will be asked to choose one from the following:
1. All steps
2. The `recon-all -all` pre-processing steps only
3. The longitudinal steps only

Specify 1, 2 or 3 as appropriate.

Next you will be asked to confirm if the generated submission is correct or not. If it is press `y` and it will be submitted to be processed or `n` if there is a problem with it and the submission will be cancelled.

Here is an example:
```
$ fwrap
Directory to work on = /projects/test5
The file signifier, (pattern used to signify a file is one fresh should be run on), = GR_FP.nii.gz
(If set) Subject ID:  (if blank none specified)

Choose one of the following
1 - do all steps, i.e. recon-all -all pre-processing & longitudinal steps
2 - do only the recon-all -all pre-processing steps
3 - do only the longitudinal steps
Choose (1, 2 or 3)? 1
Doing all steps
Here is the generated submission file:

#!/bin/sh
#SBATCH -N 1
#SBATCH -p compute
#SBATCH -J "fresh"
#SBATCH -t 4-00:00:00

cd /projects/test5

module load apps fresh

fresh -f s5519_w1_T1_GR_FP.nii.gz -f s5519_w1_T2_GR_FP.nii.gz -f s5519_w2_T1_GR_FP.nii.gz -f s5519_w2_T2_GR_FP.nii.gz -f s5519_w3_T1_GR_FP.nii.gz -f s5519_w3_T2_GR_FP.n
ii.gz

Is that correct? (y/n)? y
submitting /projects/test5/sbatch.sh to the queue
Submitted batch job 292646
```

## Installation

**Note**: fresh is already installed on some of the TCHPC clusters so there is no need to install it if you are using Lonsdale or Kelvin. To use fresh on those systems load the relevant module with: `module load apps fresh`.

If you are installing fresh on another system it should just be a matter of downloading it from github and ensuring your path knows where to look for it.

1. Download fresh
```
$ git clone https://github.com/smcgrat/fresh.git
```

2. Add the `fresh` script to your path. you could add `alias fresh="/path/to/fresh"` to your `.bashrc` file.

### Installation of a specific version of fresh

This is a working repo and is subject to change. There will be a catalog of commit's for known working versions of fresh.

1. Dec 03, 2019 - first working known good version: `$ git checkout b6b0b9545cbb10e3334388a80d04666742da4e60`
2. Aug 10, 2020 - next working known good version: `$ git checkout b6b0b9545cbb10e3334388a80d04666742da4e60`

## File naming convention assumptions

`fresh` requires consistency in file naming to operate. If the files it receives are not named as it expects it may fail.

The first rule of this convention, underscores to be used as the separator.

The components of the file name convention are:

1. Subject ID
2. Wave
3. Resampling, i.e. `_RS`, if done.

This leads to following structure example: `subjectID_wave_RS`.


```
                _ _   _             
               (_) | (_)            
   _____  _____ _| |_ _ _ __   __ _
  / _ \ \/ / __| | __| | '_ \ / _` |
 |  __/>  < (__| | |_| | | | | (_| |
  \___/_/\_\___|_|\__|_|_| |_|\__, |
                               __/ |
                              |___/
```
