// GoPro helmet cage + dummy cameras (parametric, all units mm)
// Pick what to export with PART, then Render (F6) and Export STL.
//   "hero8_dummy"  - fake Hero 8, to calibrate against your current mount
//   "hero13_dummy" - fake Hero 13, to test the new cage
//   "cage8"        - cage for the real Hero 8 (should reproduce your current mount: use it to validate the model)
//   "cage13"       - cage for the Hero 13, lens held in the SAME place relative to the helmet as the Hero 8
//   "backplate8"   - back plate only (quick fit iterations)
//   "padtest_set"  - three pad variants (A/B/C) on one plate, to compare fits in one print
//   "padtest8"     - just the ledge + curved pad of the back plate (fastest fit test)
//   "preview8" / "preview13" - cage + red dummy together (use a cross-section view to inspect)
//   "wedge"        - the helmet wedge (piece between the helmet and the cage), helmet side down
//   "wedge_plate"  - just the wedge's domed base plate with its 4 holes (quick fit test on the helmet)
//   "wedge_outline" - just a 4 mm rim of the part of the plate that sits in the recess + holes (quick fit check)
//   "curve_gauges" - labelled strips with different curves, to measure the helmet in the recess (S = side to side, F = front to back)
//   "fit8" / "fit8_clash" - cage8 bolted to the wedge (preview) / their overlap (should be empty)
//   "nutplate"     - the plate inside the helmet that holds the 4 M3 nylocs (pause-and-insert, see np_pause_z)
//   "fit8_sec"    - a 1 mm slice through cage8 bolted to the wedge at x = fit_sec_x (side view of the contact)
//   "helmet8" / "fit8_helmet" - the helmet shape implied by the wedge underside + cage pad / everything together (preview)
PART = "cage8";

$fn = 48;

// ---------- Camera specs (body incl. lens bump) ----------
// [width X, height Z, depth Y, corner radius, lens square, lens bump, lens CENTER x from the screen edge, screen w, screen h]
// (lens sits on the right when viewed from the front, flush with the top and right edges)
H8  = [66.44, 48.06, 28.5, 5, 33.7, 4.0, 49.6, 20, 20];   // your caliper numbers
H13 = [71.8, 50.8, 33.6, 5, 29, 4.0, 57.3, 20, 20];       // published 71.8 x 50.8 x 33.6; lens size/bump/position are GUESSES - verify

// ---------- Fit ----------
clear        = 0.4;   // clearance per side around the camera (width and height)
clear_y      = 0.5;   // extra pocket depth behind the lens bump
edge_chamfer = 0.8;   // dummy only: chamfer on the back edge

// ---------- Cage walls (measured on your current mount) ----------
wall_l   = 2.5;    // left (closed) wall
top_t    = 4;      // top wall; thinned over the button, see below
bottom_t = 3;      // bottom lip
front_t  = 2.5;    // front lip thickness - NOT MEASURED YET
back_t   = 4;      // minimum back wall: the thinnest point of the back is 4 mm behind the pocket floor
overhang = 0.2;    // how far the camera hangs out of the open side (held by the cord). The cage keeps its 69.14 mm outer width
                   // (screws stay put) while the closed wall thins 4 -> 2.5, so the camera sits 1.5 mm deeper: 1.7 - 1.5 = 0.2

// shutter button: a window through the top wall, plus a channel in the ceiling (wall thins from 4 to 2.45)
// running from the window out to the open side, so the button can slide in with the camera
btn_w = 16.5;            // window width (along X)
btn_d = 16.85;           // window depth (along Y, front to back)
btn_from_closed = 12.5;  // outer face of the closed (screen-side) wall to the window's near edge
btn_from_front  = 8.45;  // outer front face to the window's near edge
btn_h = 1.55;            // channel depth into the top wall
// The window/channel position is kept relative to the camera, so on the Hero 13 it is a PLACEHOLDER - verify the real button position

// screen window (outside-edge measurements on your mount)
scr_w = 21.2;  scr_h = 27.6;
scr_from_left_outer   = 9.4;     // from the cage's outer left edge
scr_from_bottom_outer = 18;      // from the cage's outer bottom edge
outer_h8 = 55.9;                 // measured outer height of the Hero 8 cage

// lens window: housing + 0.3, flush with the pocket ceiling, open to the right side
lens_clear = 0.3;

// PLACEHOLDERS (not measured yet): window through the left wall, cord hole
lw_z0 = 8;  lw_z1 = 8;  lw_y0 = 4;  lw_y1 = 6;

// elastic (hair tie) slot: a round hole (measured on the original) running along X through the back wall, just behind the
// pocket floor; at the open side the floor over the hole is cut away (hole width) so the tie touches the camera there.
cord_slot = false;   // hair-tie slot through the back of the cage (false: the tie is clamped in the wedge's ht_ groove instead)
cord_slot_w = 6;     // slot height (the original's hole is 3 mm round; made taller so the hair tie threads easily)
cord_slot_t0 = 3;    // slot thickness, front to back, everywhere (as the original)
cord_slot_t = 4.5;   // ... grown toward the back to this wherever the back has room (cord_wall behind it); 3 was hard to thread
cord_floor = 1.3;    // thinnest plastic between the pocket floor and the hole (measured 1.3)
cord_y0 = -(cord_floor + cord_slot_t0 / 2);  // centre of the 3 mm core, behind the pocket floor (y = 0 is the floor)
cord_y = -(cord_floor + cord_slot_t / 2);    // centre of the full-size slot (same front face, cord_floor from the camera)
cord_edge_from_top = 38.7 - (cord_slot_w - 3);   // top edge: the original's 3 mm hole had its top edge 38.7 from the top;
                             // the taller slot keeps that hole's BOTTOM edge and grows upward (lower down the pad is too thin)
cord_from_top = cord_edge_from_top + cord_slot_w / 2;   // ... to the hole centre
cord_notch_l = 3;    // open-side cutout: no plastic between the hole and the camera for this far in from the open side (measured ~3)
cord_wall = 0.8;     // minimum plastic kept between the hole and the pad surface
// elastic hook: a small block on the front face at the open end, bottom corner, with a channel along X that is OPEN at the
// bottom (drop the tie in from below)
hook_x_len = 17.6;  hook_out = 5.4;  hook_h = 4;  hook_r = 1.5;  hook_chamfer = 1.5;   // hook height (its top is flush with the bottom of the lens window); hook_r rounds its edges
rec_d = 1.5;        // depth of the hair-tie recess in the front face (the front wall is 2.5 mm)
// engraving: front face (below the hair-tie recess) and top face (beside the shutter-button window)
engrave_lines = ["Skydive Kapowsin"];   // front face, one entry per line
engrave_size  = 4.5;    // front letter size
engrave_pitch = 5.5;    // front line spacing
engrave_top      = "Mitch Henrie";      // top face ("" for none); reads with the front edge toward you
engrave_top_size = 4.5;
engrave_bottom      = "801-786-9255";  // bottom face ("" for none); reads with the front edge toward you, like the top
engrave_bottom_size = 4.5;
engrave_d     = 0.6;    // depth
engrave_font  = "Liberation Sans:style=Bold";
hook_flare = 1.2;   // the channel mouth at the bottom is flared by this much per side
hook_eye_w = 2.5;  hook_eye_t = 3.4;   // channel height (open at the bottom, 1.5 mm roof left above it) and width
module stadium_x(w, t, len) {   // stadium cross-section (w along Z, t along Y) extruded along +X
    hull() for (dz = [-(w - t) / 2, (w - t) / 2]) translate([0, 0, dz]) rotate([0, 90, 0]) cylinder(d = t, h = len, $fn = 24);
}

// ---------- Mount interface (fixed by the helmet wedge - same for every camera) ----------
// Anchor frame: origin on the RIGHT screw axis; X toward the open side; Y = 0 on the pocket's back face; Z up
screw_edge_hole = 13;     // side of the cage to the nearest EDGE of each screw hole (measured with calipers)
screw_d        = 4.6;     // through hole (4.56 measured)
screw_edge     = screw_edge_hole + screw_d / 2;   // side of the cage to the screw AXIS (15.3)
cage_w8        = H8[0] + clear + wall_l - overhang;   // outer width of the Hero 8 cage (69.14)
screw_dx       = cage_w8 - 2 * screw_edge;            // centre-to-centre spacing (38.54)
// (the frame origin is a fixed reference point 13 mm in from the open side; it is no longer on a screw axis)
screw_xs       = [13 - screw_edge, 13 - cage_w8 + screw_edge];   // x of the two screw axes
csk_d          = 8.7;     // countersink diameter on the pocket side
csk_h          = (csk_d - screw_d) / 2;   // 90 degree countersink
csk_extra      = 0.5;     // the whole countersink sits this much deeper, so the heads end up below the pocket floor (+ back_extra)
screw_from_top = 13;      // screw axis is this far below the top face of the cage
floor_to_screw = 2 * clear + H8[1] + top_t - screw_from_top;   // screw axis height above the Hero 8 pocket floor (derived)
open_to_screw  = 13;      // frame origin to the open side (fixed reference; do not change, the cage is built around it)

