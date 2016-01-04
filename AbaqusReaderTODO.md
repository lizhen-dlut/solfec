TODO list for the `AbaqusReader` package in /scripts

Moved from /scripts/abaqusreader/TODO.txt to get it out of the repo.

  * Add checks (e.g. to part creation, #248) so that names which are the same once uppercased don't overwrite existing names
  * Add support for part-level element sets (have experimental ver to do this, needs surfid support adding)
  * Provide better access to nodes/elements/surfids to support element deletion etc.
  * Add more checking for Abaqus parameters it can't handle
  * Add parameter to init() to control verbosity/mode of output
  * Add support for automatically uncompressing .zip or .bz2 files
  * Use warnings module for warnings (but need to see how it works in parallel)
  * Refactor so its tidier