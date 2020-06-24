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
#SBATCH -U Project Code ## update this
#SBATCH -t 4-00:00:00

module load apps fresh

fresh -s 00000000001 -f 00000000001_w1.nii -w w1 -f 00000000001_w2.nii -w w2 -f 00000000001_w3.nii -w w3
```

This runs all the pre-processing, `recon-all -all` and longitudinal steps for the 00000000001 subject ID on 3 input files, 00000000001_w2.nii, 00000000001_w2.nii and 00000000001_w3.nii, for 3 corresponding time series, w1, w2 and w3.

#### Run reccon-all -all workflows only

Specify the `-r` flag with `fresh`, e.g.

```
#!/bin/sh
#SBATCH -N 1
#SBATCH -p compute
#SBATCH -J "fresh"
#SBATCH -U Project Code ## update this
#SBATCH -t 4-00:00:00

module load apps fresh

fresh -s 00000000001 -r -f 00000000001_w1.nii -w w1 -f 00000000001_w2.nii -w w2 -f 00000000001_w3.nii -w w3
```

Only the recon-all -all pipelines are run, the longitudinal are skipped

#### Run longitudinal workflows only

Specify the `-l` flag with `fresh`, e.g.

```
#!/bin/sh
#SBATCH -N 1
#SBATCH -p compute
#SBATCH -J "fresh"
#SBATCH -U Project Code ## update this
#SBATCH -t 4-00:00:00

module load apps fresh

fresh -s 00000000001 -l -f 00000000001_w1.nii -w w1 -f 00000000001_w2.nii -w w2 -f 00000000001_w3.nii -w w3
```

Only the longitudinal pipelines are run, the recon-all -all are skipped.

## Installation

1. Download fresh
```
$ git clone https://github.com/smcgrat/fresh.git
```

2. Add the `fresh` script to your path. E.g. add `alias fresh="/path/to/fresh"` to your `.bashrc` file.

### Installation of a specific version of fresh

This is a working repo and is subject to change. There will be a catalog of commit's for known working versions of fresh.

1. Dec 03, 2019 - first working known good version: `$ git checkout b6b0b9545cbb10e3334388a80d04666742da4e60`

## Associating a file with its corresponding time series or wave reference

When doing the `recon-all -i ...` step `fresh` is working on multiple files, each with its own corresponding time series or wave reference. The way `fresh` associates these two elements together is _very_ naive. It assumes the order it receives them in is the order of association. E.g.
```
fresh -f file1 -w w1 -f file2 -w w2 -f file3 -w w3 ...
```
Which maps as follows:

| file | time series point |
| --- | --- |
| file1 | w1 |
| file2 | w2 |
| file3 | w3 |

If these are not supplied in this order the wrong file will be associated with the wrong time series point.

The following should also work though:
```
fresh -f file1 -f file2 -w w1 -w w2 ...
```

The `do_recon_all_prefix` function in `fresh` which does the `recon-all -i ...` step iterates through one array, (the files one), to get its corresponding item in a second array (waves/ time series points). Thus how the order is achieved.

## File naming convention assumptions

`fresh` requires consistency in file naming to operate. If the files it receives are not named as it expects it may fail.

The first rule of this convention, underscores to be used as the separator.

The components of the file name convention are:

1. Subject ID
2. Wave
3. Resampling, i.e. `_rs`

This leads to following structure example: `subjectID_resampled_wave`.

If data has not been re-sampled `fresh` must be explicitly informed of this:
```
$ fresh -n ...
```

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