// ---------- Back of the cage (mates with the helmet wedge) ----------
// SIDE PROFILE (re-traced from the photo of your original cage, good to about +-1 mm).
// Entries are [depth from the outside front face, height below the top face].
pad_h  = 25.5;               // height of the curved pad (measured)
z_step = outer_h8 - pad_h;   // the pad starts this far below the top face (30.4)

// CURVE ACROSS THE WIDTH (the pad is concave so it sits on the forehead of the helmet).
// Depths from the outside front face, measured on your original:
pad_top_corner = 40.5;    // top of the pad, at the two outer corners
pad_top_center = 35.3;    // top of the pad, in the middle
pad_bot_corner = 36.0;   // bottom of the pad, at the corners
pad_bot_center = 31.0;   // bottom of the pad, in the middle

// pad outline at the CORNERS: [offset below z_step, depth from the front]. The curve across the width is cut into this.
// BACK PANEL (the screw panel): a ramp from the thinnest point (4 mm behind the pocket floor) down to 7.4 mm behind it
tri_h        = 10;     // height of the triangular tab at the top (tip to where its underside meets the panel)
thin_t       = 4;      // back wall thickness at the thinnest point
panel_gap_fix = 0;     // REVERTED (1.4 made the screws stop lining up). Was: bottom of the panel stood 1.4-1.7 mm off the wedge,
                       // so the ramp gets steeper (this much thicker at its bottom, ~1.55 mm more at the ledge)
panel_t      = 7.4 + panel_gap_fix;    // back wall thickness at the bottom of the ramp (7.4 measured on the original)
panel_base   = 18.5;   // vertical length of the ramp
pad_lip_h  = 4;       // height of the piece between the ledge's outer corner and the thickest point of the curve
pad_ledge_h = 1.0;    // the ledge itself drops this much as it runs back (measured: 7.5 -> 11.5 mm thick in about 1 mm)
pad_bulge_o = pad_ledge_h + pad_lip_h;   // height of the thickest point (13 mm) below the top of the ledge
pad_floor_depth = front_t + (H8[2] - H8[5]) + clear_y;   // outside front face to pocket floor (27.5)
// the ramp keeps sloping all the way down to the ledge (no vertical piece at its foot, like the original)
ramp_end_depth = pad_floor_depth + thin_t + (panel_t - thin_t) * (z_step - tri_h) / panel_base;   // ~35.25
pad_corner = [[0, ramp_end_depth],   // foot of the ramp, at the top of the ledge ...
              [pad_ledge_h, 39.0],      // ... then the ledge runs back to 11.5 mm thick (39.0 from the front) ...
              [pad_bulge_o, pad_top_corner],   // ... and slopes out to the thickest point, 13 mm (40.5), pad_lip_h lower
              [10.1, 39.4],
              [14.8, 38.4],
              [18.8, 37.5],
              [23.8, 36.4],
              [pad_h, pad_bot_corner]]; // bottom edge

// $pc is the pad profile in use. The default is variant B from the fit test (it fitted best): a mild S-shape along the pad
// (upper part bulges toward the helmet, lower part pulls back) and a slightly concave piece between the ledge and the curve.
pad_S_amp       = 0.8;   // S-shape amplitude, mm
pad_lip_concave = 0.5;   // how far the middle of the lip is pulled back, mm
$pc = variant_corner(pad_S_amp, pad_lip_concave);

tab_tip = [45.85, 0];   // tip of the top tab, flush with the top face (45.85 from the front, measured)
tab_tip_r = 0;          // tip rounding radius. 0 = sharp point, so the cage top runs flush onto the wedge (1.0 cut the tip ~3 mm short)
tab_drop = 0;           // REVERTED (was 2.0): the tab's underside is lowered this much (the tab stood 1.8-2.2 mm off the wedge's top with the screws tight)
// rounds the corner p (between neighbours pa and pb) with radius r; returns the arc as points (2D)
function fillet(p, pa, pb, r, n = 6) = let(
        a = (pa - p) / norm(pa - p), b = (pb - p) / norm(pb - p),
        th = acos(a * b), m = (a + b) / norm(a + b),
        c = p + m * r / sin(th / 2),
        ta = p + a * r / tan(th / 2), tb = p + b * r / tan(th / 2),
        a0 = atan2(ta[1] - c[1], ta[0] - c[0]), a1 = atan2(tb[1] - c[1], tb[0] - c[0]),
        da = a1 - a0 > 180 ? a1 - a0 - 360 : a1 - a0 < -180 ? a1 - a0 + 360 : a1 - a0)
    [for (k = [0 : n]) c + r * [cos(a0 + da * k / n), sin(a0 + da * k / n)]];
// where the (lowered) underside of the tab meets the screw panel ramp
function tab_junction() = let(
        T = [pad_floor_depth + thin_t, tri_h], F = [ramp_end_depth, z_step],
        P = tab_tip + [0, tab_drop], u = T - tab_tip, v = F - T,
        det = u[0] * (-v[1]) - u[1] * (-v[0]),
        t = ((T - P)[0] * (-v[1]) - (T - P)[1] * (-v[0])) / det)
    P + t * u;
// tab outline, [depth, height below top]: top-back corner and lower-back corner rounded, then down the underside to the panel
function tab_pts() = let(J = tab_junction(), P0 = tab_tip, P1 = tab_tip + [0, tab_drop])
    tab_tip_r < 0.01 ? (tab_drop < 0.05 ? [P0, J] : [P0, P1, J])
                    : tab_drop < 0.05 ? concat(fillet(P0, [0, 0], J, tab_tip_r, 8), [J])
                    : concat(fillet(P0, [0, 0], P1, tab_tip_r), fillet(P1, P0, J, tab_tip_r), [J]);
function make_prof() = concat(
    tab_pts(),                             // tab, ending where its underside meets the screw panel
    [for (q = $pc) [q[1], z_step + q[0]]]);

// ---------- Derived: where the lens sits (fixed relative to the helmet) ----------
x_open8     = open_to_screw;
lens_cx_ref = x_open8 + overhang - (H8[0] - H8[6]);   // lens centre x, held fixed for every camera
z_top8      = -floor_to_screw + clear + H8[1];
lens_cz_ref = z_top8 - H8[4] / 2;                    // lens centre z, held fixed for every camera

// Reference geometry of the Hero 8 cage (the back interface is defined against this and never moves)
// back_extra: the back wall is this much thicker behind the camera. The back (pad, screw panel, tab) stays exactly where it was
// on the wedge and helmet; the pocket and the camera move back_extra further out, and the screw heads sit back_extra deeper.
back_extra = 0;   // (2 gave the through-slot room; not needed with the wedge groove)
ref_front_to_floor = front_t + (H8[2] - H8[5]) + clear_y - back_extra;   // outside front face (of the original) to pocket floor
ref_top    = z_top8 + clear + top_t;                          // outer top
ref_bottom = -floor_to_screw - bottom_t;                      // outer bottom
ix0        = cx1b(H8) - H8[0] - clear - wall_l;               // outer closed (left) edge of the Hero 8 cage

// Where the camera sits along the mount (X). With center_on_mount the cage is centred on the helmet piece (the Hero 8 cage
// footprint); a wider camera then overhangs equally on both sides and its lens moves a little (Hero 13: about 5 mm toward
// the open side). Set it to false to hold every camera's lens exactly where the Hero 8's is. cam_shift_extra nudges it further.
center_on_mount = true;
cam_shift_extra = 0;
function cx1b(c) = lens_cx_ref + (c[0] - c[6]);   // camera right edge with the lens held at the Hero 8 position
function cam_shift(c) = (center_on_mount
        ? (ix0 + x_open8) / 2 - ((cx1b(c) - c[0] - clear - wall_l) + (cx1b(c) - overhang)) / 2
        : 0) + cam_shift_extra;
