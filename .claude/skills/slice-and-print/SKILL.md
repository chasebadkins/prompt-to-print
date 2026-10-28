---
name: slice-and-print
description: Slice an STL with SuperSlicer (PLA or ABS settings) and send the G-code to a Klipper printer (voron-v24.local or voron-v01.local). Use whenever an STL has just been generated or exported and the user wants it sliced, uploaded, or printed.
argument-hint: "[path-to-stl] [PLA|ABS] [voron-v24.local|voron-v01.local] [upload|print]"
allowed-tools: Bash(${CLAUDE_SKILL_DIR}/slice-and-print.cmd *)
---

Slice and send an STL to the printer.

SuperSlicer may be on the system PATH: the script runs
`superslicer_console.exe` by name, so don't search for it or pass a full
path. If the script reports that the command isn't found, run
`where superslicer_console.exe` and tell the user it needs to be on PATH.

1. Find the STL. Use the path in $ARGUMENTS if given; otherwise use the STL
   produced by the most recent step. Confirm the file exists.
2. Choose the material: `PLA` or `ABS`, from $ARGUMENTS or the user's
   instructions. This picks `superslicerconfig-PLA.ini` or
   `superslicerconfig-ABS.ini`. If the user hasn't said which, ask before
   slicing; don't guess.
3. Choose the printer: `voron-v24.local` or `voron-v01.local`, from
   $ARGUMENTS or the user's instructions ("v24" or "v01" means the matching
   host). If the user hasn't said which, ask before slicing; don't guess.
4. Choose the mode. Use `print` only if the user explicitly asked to print
   it in this request. Otherwise use `upload`, then ask whether to start
   the print.
5. Run:
   "${CLAUDE_SKILL_DIR}/slice-and-print.cmd" "<full path to stl>" <PLA|ABS> <host> <mode>
6. Report the material, the printer, the G-code path and whether it
   uploaded or started printing. If it fails, show the command's output;
   don't retry with different settings or edit the superslicerconfig-*.ini
   files.
