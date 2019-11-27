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
	-d <Directory where subject data is located>
			[if not specified assumes current directory]
	-f <NII file to work on>
			(multiple instances of this flag possible)
	-w <wave/time_series>
			(multiple instances of this flag possible)
	-k [If this flag is used the recon-all -all pipelines are skipped]
	-l [If this flag is used the longitudinal pipelines are skipped]
	-r [If this flag is used the data has NOT been resampled]
	-n <number of processor cores to work with for parallel pipelines>
			[if not set defaults to slurm setting]
	-a <afni input file>
	-z <afni output file>
	-p [If this flag is passed ONLY the reconan-all -i steps will be done]
			[No other pipelines will be carried out]
			[And this only works on one file and time series / wave at a time]
	-c <specify output file for mri_convert to convert -f reference to>
	-u [Print this help message]
	-h [Print this help message]
```

## Example Usage

```
fresh -s 000019031295 -w w1 -f 000019031295_w1.nii
```

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