function cx1(c) = cx1b(c) + cam_shift(c);         // camera right edge
function cx0(c) = cx1(c) - c[0];                 // camera left edge
function cz1(c) = lens_cz_ref + c[4] / 2;        // camera top (lens flush with the top)
function cz0(c) = cz1(c) - c[1];                 // camera bottom

module rbox(w, h, d, r) {      // rounded box: x 0..w, z 0..h, y 0..d
    hull() for (x = [r, w - r], z = [r, h - r])
        translate([x, 0, z]) rotate([-90, 0, 0]) cylinder(r = r, h = d);
}

// Envelope that rounds the outside of the cage: corner_r on the four corners seen from the front (through the whole depth, so the
// back pad gets the same corners) and edge_r on the edges around the front face. The open side gets the same rounding.
edge_r = 1.5;  corner_r = 3;
mouth_ch = 0.8;   // chamfer around the camera opening on the open side
module envelope(x0, x1, z0, z1, yf) {
    hull() for (x = [x0 + corner_r, x1 - corner_r], z = [z0 + corner_r, z1 - corner_r])
        translate([x, 0, z]) rotate([-90, 0, 0]) {
            translate([0, 0, -100]) cylinder(r = corner_r, h = 100 + yf - edge_r);
            translate([0, 0, yf - edge_r]) rotate_extrude($fn = 32) translate([corner_r - edge_r, 0]) circle(r = edge_r, $fn = 16);
        }
}

module dbody(w, h, d, r, f) {   // rounded box with a chamfered back edge
    hull() {
        translate([f, 0, f]) rbox(w - 2*f, h - 2*f, 0.01, max(r - f, 0.5));
        translate([0, f, 0]) rbox(w, h, d - f, r);
    }
}

module dummy(c) {
    w = c[0]; h = c[1]; d = c[2]; r = c[3];
    ls = c[4]; lb = c[5]; lx = c[6]; sw = c[7]; sh = c[8];
    body_d = d - lb;
    difference() {
        union() {
            dbody(w, h, body_d, r, edge_chamfer);
            // lens housing bump
            translate([lx - ls/2, body_d - 0.01, h - ls])
                rbox(ls, ls, lb + 0.01, 4);
        }
        // front screen recess on the left of the lens
        translate([6, body_d - 0.8, h - sh - 8]) cube([sw, 1, sh]);
        // lens recess
        translate([lx - ls/2 + 4, d - 1, h - ls + 4]) cube([ls - 8, 2, ls - 8]);
    }
}

// Depth of the pad's surface in the CENTRE, by height below z_step: 36 right from the top edge of the pad
// (so there is no lip above the curve), easing to 31.5 at the bottom
function pad_base_center(o) = o <= pad_bulge_o ? pad_top_center
                            : pad_top_center + (pad_bot_center - pad_top_center) * (o - pad_bulge_o) / (pad_h - pad_bulge_o);
// Sag (corner depth minus centre depth) at entry i of pad_corner; never negative
// Contour-gauge correction (original vs cage8 draft): the DRAFT bulges out more than the original in the middle of the pad,
// about 1.5 mm at the screw holes and a bit more in the centre, peaking on the convex part of the curve, fading out toward the bottom edge.
// Applied through the sag (corners unchanged): the centre changes by pad_fill * pad_fill_f(o), the screw holes ~0.7 of that.
// Positive pad_fill adds material, negative removes it.
pad_fill = -2.0;
// Zero for the top 3 mm below the ledge, full on the convex part (8-14 mm below the ledge), fading out at the bottom edge.
// The hair-tie slot sits just behind that part; the cut never comes closer to it than cord_wall.
function pad_fill_f(o) = lookup(o, [[0, 0], [3, 0], [pad_bulge_o, 0.4], [8, 1], [14, 1], [18.8, 0.5], [pad_h, 0]]);
function pad_s(i) = max(0, (len($pc[i]) > 2 ? $pc[i][2] : i < 1 ? 0 : max(0, $pc[i][1] - pad_base_center($pc[i][0])))
                           - pad_fill * pad_fill_f($pc[i][0]));   // entry 0 is the ramp above the ledge: no sag there

// Outline (in the X-Y plane) of everything BEHIND the pad's curved surface at one height.
// dc = depth at the corners, s = sag, so the centre is s closer to the front. The curve is a circular arc.
function pad_slice_pts(dc, s) =
    let(hw = (x_open8 - ix0) / 2,
        xc = (ix0 + x_open8) / 2,
        yc = ref_front_to_floor - (dc - s),                     // y of the surface in the middle
        R  = s > 0.001 ? (hw * hw + s * s) / (2 * s) : 1e9)
    concat([[ix0 - 1, -80]],
           [for (k = [0 : 24])
               let(x = ix0 + (x_open8 - ix0) * k / 24, u = x - xc)
               [x, s > 0.001 ? yc - (R - sqrt(R * R - u * u)) : yc]],
           [[x_open8 + 1, -80]]);

// Cutter that carves the concave curve into the back of the cage
module pad_cut() {
    n  = len($pc);
    zs = [for (q = $pc) ref_top - (z_step + q[0])];
    for (i = [0 : n - 2])
        hull() {
            translate([0, 0, zs[i]])     linear_extrude(height = 0.01) polygon(pad_slice_pts($pc[i][1],     pad_s(i)));
            translate([0, 0, zs[i + 1]]) linear_extrude(height = 0.01) polygon(pad_slice_pts($pc[i + 1][1], pad_s(i + 1)));
        }
    hull() {   // run past the bottom edge
        translate([0, 0, zs[n - 1]])     linear_extrude(height = 0.01) polygon(pad_slice_pts($pc[n - 1][1], pad_s(n - 1)));
        translate([0, 0, zs[n - 1] - 2]) linear_extrude(height = 0.01) polygon(pad_slice_pts($pc[n - 1][1], pad_s(n - 1)));
    }
}

// Back interface block: the side profile, extruded along X over the footprint of the Hero 8 cage
module interface(c) {
    prof = make_prof();
    n = len(prof);
    pts = concat(
        [for (i = [0 : n - 2]) [-(prof[i][0] - ref_front_to_floor), ref_top - prof[i][1]]],
        [[-(prof[n-1][0] - ref_front_to_floor), ref_bottom], [0, ref_bottom], [0, ref_top]]
    );
    // runs from the open side to the closed wall of THIS cage (for a wider camera the plate continues past the Hero 8 footprint
    // at the corner depth of the curve, so the back plate is as wide as the cage; the curve itself stays where it is)
    ixe = cx0(c) - clear - wall_l;               // closed side of THIS cage
    translate([ixe, 0, 0]) rotate([90, 0, 90])
        linear_extrude(height = (cx1(c) - overhang) - ixe) polygon(pts);   // ends flush with the open side of the cage
}

module cage(c) {
    bd  = c[2] - c[5];            // body depth without the lens bump
    pd  = bd + clear_y;           // pocket depth
    ls  = c[4];
    px0 = cx0(c) - clear;
    pz0 = cz0(c) - clear;
    pz1 = cz1(c) + clear;
    xo  = cx1(c) - overhang;      // the open side
    ox0 = px0 - wall_l;
    oz0 = pz0 - bottom_t;
    oz1 = pz1 + top_t;
    od  = back_t + pd + front_t;
    bx0 = cx0(c) + btn_from_closed - wall_l - clear;   // button window, near edge (x)
    by0 = pd + front_t - btn_from_front - btn_d;       // button window, back edge (y)
    lw_x0 = lens_cx_ref + cam_shift(c) - ls/2 - lens_clear;
    lw_z0v = cz1(c) - ls - lens_clear;

