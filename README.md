# fresh

Bash scripting to automate FreeSurfer usage.

## File naming convention assumptions ##

`fresh` requires consistency in file naming to operate. If the files it receives are named as it expects it will fail.

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
