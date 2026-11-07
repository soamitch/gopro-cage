# GoPro helmet cage

Parametric OpenSCAD cage for a skydiving helmet camera mount.
Goal: move from a GoPro Hero 8 to a Hero 13 without changing where the lens sits relative to the helmet.

## Files
- `gopro_cage.scad` - the model. Set `PART` at the top, then Render (F6) and export STL.
  - `hero8_dummy` / `hero13_dummy` - fake cameras for fit tests
  - `cage8` - cage that reproduces the existing Hero 8 mount
  - `backplate8` - back plate only, for quick fit iterations
  - `cage13` - Hero 13 cage (lens size, bump and position are still guesses)
  - `preview8` / `preview13` - cage plus red dummy camera, for cross-section views
- `stl/hero8-dummy/` - Hero 8 dummy prints (draft 1-3)
- `stl/cage8/` - Hero 8 cage prints (draft 1-4)
- `stl/backplate8/` - back plate prints

## Workflow
Dummy camera -> cage8 (validates the model against the real mount) -> dummy 13 -> cage13.
PLA for fit tests, PETG for the final print (Bambu A1 mini).

## Print orientation
The cage stands on its closed left wall with the pocket opening up; the back plate prints face down.