    difference() {
        union() {
            // shell (flat-cut at the open side) and back interface, with rounded corners and front edges
            intersection() {
                union() {
                    intersection() {
                        translate([ox0, -back_t, oz0]) rbox(xo - ox0 + 10, oz1 - oz0, od, corner_r);
                        translate([ox0 - 1, -back_t - 1, oz0 - 1]) cube([xo - ox0 + 1, od + 2, oz1 - oz0 + 2]);
                    }
                    interface(c);
                }
                envelope(ox0, xo, oz0, oz1, pd + front_t);   // ends at the open side, so its edges are rounded too
            }
            // elastic hook: block on the front face near the open end (eye is cut below)
            // (top flush with the bottom of the lens window, all outer edges rounded)
            // The end toward the closed wall is a 45-degree slope (like the original), so it prints without supports when the cage
            // stands on its closed wall; the end toward the open side is rounded (it narrows as it goes up, so that prints fine too).
            zb = lw_z0v - hook_h;  zt = lw_z0v;  yo = pd + front_t + hook_out;  yi = pd + front_t - 1.5;
            x0h = xo - hook_x_len - 2;                        // left (closed-wall) end of the hook
            hull() {
                // open-side end: rounded
                for (hz = [zb + hook_r, zt - hook_r], hy = [yi, yo - hook_r])
                    translate([xo - 2 - hook_r, hy, hz]) sphere(r = hook_r, $fn = 24);
                // full-size section, reached after a 45-degree wedge (hook_out long), so the hook grows out of the wall without overhangs
                for (hz = [zb + hook_r, zt - hook_r], hy = [yi, yo - hook_r])
                    translate([x0h + hook_out, hy, hz]) rotate([0, 90, 0]) cylinder(r = hook_r, h = 0.01, $fn = 24);
                // start of the wedge: flush with the front face, full height
                translate([x0h, yi, zb]) cube([0.01, pd + front_t - yi + 0.01, hook_h]);
            }
        }
        // concave curve across the back of the pad (never closer than cord_wall to the hair-tie slot)
        difference() {
            pad_cut();
            if (cord_slot) translate([ox0 - 2, cord_y0, ref_top - cord_from_top]) stadium_x(cord_slot_w + 2 * cord_wall, cord_slot_t0 + 2 * cord_wall, xo - ox0 + 14);
        }
        // camera pocket (open to the right)
        translate([px0, 0, pz0]) rbox(xo + 10 - px0, pz1 - pz0, pd, c[3] + clear);
        // eased (chamfered) mouth of the pocket on the open side
        hull() {
            translate([xo - mouth_ch, 0, pz0]) cube([0.01, pd, pz1 - pz0]);
            translate([xo + 0.01, -mouth_ch, pz0 - mouth_ch]) cube([0.01, pd + 2 * mouth_ch, pz1 - pz0 + 2 * mouth_ch]);
        }
        // shutter button: window through the top wall + channel in the ceiling out to the open side
        translate([bx0, by0, pz1 - 0.01]) cube([btn_w, btn_d, top_t + 1]);
        translate([bx0, by0, pz1 - 0.01]) cube([xo + 10 - bx0, btn_d, btn_h + 0.01]);
        // lens window: open to the right side and the ceiling of the pocket
        translate([lw_x0, pd - 1, lw_z0v]) cube([xo + 10 - lw_x0, front_t + 2, pz1 - lw_z0v]);
        // screen window
        translate([ox0 + scr_from_left_outer, pd - 1, oz0 + scr_from_bottom_outer]) cube([scr_w, front_t + 2, scr_h]);
        // PLACEHOLDER window through the left wall
        translate([ox0 - 1, lw_y0, pz0 + lw_z0]) cube([wall_l + 2, pd - lw_y0 - lw_y1, (pz1 - pz0) - lw_z0 - lw_z1]);
        if (cord_slot) {
            // elastic cord hole through the back wall, with a notch around the opening on the open side
            translate([ox0 - 1, cord_y0, ref_top - cord_from_top]) stadium_x(cord_slot_w, cord_slot_t0, xo - ox0 + 12);
            // ... grown to cord_slot_t toward the back, except where that would come closer than cord_wall to the pad's curved surface
            difference() {
                translate([ox0 - 1, cord_y, ref_top - cord_from_top]) stadium_x(cord_slot_w, cord_slot_t, xo - ox0 + 12);
                translate([0, cord_wall, 0]) pad_cut();
            }
            // flared entry on the closed side (taller at the outside face) so the tie finds the slot
            hull() {
                translate([ox0 - 1, cord_y, ref_top - cord_from_top]) stadium_x(cord_slot_w + 2, cord_slot_t + 1.5, 1.01);
                translate([ox0 + 1.2, cord_y, ref_top - cord_from_top]) stadium_x(cord_slot_w, cord_slot_t, 0.01);
            }
            translate([xo - cord_notch_l, cord_y, ref_top - cord_from_top - cord_slot_w / 2])
                cube([cord_notch_l + 10, -cord_y + 1, cord_slot_w]);
        }
        // channel of the elastic hook: its floor is the recess floor (rec_d into the front face), it runs out through the left end of
        // the hook (no wall there) and is open at the bottom, flared on the outer side
        hull() {
            translate([xo - hook_x_len - 2 - 1, pd + front_t - rec_d, lw_z0v - hook_h + 0.5])
                cube([hook_x_len + 2, hook_eye_t, hook_eye_w - 0.5]);
            translate([xo - hook_x_len - 2 - 1, pd + front_t - rec_d, lw_z0v - hook_h - 0.5])
                cube([hook_x_len + 2, hook_eye_t + 2 * hook_flare, 0.01]);
        }
        // recess for the hair tie along the front face, from the closed (left) wall to the hook, so the tie lies nearly flush
        translate([ox0 - 1, pd + front_t - rec_d, lw_z0v - hook_h - 0.5])
            cube([(xo - hook_x_len - 2) - (ox0 - 1) + 1, rec_d + 2, hook_eye_w + 0.5]);
        // engraved text on the front face, in the strip below the hair-tie recess (written un-mirrored here: the output is mirrored,
        // so it reads correctly from the front)
        let(z_lo = oz0 + edge_r + 0.5, z_hi = lw_z0v - hook_h - 0.5 - 1.2, zc = (z_lo + z_hi) / 2, n = len(engrave_lines))
            for (k = [0 : n - 1])
                translate([(ox0 + xo) / 2, pd + front_t + 0.01, zc + ((n - 1) / 2 - k) * engrave_pitch]) rotate([90, 0, 0])
                    linear_extrude(height = engrave_d + 0.01)
                        text(engrave_lines[k], size = engrave_size, font = engrave_font, halign = "center", valign = "center");
        // engraved text on the top face, centred between the button window and the open side
        if (engrave_top != "")
            translate([(bx0 + btn_w + xo) / 2, (pd + front_t - back_t) / 2, oz1 + 0.01]) rotate([180, 0, 0])
                linear_extrude(height = engrave_d + 0.01)
                    text(engrave_top, size = engrave_top_size, font = engrave_font, halign = "center", valign = "center");
        // engraved text on the bottom face, centred
        if (engrave_bottom != "")
            translate([(ox0 + xo) / 2, (pd + front_t - back_t) / 2, oz0 - 0.01]) rotate([0, 0, 180])
                linear_extrude(height = engrave_d + 0.01)
                    text(engrave_bottom, size = engrave_bottom_size, font = engrave_font, halign = "center", valign = "center");
        // countersunk screw holes (head on the pocket side)
        for (sx = screw_xs) translate([sx, 0, 0]) {
            translate([0, -40, 0]) rotate([-90, 0, 0]) cylinder(d = screw_d, h = 41);
            translate([0, -csk_h - csk_extra - back_extra, 0]) rotate([-90, 0, 0]) cylinder(d1 = screw_d, d2 = csk_d, h = csk_h + 0.01);
            translate([0, -csk_extra - back_extra - 0.01, 0]) rotate([-90, 0, 0]) cylinder(d = csk_d, h = csk_extra + back_extra + 2.01);
        }
    }
}

module assembly(c) {
    cage(c);
    color("red") translate([cx0(c), 0, cz0(c)]) dummy(c);
}

// Cage geometry is built as seen from the BACK of the camera (screen at low X, lens at high X).
// mirror() / flipx() flip it so that, viewed from the FRONT (lens side), the screen is on your left
// and the lens is on your right, like the real Hero 8/13.
module flipx(w) { translate([w, 0, 0]) mirror([1, 0, 0]) children(); }

// Back plate only (everything behind the pocket floor), printed face down: quick test of the screws, ramp and pad curve
module backplate(c) intersection() { cage(c); translate([-200, -200, -200]) cube([400, 200, 400]); }

