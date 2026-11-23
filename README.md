# GoPro helmet cage

Parametric OpenSCAD camera mount for a skydiving helmet (Cookie Fuel). It is a cage that holds the camera, on a wedge
that bolts into the helmet's mount recess. It was built to replace an existing Hero 8 mount and to carry a larger
camera (Hero 11/12/13 body) later without moving where the lens sits.

All dimensions are in mm.

## Using it
1. Open `gopro_cage.scad` in OpenSCAD.
2. Set `PART` at the top of the file.
3. Render (F6) and export. 3MF is preferred: the STL export rounds coordinates and can leave non-manifold edges.

## Parts
**Printable parts**

| `PART` | What it is |
|---|---|
| `combo8` / `combo13` | **Main part.** Cage and wedge as one piece: no cage screws, with a hair-tie retention groove. Hero 8 / Hero 13 size. |
| `nutplate` | Plate inside the helmet that holds the 4 M3 nylocs for the helmet bolts. Needs a print pause (see below). |
| `cage8` / `cage13` | Cage on its own, for the two-piece version. |
| `wedge` | Wedge on its own, for the two-piece version. Its M4 nylocs are trapped inside during the print. |

**Fit tests**

| `PART` | What it is |
|---|---|
| `combo8_fit` | Thin helmet-side skin of the combo (plate, toe and pad). Quick check against the helmet before the full print. |
| `wedge_plate`, `wedge_outline` | Base plate only, or just its outline rim, to check fit in the recess. |
| `backplate8`, `padtest8`, `padtest_set` | Back of the cage and pad variants, for quick fit iterations. |
| `curve_gauges` | Labelled curve strips for measuring the helmet's dome. |
| `hero8_dummy`, `hero13_dummy` | Stand-in cameras for test fits. |

**Previews and checks** (not for printing)

| `PART` | What it is |
|---|---|
| `preview8` / `preview13` | Cage with a dummy camera. |
| `fit8`, `fit8_clash`, `fit8_sec` | Cage bolted to the wedge, their overlap, and a side slice. |
| `combo8_sec`, `combo8_extra`, `combo8_less` | Combo side slice, and the material added or removed compared with the two-piece version. |
| `helmet8`, `fit8_helmet` | The helmet shape the parts imply. |

## Hardware
**Combo version**
- 4 × M3 bolts into the helmet, with nylocs held in the nut plate.
- One hair tie (about 3.3 mm cord). It wraps around the cage and camera:
  - through the groove across the back pad, which closes when the part is bolted down;
  - along both side walls and the front recess;
  - into the hook.

**Two-piece version**
- The same M3 bolts and nut plate.
- 2 × M4 × 20 screws from the cage into the wedge, with M4 nylocs trapped inside the wedge.

## Printing (Bambu A1 mini; PLA for fit tests, PETG for final parts)
**`combo8` / `combo13`**
- Print standing on the cage's closed side. That face is flat on purpose.
- Tree supports, on build plate only, with "Support critical regions only" OFF.
- Outer brim only, about 5 mm.
- The helmet bolt holes are teardrop-shaped so they stay round when printed on their side.

**`nutplate`**
- Add a pause at the layer OpenSCAD reports in the console. Drop the nylocs in, then resume.

**`wedge`**
- Print standing on its front face.
- If `w_nut_trap = true`, pause at the layer reported in the console and insert the M4 nylocs.

## Settings worth knowing
| Setting | What it does |
|---|---|
| `H8`, `H13` | Camera sizes. The Hero 13 lens size, lens position and button position are **estimates**; check them with calipers before a final Hero 13 (or Hero 11) print. |
| `w_bolt_dx_f`, `w_bolt_dx_b`, `w_bolt_dy` | Helmet hole pattern (59.5 / 66 / 45.5). |
| `w_hole_dx_b_extra` | Moves the back holes apart. Currently +0.5 mm, from fit testing. |
| `w_dome_rx`, `w_dome_ry` | Curvature of the helmet dome under the plate. |
| `w_toe_*` | The lifted toe at the front of the recess. |
| `w_lip_on`, `w_plate_back_extra` | An edge lip and a longer plate back, copied from another plate design. Both are **off**, because they made the fit worse. |
| `engrave_lines`, `engrave_top`, `engrave_bottom` | Text on the front, top and bottom. **Change these to your own details.** |

## Folders
- `stl/`: exported drafts of each part, kept as a print history. The highest draft number is the latest.
- `stl/ref/`: reference models from other designers. Ignored by git, so it isn't in this repo.