// ================= HELMET WEDGE (the piece between the helmet and the cage) =================
// Frame: x across (centred), y forward (+ = toward the cage), z up (z = 0 is the helmet side). The front-bottom edge is y = 0.
// Printed as is: helmet side on the bed.
w_plate_w = 73;    w_plate_t = 4.4;   w_plate_r = 3;   // base plate (measured w / l / thickness; corner radius guessed)
w_block_w = 69.7;           // width of the raised front part (measured)
// upper front widened to the widest cage's back (Hero 13 cage: 74.5) so its whole back is supported. Starts w_widen_z above
// the plate (clear of the toe, the recess and the helmet ridge), tapers out at 45 deg, and is only w_widen_d deep (y).
w_top_w   = max(H8[0], H13[0]) + clear + wall_l - overhang;
w_widen_z = 8;
w_widen_d = 8;
w_h       = 22.3;           // height at the front (measured 22.2-22.3)
w_lean    = 20;             // front wall leans back from vertical (measured: 110 deg to the table)
w_top_l   = 17;             // flat top, front to back (measured)
w_back    = 52;             // back slope angle down to the plate (from your side trace, ~50)
// cage screws: two channels 38.5 apart (centred), perpendicular to the cage, i.e. 30 deg above the plate (measured)
w_screw_dx = screw_dx;      // 38.54 (matches your 38.5)
w_screw_z  = 20.4;          // channel centre on the front face above the plate (measured 20 / 20.8)
w_screw_up = 30;            // screw axis angle above the plate (measured)
w_screw_d  = 4.4;           // channel diameter (M4 clearance)
w_screw_len = 20;           // screw length (measured 20.07)
w_cage_wall = 4.55;         // cage back wall the screw passes through first (from the cage model)
w_nut_af = 7.3;  w_nut_t = 5.2;   // pocket for an M4 nyloc nut (7 across flats, ~5 tall, + clearance), pushed in from the helmet side,
                                  // nylon ring away from the cage
w_nut_past = 0.6;                 // screw tip sticks out this far past the nut's nylon (so it locks)
// helmet bolts: 3.5 mm holes, ~3 mm from the side and back edges to the hole edge (measured)
w_bolt_d = 3.5;
w_washer_d = 8;             // flat washer seats around the two rear holes (measured)
w_washer_h = 0.5;           // level seat top stands this far above the plate at the seat's high side (measured)
// helmet hole pattern (measured on the helmet, edge to edge minus one hole): a trapezoid, wider at the back
w_bolt_dx_f = 63 - 3.5;     // front pair, centre to centre (59.5)
w_bolt_dx_b = 69.5 - 3.5;   // back pair, centre to centre (66)
w_bolt_dy   = 49 - 3.5;     // front to back, centre to centre (45.5)
w_bolt_edge = 2.6;          // plate edge to the nearest edge of each hole, on all sides (measured on the original)
w_bolt_front = 4;           // front of the side slot to the front hole centre (measured)
// side slots over the two front bolts: open to the side, floor 7.2 above the plate, 7.8 deep at the floor, closing to a point at the top
w_slot_z = 7.2;  w_slot_d = 7.8;  w_slot_w = 7;

function w_fy(z) = -z * tan(w_lean);     // front face y at height z
// helmet dome under the plate (from the contour traces): ~140 mm radius side to side, ~105 mm front to back, 6 mm higher in the
// centre of the recess than at the holes (measured on the original). z = 0 is the plate edges / holes, as when it sits on a table.
w_dome_rx = 120;  w_dome_ry = 90;    // measured with curve_gauges: S120 / F90 fitted best (the tightest strips tried)
w_dome_front_hole_z = 0.38;   // underside height at the front holes (kept from the earlier fit, so the toe/front stays put)
w_dome_h = w_dome_front_hole_z + (w_bolt_dx_f / 2) * (w_bolt_dx_f / 2) / (2 * w_dome_rx) + (w_bolt_dy / 2) * (w_bolt_dy / 2) / (2 * w_dome_ry);
// front toe: the flat front wall runs all the way down to the toe's tip; the toe's underside angles back up to that tip.
// The tip is w_toe_reach in front of the front holes (measured 12.5). Under the toe the bottom is lifted w_toe_lift (to clear
// the ridge at the front of the helmet's recess) for w_toe_flat, then slopes up at w_toe_slope until it meets the front wall.
w_toe_reach = 12.5;
w_toe_lift = 5.0;    // original's toe lifts ~4.5; our 2.5 printed ~2.0, so modelled 0.5 higher
w_toe_tip_z = 4;     // height of the tip above the table (measured ~5 at the toe; ~4 is where these numbers meet)
w_toe_lift_start = 3.7;   // the lifted part starts this far in front of the front hole centres = front edge of the part in the recess
                          // (original: 2.4 from the hole's edge; our 6.5 printed 5.2, so moved back 2.8)
w_toe_flat = 10.5 - w_toe_lift_start;   // lifted, flat part of the underside; ends where it did before (4 measured from the old start)
w_toe_slope = 45;    // underside slope up to the tip (GUESS)
w_yf_b = w_fy(w_toe_tip_z) - w_toe_reach;   // front holes, y (front wall foot at y = 0)
w_plate_l = -(w_yf_b - w_bolt_dy) + w_bolt_d / 2 + w_bolt_edge;   // wall foot to back edge, set by the holes (~64)
w_slot_wall = (w_fy(w_slot_z) - (w_yf_b + w_bolt_front));         // front wall thickness in front of the side slots

// (not clipped: the curve keeps going down past the holes to the plate edges, like the original)
function w_dome(x, y, yc) = w_dome_h - x * x / (2 * w_dome_rx) - (y - yc) * (y - yc) / (2 * w_dome_ry);
// solid between two height functions lo(x, y) and hi(x, y) over a rectangle
module heightfield(x0, x1, y0, y1, lo, hi, n = 40) {
    N = (n + 1) * (n + 1);
    pts = concat([for (j = [0 : n], i = [0 : n]) let(x = x0 + (x1 - x0) * i / n, y = y0 + (y1 - y0) * j / n) [x, y, hi(x, y)]],
                 [for (j = [0 : n], i = [0 : n]) let(x = x0 + (x1 - x0) * i / n, y = y0 + (y1 - y0) * j / n) [x, y, lo(x, y)]]);
    // T = top vertex index, B = bottom vertex index
    faces = concat(
        [for (j = [0 : n - 1], i = [0 : n - 1]) [j*(n+1)+i, (j+1)*(n+1)+i, (j+1)*(n+1)+i+1, j*(n+1)+i+1]],
        [for (j = [0 : n - 1], i = [0 : n - 1]) [N+j*(n+1)+i, N+j*(n+1)+i+1, N+(j+1)*(n+1)+i+1, N+(j+1)*(n+1)+i]],
        [for (i = [0 : n - 1]) [i, i+1, N+i+1, N+i]],
        [for (i = [0 : n - 1]) [n*(n+1)+i+1, n*(n+1)+i, N+n*(n+1)+i, N+n*(n+1)+i+1]],
        [for (j = [0 : n - 1]) [(j+1)*(n+1), j*(n+1), N+j*(n+1), N+(j+1)*(n+1)]],
        [for (j = [0 : n - 1]) [j*(n+1)+n, (j+1)*(n+1)+n, N+(j+1)*(n+1)+n, N+j*(n+1)+n]]);
    polyhedron(pts, faces);
}
w_front_r = 6;     // front corners rounded in plan view (all the way up) to fit the rounded corners of the helmet's pocket (GUESS)
// Hair-tie anchor: a U-shaped groove in the wedge's front face (the seam with the cage), below the cage screw on the cage's
// closed side. The tie's loop goes round the post inside the U; the cage, bolted on, closes the groove so it can't lift out.
// Both strands run out of the closed-side edge, then forward round the cage to the hook. The tie stays uncut.
ht_cord  = 3.5;    // groove width per strand (hair tie thickness + a little)
ht_depth = 3;      // groove depth into the wedge (a hair less than the tie, so the cage clamps it too)
ht_post_d = 4;     // post the loop wraps round
ht_below = 9;      // post centre below the screw axis, measured along the seam (leaves ~1.3 mm round the screw hole)
w_tab_gap = 0.2;   // gap left under the cage's top tab (the screw panel on the front face is the seat)
module wedge(fit_cage = true) {
    yt = w_fy(w_h);                                  // top of the front wall
    yb = yt - w_top_l - (w_h - w_plate_t) / tan(w_back);
    // block runs down past the bottom; the dome cut trims it to the helmet's curve (so it reaches the helmet at the sides too)
    prof = [[-w_fy(10), -10], [yt, w_h], [yt - w_top_l, w_h], [yb, w_plate_t], [yb, -10]];
    yf = w_fy(w_slot_z);                             // front of the slot (on the front face, at the slot floor)
    // side slot: its front face is parallel to the front wall, w_slot_wall behind it; it closes to a point at the top
    slot = [[yf - w_slot_wall, w_slot_z], [yf - w_slot_wall - w_slot_d, w_slot_z], [yt - w_slot_wall, w_h + 0.01], [yt - w_slot_wall + 0.5, w_h + 1]];
    sx0 = w_bolt_dx_f / 2;                           // front bolt x (each side)
    yf_b = w_yf_b;                                   // front bolt y
    yb_b = yf_b - w_bolt_dy;                         // back bolt y
    // plate outline: follows the trapezoid of the holes, w_bolt_edge clear of each hole, run back to the full plate length
    e = (-w_plate_l + w_bolt_d / 2 + w_bolt_edge) - yb_b;            // extra length behind the back holes (negative = further back)
    kx = (w_bolt_dx_b - w_bolt_dx_f) / 2 / w_bolt_dy;                // side taper (x per y)
    quad = [[-sx0, yf_b], [sx0, yf_b], [w_bolt_dx_b / 2 - kx * e, yb_b + e], [-w_bolt_dx_b / 2 + kx * e, yb_b + e]];
    s0 = [0, w_fy(w_screw_z), w_screw_z];            // screw channel start on the front face (y, z)
    dir = [0, -cos(w_screw_up), -sin(w_screw_up)];   // into the wedge
    nut_s = w_screw_len - w_cage_wall - w_nut_t / 2 - w_nut_past;   // nut centre along the screw, from the front face
    yc = (yf_b + yb_b) / 2;                          // dome centre: middle of the hole pattern
    dome = function(x, y) w_dome(x, y, yc);
    module outline() round_corners() hull() {
        offset(r = w_bolt_d / 2 + w_bolt_edge) polygon(quad);
        translate([-w_block_w / 2, -1]) square([w_block_w, 1]);      // under the front block
    }
    difference() {
        union() {
            rotate([90, 0, 90]) linear_extrude(height = w_block_w, center = true) polygon(prof);
            // widened upper front (a slab behind the front face), 45-degree taper out from w_block_w
            if (w_top_w > w_block_w) let(dz = (w_top_w - w_block_w) / 2,
                    slab = function(z0) [[w_fy(z0), z0], [w_fy(w_h), w_h], [w_fy(w_h) - w_widen_d, w_h], [w_fy(z0) - w_widen_d, z0]])
                hull() {
                    rotate([90, 0, 90]) linear_extrude(height = w_block_w, center = true) polygon(slab(w_widen_z));
                    rotate([90, 0, 90]) linear_extrude(height = w_top_w, center = true) polygon(slab(w_widen_z + dz));
                }
            // top raised to sit under the cage's top tab (w_tab_gap below it)
            if (fit_cage) let(p1 = cage2w([pad_floor_depth + thin_t, tri_h]) - [0, w_tab_gap], p2 = cage2w(tab_tip) - [0, w_tab_gap])
                rotate([90, 0, 90]) linear_extrude(height = w_block_w, center = true)   // (at w_top_w it overhung the hex-key slots)
                    polygon([[w_fy(w_h - 1), w_h - 1], [w_fy(p1[1]), p1[1]], p2, [p2[0], w_h - 1]]);
            // flat, level washer seats on the rear holes: top is w_washer_h above the highest point of the plate around the seat
            intersection() {   // (trimmed to the plate's rounded corners)
                for (sx = [-1, 1]) let(hx = sx * w_bolt_dx_b / 2,
                        ztop = max([for (a = [0 : 30 : 330]) dome(hx + w_washer_d / 2 * cos(a), yb_b + w_washer_d / 2 * sin(a))]) + w_plate_t + w_washer_h)
                    translate([hx, yb_b, dome(hx, yb_b) - 5]) cylinder(d = w_washer_d, h = ztop - dome(hx, yb_b) + 5, $fn = 32);
                translate([0, 0, -30]) linear_extrude(height = 70) outline();
            }
            // base plate: a shell w_plate_t thick lying on the dome
            intersection() {
                translate([0, 0, -30]) linear_extrude(height = 70) outline();      // (was clipping the low corners flat)
                heightfield(-45, 45, -w_plate_l - 5, 5, function(x, y) dome(x, y) - 0.01, function(x, y) dome(x, y) + w_plate_t);
            }
        }
        // the cage's own back (Hero 8 and Hero 13 cages share it): the wedge front takes its exact shape, so nothing collides
        if (fit_cage) { cage_on_wedge(H8); cage_on_wedge(H13); }
        // round the two front corners (plan view)
        for (m = [0, 1]) mirror([m, 0, 0]) translate([w_block_w / 2 - w_front_r, w_fy(w_toe_tip_z) - w_front_r, -50])   // from the toe tip (the front edge)
            linear_extrude(height = 100) difference() { square([w_front_r + 20, w_front_r + 20]); circle(r = w_front_r, $fn = 48); }
        recess_corners();
        // hair-tie groove (see ht_): in the seam plane, local frame: u = x (toward the closed side), v = down the seam, n = into the wedge
        if (fit_cage) let(T2 = cage2w([pad_floor_depth + thin_t, tri_h]), F2 = cage2w([ramp_end_depth, z_step]),
                ev = (F2 - T2) / norm(F2 - T2), en0 = [ev[1], -ev[0]], en = en0[0] < 0 ? en0 : -en0,
                sx = w_screw_dx / 2, L = 30, r = ht_post_d / 2)
            multmatrix([[1, 0, 0, sx], [0, ev[0], en[0], w_s0[1]], [0, ev[1], en[1], w_s0[2]], [0, 0, 0, 1]])
                translate([0, 0, -2]) linear_extrude(height = ht_depth + 2) difference() {
                    hull() { translate([0, ht_below]) circle(r = r + ht_cord, $fn = 48); translate([L, ht_below]) circle(r = r + ht_cord, $fn = 48); }
                    hull() { translate([0, ht_below]) circle(r = r, $fn = 32); translate([L, ht_below]) circle(r = r, $fn = 32); }
                }
        // the dome under the plate
        heightfield(-50, 50, -w_plate_l - 10, 10, function(x, y) -30, function(x, y) dome(x, y));
        // under the toe: lifted w_toe_lift, flat for w_toe_flat, then sloping up to meet the front wall at the tip
        let(y0 = yf_b + w_toe_lift_start)
            heightfield(-50, 50, y0, 15, function(x, y) -30,
                function(x, y) dome(x, y) + w_toe_lift * min(1, (y - y0) / 0.5) + max(0, y - y0 - w_toe_flat) * tan(w_toe_slope), 60);
        // side slots (open to the side), one over each front bolt
        for (sx = [-1, 1]) let(x_in = sx0 - w_slot_w / 2, len = max(w_plate_w, w_top_w) / 2 + 2 - x_in)
            translate([sx > 0 ? x_in : -x_in - len, 0, 0]) {
                rotate([90, 0, 90]) linear_extrude(height = len) polygon(slot);
                // straight-down access from the top to the bolt head (hex key), as on the original. Its back wall comes to a
                // 45-degree point (teardrop) so it isn't a flat ceiling when the wedge is printed standing on its front face.
                hull() {
                    translate([0, yf_b - w_slot_w / 2, w_slot_z]) cube([len, w_slot_w, w_h + 5]);
                    translate([len / 2, yf_b - w_slot_w / 2 - len / 2, w_slot_z]) cylinder(d = 0.01, h = w_h + 5, $fn = 4);
                }
            }
        // helmet bolt holes
        for (p = [[-sx0, yf_b], [sx0, yf_b], [-w_bolt_dx_b / 2, yb_b], [w_bolt_dx_b / 2, yb_b]])
            translate([p[0], p[1], -30]) cylinder(d = w_bolt_d, h = 60, $fn = 24);
        // cage screw channels + nut pockets (nut inserted from the helmet side)
        for (sx = [-1, 1]) translate([sx * w_screw_dx / 2, 0, 0]) {
            translate(s0 - 2 * dir) rotate([-(90 - w_screw_up), 0, 0]) rotate([180, 0, 0]) cylinder(d = w_screw_d, h = 2 + w_screw_len - w_cage_wall + 1.5, $fn = 24);
            // nut pocket: a hex tunnel along the screw axis, from the nut's front face out through the bottom, so the nyloc
            // slides in from below square to the screw (points of the hex front/back, like the original)
            translate(s0 + (nut_s - w_nut_t / 2) * dir) rotate([90 + w_screw_up, 0, 0]) rotate([0, 0, 90])
                cylinder(d = w_nut_af / cos(30), h = 60, $fn = 6);
        }
    }
}

if (PART == "wedge")        wedge();
// fit test for the dome: an open frame with the true helmet-side surface, printed FLAT TOP DOWN (no supports): an 8 mm rim, a
// cross through the middle and rings round the 4 holes. Top is flat, w_test_t above the highest point of the helmet surface.
w_test_t = 1.5;
module wedge_plate_shell() let(yc = w_yf_b - w_bolt_dy / 2)
    intersection() {
        wedge(false);
        heightfield(-50, 50, -w_plate_l - 10, 15, function(x, y) -30, function(x, y) w_dome(x, y, yc) + w_plate_t + 0.01);
    }
// Plate corners: rounded with w_corner_r (bigger than the 4.35 round each hole), so the sides stay w_bolt_edge from the holes
// but the corners carry less plastic: original ~1.9 from hole to corner; 2.6 all round printed ~3.1, so this errs a bit thinner.
w_corner_r = 8;   // hole edge -> corner (diagonal) = (r - w_corner_r) * sqrt(2) + w_corner_r - hole radius ~ 1.1 in the model
module round_corners() offset(r = w_corner_r, $fn = 64) offset(r = -w_corner_r) children();
// The part of the plate that sits IN the recess (from the bottom up to the lifted toe's underside) is shaped like the back:
// its outline runs w_bolt_edge round each hole, so its front corners are round, concentric(ish) with the front holes. The front
// corner circles are moved back a little so the front edge is where the toe lift starts (2.4 from the hole edge, like the original).
function w_quad(front_back = 0) = let(sx0 = w_bolt_dx_f / 2, yf_b = w_yf_b - front_back, yb_b = w_yf_b - w_bolt_dy,
        e = (-w_plate_l + w_bolt_d / 2 + w_bolt_edge) - yb_b, kx = (w_bolt_dx_b - w_bolt_dx_f) / 2 / w_bolt_dy)
    [[-sx0, yf_b], [sx0, yf_b], [w_bolt_dx_b / 2 - kx * e, yb_b + e], [-w_bolt_dx_b / 2 + kx * e, yb_b + e]];
module recess_corners() let(yc = w_yf_b - w_bolt_dy / 2, r = w_bolt_d / 2 + w_bolt_edge)
    intersection() {
        translate([0, 0, -50]) linear_extrude(height = 100) difference() {
            square([200, 300], center = true);
            round_corners() offset(r = r, $fn = 48) polygon(w_quad(r - w_toe_lift_start));
        }
        heightfield(-50, 50, -w_plate_l - 10, 15, function(x, y) -40, function(x, y) w_dome(x, y, yc) + w_toe_lift + 0.01);
    }
// footprint of a test frame: the whole plate (with the toe), or just the part that sits in the recess
module frame_footprint(recess_only) if (recess_only) let(r = w_bolt_d / 2 + w_bolt_edge) round_corners() offset(r = r, $fn = 48) polygon(w_quad(r - w_toe_lift_start));
    else hull() projection() wedge_plate_shell();
module wedge_frame(rim = 8, cross = true, recess_only = false)
    let(yc = w_yf_b - w_bolt_dy / 2, q = w_quad(w_bolt_d / 2 + w_bolt_edge - w_toe_lift_start), yb_b = w_yf_b - w_bolt_dy, sx0 = w_bolt_dx_f / 2,
        holes = [[-sx0, w_yf_b], [sx0, w_yf_b], [-w_bolt_dx_b / 2, yb_b], [w_bolt_dx_b / 2, yb_b]],
        // flat top: w_test_t above the highest point of the underside the frame covers
        ztop = (recess_only ? max(w_dome(0, q[0][1], yc), w_dome(0, q[2][1], yc)) : w_dome_h) + w_test_t, y0 = w_yf_b + w_toe_lift_start)
    translate([0, 0, ztop]) rotate([180, 0, 0])
        difference() {
            translate([0, 0, -30]) linear_extrude(height = 30 + ztop) intersection() {
                frame_footprint(recess_only);
                union() {
                    difference() { frame_footprint(recess_only); offset(r = -rim) frame_footprint(recess_only); }
                    if (cross) { translate([-4, -100]) square([8, 200]); translate([-100, yc - 4]) square([200, 8]); }
                    for (p = holes) translate(p) circle(d = 11, $fn = 32);
                }
            }
            // helmet side: the dome, and the lifted toe at the front
            heightfield(-50, 50, -w_plate_l - 10, 15, function(x, y) -40, function(x, y) w_dome(x, y, yc));
            heightfield(-50, 50, y0, 15, function(x, y) -40,
                function(x, y) w_dome(x, y, yc) + w_toe_lift * min(1, (y - y0) / 0.5) + max(0, y - y0 - w_toe_flat) * tan(w_toe_slope), 60);
            for (p = holes) translate([p[0], p[1], -50]) cylinder(d = w_bolt_d, h = 100, $fn = 24);
            recess_corners();
        }
if (PART == "wedge_plate")   wedge_frame();
// outline only: a 4 mm rim (with the rounded corners and the 4 holes) to check the plate's shape in the helmet's pocket
if (PART == "wedge_outline") wedge_frame(rim = 4, cross = false, recess_only = true);
// ---------- Curve gauges: narrow strips with a circular underside, to measure the helmet's curve in the recess ----------
// Lay each strip in the recess (curved side down, label up). The right radius sits flat: rocks on its middle = too flat
// (radius too big), rocks on its ends / gap in the middle = too curved (radius too small).
// "S" strips go side to side (try them across the front holes, the middle and the back holes); "F" strips go front to back.
gauge_t = 2;   gauge_w = 6;
gauge_side  = [120, 140, 160, 180];   gauge_side_l  = 64;   // side-to-side radii / strip length
gauge_front = [90, 105, 120];         gauge_front_l = 50;   // front-to-back radii / strip length
module curve_strip(R, L, label)
    difference() {
        translate([-L / 2, -gauge_w / 2, -20]) cube([L, gauge_w, 20 + gauge_t]);
        translate([0, 0, -R]) rotate([90, 0, 0]) cylinder(r = R, h = gauge_w + 2, center = true, $fn = 720);
        translate([L / 2 - 9, 0, gauge_t - 0.6]) linear_extrude(height = 1)
            text(label, size = 3.2, font = "Liberation Sans:style=Bold", halign = "center", valign = "center");
    }
if (PART == "curve_gauges")
    rotate([180, 0, 0]) translate([0, 0, -gauge_t]) {   // flat top on the bed
        for (i = [0 : len(gauge_side) - 1])  translate([0, i * 10, 0]) curve_strip(gauge_side[i], gauge_side_l, str("S", gauge_side[i]));
        for (i = [0 : len(gauge_front) - 1]) translate([0, (len(gauge_side) + i) * 10, 0]) curve_strip(gauge_front[i], gauge_front_l, str("F", gauge_front[i]));
    }
if (PART == "backplate8")   rotate([-90, 0, 0]) mirror([1, 0, 0]) backplate(H8);
// ---------- Pad variants, for printing several fit tests at once ----------
// amp  = S-shape along the pad: the upper part bulges toward the helmet by amp mm, the lower part pulls back by amp mm
// lipc = how much the middle of the short piece between the ledge and the curve is pulled back (a concave lip)
function sb(i) = i < 1 ? 0 : max(0, pad_corner[i][1] - pad_base_center(pad_corner[i][0]));
function variant_corner(amp, lipc) = let(b = pad_corner) concat(
    [[b[0][0], b[0][1], 0],
     [b[1][0], b[1][1], sb(1)],
     [(b[1][0] + b[2][0]) / 2, (b[1][1] + b[2][1]) / 2 - lipc, (sb(1) + sb(2)) / 2],
     [b[2][0], b[2][1], sb(2)]],
    [for (i = [3 : 6]) [b[i][0], b[i][1] + amp * sin(360 * (b[i][0] - b[2][0]) / (b[7][0] - b[2][0])), sb(i)]],
    [[b[7][0], b[7][1], sb(7)]]);
variants = [["A", 0, 0], ["B", pad_S_amp, pad_lip_concave], ["C", 1.6, 1.0]];   // [label, amp, lipc]
variant_pitch = 42;     // spacing between the pieces on the plate

// Quick fit test: just the ledge and the curved pad (plus 6 mm of ramp above the ledge), same print orientation
module padtest(c) intersection() {
    backplate(c);
    translate([-200, -200, ref_top - (z_step + pad_h) - 5]) cube([400, 400, pad_h + 5 + 6]);
}
if (PART == "padtest8")     rotate([-90, 0, 0]) mirror([1, 0, 0]) padtest(H8);
if (PART == "hero8_dummy")  flipx(H8[0])  dummy(H8);
if (PART == "hero13_dummy") flipx(H13[0]) dummy(H13);
if (PART == "cage8")        mirror([1, 0, 0]) cage(H8);
if (PART == "cage13")       mirror([1, 0, 0]) cage(H13);
if (PART == "preview8")     mirror([1, 0, 0]) assembly(H8);
if (PART == "preview13")    mirror([1, 0, 0]) assembly(H13);
// Three pad variants side by side on one plate (A = current profile, B = mild S + concave lip, C = stronger)
if (PART == "padtest_set")
    for (k = [0 : len(variants) - 1])
        translate([0, k * variant_pitch, 0])
            let($pc = variant_corner(variants[k][1], variants[k][2]))
                rotate([-90, 0, 0]) mirror([1, 0, 0]) difference() {
                    padtest(H8);
                    // label engraved into the flat face that sits on the bed
                    translate([(ix0 + x_open8) / 2, 0.01, ref_top - z_step - 12]) rotate([90, 0, 0])
                        linear_extrude(height = 0.6) mirror([1, 0, 0]) text(variants[k][0], size = 9, halign = "center", valign = "center");
                }

// ---------- Nut plate: holds the four M3 nylocs inside the helmet, under the wedge's bolts ----------
// Follows the helmet's inside surface like the original: the bars (rim + X) are np_bar_t thick against the shell, and a hex
// boss hangs down at each hole round its nut. The four nut pockets are all at the same height, so one PAUSE seals all of them.
// Print it as modelled: helmet side up, resting on the flat bottoms of the four bosses, with (tree) supports under the bars.
// At the pause drop an M3 nyloc into each pocket, nylon ring DOWN (toward the bed); the bolts come in from the top (helmet side).
np_shell_t = 4;              // helmet shell thickness at the holes (measured: 4)
np_nut_af = 5.5 + 0.3;       // M3 nyloc: 5.5 across flats + clearance (+0.2 was too tight: the nuts didn't fit)
np_nut_h  = 4.0 + 0.2;       // M3 nyloc: 4 mm tall + a little, so the nut sits below the layer printed after the pause
np_floor = 1.0;              // under the nut (head side); the bolt hole goes through, so any bolt length works
np_roof  = 1.2;              // over the nut, against the helmet (at the thinnest boss)
np_boss_af = 9.5;            // hex bosses round the nuts
np_bar_w = 4.5;  np_bar_t = 3;     // frame bars, following the inside of the shell
np_hole = 3.5;               // M3 clearance
np_membrane = 0;             // skin over each bolt hole on the head side (0 = holes open through; 0.4 = 2 sacrificial layers)
                             // into the nut pockets from the bed; the bolt pushes through it (or poke it with a 3 mm drill)
np_pause_z = np_floor + np_nut_h;  // PAUSE here (height above the bed): the first layer printed above it covers the nuts
module nutplate() let(
        yf = w_yf_b, yb = w_yf_b - w_bolt_dy, yc = (yf + yb) / 2,
        rxi = w_dome_rx - np_shell_t, ryi = w_dome_ry - np_shell_t,
        si = function(x, y) w_dome_h - np_shell_t - x * x / (2 * rxi) - (y - yc) * (y - yc) / (2 * ryi),   // helmet's inside surface
        holes = [[-w_bolt_dx_f / 2, yf], [w_bolt_dx_f / 2, yf], [w_bolt_dx_b / 2, yb], [-w_bolt_dx_b / 2, yb]],
        pr = np_nut_af / cos(30) / 2,                               // pocket hex corner radius
        // all pocket tops at one height: np_roof under the LOWEST point of the shell over any pocket (its outer corners, where
        // the curve has dropped away), less 0.15 for the surface mesh sitting a hair under the true curve
        ptop = min([for (p = holes, a = [0 : 60 : 360]) si(p[0] + (a < 360 ? pr * cos(a) : 0), p[1] + (a < 360 ? pr * sin(a) : 0))])
               - np_roof - 0.15,
        z0 = ptop - np_nut_h - np_floor)                           // flat bottom of the bosses (the bed)
    translate([0, 0, -z0]) difference() {
        // one surface for the whole top (bars and bosses), so there's no seam where they meet
        intersection() {
            union() {
                // bars: a band np_bar_t thick under the inside surface
                intersection() {
                    translate([0, 0, z0 - 1]) linear_extrude(height = 40)
                        for (e = [[0, 1], [1, 2], [2, 3], [3, 0], [0, 2], [1, 3]]) hull() for (i = e) translate(holes[i]) circle(d = np_bar_w, $fn = 24);
                    heightfield(-45, 45, yb - 10, yf + 10, function(x, y) si(x, y) - np_bar_t, function(x, y) si(x, y) + 2, 40);
                }
                // bosses: from the flat bottom up
                for (p = holes) translate([p[0], p[1], z0]) cylinder(d = np_boss_af / cos(30), h = 30, $fn = 6);
            }
            heightfield(-45, 45, yb - 10, yf + 10, function(x, y) z0 - 1, si, 60);
        }
        for (p = holes) {
            translate([p[0], p[1], z0 + (np_membrane > 0 ? np_membrane : -1)]) cylinder(d = np_hole, h = 40, $fn = 24);
            translate([p[0], p[1], z0 + np_floor]) cylinder(d = np_nut_af / cos(30), h = np_nut_h, $fn = 6);
        }
    }
if (PART == "nutplate") { nutplate(); echo(str("nutplate: add a PAUSE at the first layer above ", np_pause_z, " mm")); }

// ---------- Fit check: the cage (as printed, mirrored) bolted to the wedge ----------
// screw axes lined up, cage screw panel on the wedge front face (screw centre point on the panel -> screw entry on the face)
function panel_depth(h) = let(T = [pad_floor_depth + thin_t, tri_h], F = [ramp_end_depth, z_step]) T[0] + (F[0] - T[0]) * (h - T[1]) / (F[1] - T[1]);
cage_screw_pt = [-(screw_xs[0] + screw_xs[1]) / 2, ref_front_to_floor - panel_depth(ref_top), 0];   // after the mirror
w_s0 = [0, w_fy(w_screw_z), w_screw_z];
// a point of the cage's side profile [depth from the front, height below the top] -> [y, z] in the wedge frame (cage bolted on)
function cage2w(p) = let(y = ref_front_to_floor - p[0] - cage_screw_pt[1], z = ref_top - p[1])
    [y * cos(w_screw_up) - z * sin(w_screw_up) + w_s0[1], y * sin(w_screw_up) + z * cos(w_screw_up) + w_s0[2]];
module cage_on_wedge(c) translate(w_s0) rotate([w_screw_up, 0, 0]) translate(-cage_screw_pt) mirror([1, 0, 0]) cage(c);
if (PART == "fit8") { color("orange") wedge(); color("cyan") cage_on_wedge(H8); }
if (PART == "fit8_clash") intersection() { wedge(); cage_on_wedge(H8); }
// thin slice through the cage-on-wedge assembly at x = fit_sec_x (side view shows the contact line)
fit_sec_x = 8;       // between the screws
if (PART == "fit8_sec") {
    color("orange") intersection() { wedge(); translate([fit_sec_x - 0.5, -100, -100]) cube([1, 200, 200]); }
    color("cyan") intersection() { cage_on_wedge(H8); translate([fit_sec_x - 0.7, -100, -100]) cube([1, 200, 200]); }
}

// ---------- Helmet envelope: the space the two parts leave for the helmet ----------
// = below the wedge's underside (dome + lifted toe) AND behind the cage's back (its real curved pad), over the cage width.
// Its top surface is where the helmet would have to be for both parts to touch it.
module helmet_env()
    let(yc = w_yf_b - w_bolt_dy / 2, y0 = w_yf_b + w_toe_lift_start)
    intersection() {
        heightfield(-36, 36, -w_plate_l - 5, 40, function(x, y) -40,
            function(x, y) y <= y0 ? w_dome(x, y, yc)
                : w_dome(x, y, yc) + w_toe_lift * min(1, (y - y0) / 0.5) + max(0, y - y0 - w_toe_flat) * tan(w_toe_slope), 60);
        translate(w_s0) rotate([w_screw_up, 0, 0]) translate(-cage_screw_pt) mirror([1, 0, 0])
            difference() {
                translate([ix0 + 0.5, -80, ref_bottom + 0.5]) cube([x_open8 - ix0 - 1, 80, ref_top - ref_bottom - 1]);
                difference() { interface(H8); pad_cut(); }
            }
    }
if (PART == "helmet8") helmet_env();
if (PART == "fit8_helmet") { color("orange") wedge(); color("cyan") cage_on_wedge(H8); color("gray") helmet_env(); }
