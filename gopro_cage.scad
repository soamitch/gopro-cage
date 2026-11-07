// GoPro helmet cage + dummy cameras (parametric, all units mm)
// Pick what to export with PART, then Render (F6) and Export STL.
//   "hero8_dummy"  - fake Hero 8, to calibrate against your current mount
//   "hero13_dummy" - fake Hero 13, to test the new cage
//   "cage8"        - cage for the real Hero 8 (should reproduce your current mount: use it to validate the model)
//   "cage13"       - cage for the Hero 13, lens held in the SAME place relative to the helmet as the Hero 8
//   "preview8" / "preview13" - cage + red dummy together (use a cross-section view to inspect)
PART = "backplate8";

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

// elastic (hair tie) slot: runs along X through the back wall, in front of the pad curve, centred at the height of the
// bottom of the lens window. Flat stadium shape (a flattened hair tie passes through it); a wider notch around the
// opening on the open side lets the knot / bunched elastic sit flush.
cord_slot_w = 7;     // slot size across Z (NOT MEASURED - adjust)
cord_slot_t = 3.2;   // slot size across Y (thickness of the flattened tie)
cord_y = -4.8;       // slot centre, behind the pocket floor (y = 0 is the floor)
cord_notch_w = 12;   // notch size across Z at the open-side opening
cord_notch_t = 7;    // notch size across Y
cord_notch_l = 5;    // notch depth into the wall from the open side
// elastic hook: a small block on the front face at the open end, bottom corner, with a channel along X that is OPEN at the
// bottom (drop the tie in from below)
hook_x_len = 17.6;  hook_out = 7.6;  hook_h = 4;  hook_r = 1.5;  hook_chamfer = 1.5;   // hook height (its top is flush with the bottom of the lens window); hook_r rounds its edges
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
pad_top_corner = 40.7;    // top of the pad, at the two outer corners
pad_top_center = 35.3;    // top of the pad, in the middle
pad_bot_corner = 36.0;   // bottom of the pad, at the corners
pad_bot_center = 31.0;   // bottom of the pad, in the middle

// pad outline at the CORNERS: [offset below z_step, depth from the front]. The curve across the width is cut into this.
// BACK PANEL (the screw panel): a ramp from the thinnest point (4 mm behind the pocket floor) down to 7.4 mm behind it
tri_h        = 10;     // height of the triangular tab at the top (tip to where its underside meets the panel)
thin_t       = 4;      // back wall thickness at the thinnest point
panel_t      = 7.4;    // back wall thickness at the bottom of the ramp
panel_base   = 18.5;   // vertical length of the ramp
pad_lip_h  = 4;       // height of the piece between the ledge and the start of the curve
pad_floor_depth = front_t + (H8[2] - H8[5]) + clear_y;   // outside front face to pocket floor (27.5)
pad_corner = [[tri_h + panel_base - z_step, pad_floor_depth + panel_t],   // bottom of the ramp (a little above the pad)
              [0, pad_floor_depth + panel_t],   // straight down to the top of the pad ...
              [0, 40.4],                // ... then the ledge goes straight back (flat, no slope) to the pad
              [pad_lip_h, pad_top_corner],   // outermost point of the pad: the piece between the ledge and the curve is pad_lip_h tall
              [10.1, 39.4],
              [14.8, 38.4],
              [18.8, 37.5],
              [23.8, 36.4],
              [pad_h, pad_bot_corner]]; // bottom edge

prof = concat(
    [[45.85, 0],        // tip of the top tab, flush with the top face (45.85 from the front, measured)
     [pad_floor_depth + thin_t, tri_h]],   // underside of the tab meets the screw panel = thinnest point
    [for (q = pad_corner) [q[1], z_step + q[0]]]);

// ---------- Derived: where the lens sits (fixed relative to the helmet) ----------
x_open8     = open_to_screw;
lens_cx_ref = x_open8 + overhang - (H8[0] - H8[6]);   // lens centre x, held fixed for every camera
z_top8      = -floor_to_screw + clear + H8[1];
lens_cz_ref = z_top8 - H8[4] / 2;                    // lens centre z, held fixed for every camera

// Reference geometry of the Hero 8 cage (the back interface is defined against this and never moves)
ref_front_to_floor = front_t + (H8[2] - H8[5]) + clear_y;   // outside front face to pocket floor
ref_top    = z_top8 + clear + top_t;                          // outer top
ref_bottom = -floor_to_screw - bottom_t;                      // outer bottom
ix0        = cx0(H8) - clear - wall_l;                        // outer closed (left) edge

function cx1(c) = lens_cx_ref + (c[0] - c[6]);   // camera right edge
function cx0(c) = cx1(c) - c[0];                 // camera left edge
function cz1(c) = lens_cz_ref + c[4] / 2;        // camera top (lens flush with the top)
function cz0(c) = cz1(c) - c[1];                 // camera bottom

module rbox(w, h, d, r) {      // rounded box: x 0..w, z 0..h, y 0..d
    hull() for (x = [r, w - r], z = [r, h - r])
        translate([x, 0, z]) rotate([-90, 0, 0]) cylinder(r = r, h = d);
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
function pad_base_center(o) = o <= pad_lip_h ? pad_top_center
                            : pad_top_center + (pad_bot_center - pad_top_center) * (o - pad_lip_h) / (pad_h - pad_lip_h);
// Sag (corner depth minus centre depth) at entry i of pad_corner; never negative
function pad_s(i) = i < 2 ? 0 : max(0, pad_corner[i][1] - pad_base_center(pad_corner[i][0]));   // entries 0-1 are the flat ramp above the ledge: no sag there

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
    n  = len(pad_corner);
    zs = [for (q = pad_corner) ref_top - (z_step + q[0])];
    for (i = [0 : n - 2])
        hull() {
            translate([0, 0, zs[i]])     linear_extrude(height = 0.01) polygon(pad_slice_pts(pad_corner[i][1],     pad_s(i)));
            translate([0, 0, zs[i + 1]]) linear_extrude(height = 0.01) polygon(pad_slice_pts(pad_corner[i + 1][1], pad_s(i + 1)));
        }
    hull() {   // run past the bottom edge
        translate([0, 0, zs[n - 1]])     linear_extrude(height = 0.01) polygon(pad_slice_pts(pad_corner[n - 1][1], pad_s(n - 1)));
        translate([0, 0, zs[n - 1] - 2]) linear_extrude(height = 0.01) polygon(pad_slice_pts(pad_corner[n - 1][1], pad_s(n - 1)));
    }
}

// Back interface block: the side profile, extruded along X over the footprint of the Hero 8 cage
module interface() {
    n = len(prof);
    pts = concat(
        [for (i = [0 : n - 2]) [-(prof[i][0] - ref_front_to_floor), ref_top - prof[i][1]]],
        [[-(prof[n-1][0] - ref_front_to_floor), ref_bottom], [0, ref_bottom], [0, ref_top]]
    );
    translate([ix0, 0, 0]) rotate([90, 0, 90])
        linear_extrude(height = x_open8 - ix0) polygon(pts);
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
    lw_x0 = lens_cx_ref - ls/2 - lens_clear;
    lw_z0v = cz1(c) - ls - lens_clear;

    difference() {
        union() {
            // shell, flat-cut at the open side
            intersection() {
                translate([ox0, -back_t, oz0]) rbox(xo - ox0 + 10, oz1 - oz0, od, 3);
                translate([ox0 - 1, -back_t - 1, oz0 - 1]) cube([xo - ox0 + 1, od + 2, oz1 - oz0 + 2]);
            }
            interface();
            // elastic hook: block on the front face near the open end (eye is cut below)
            // (top flush with the bottom of the lens window, all outer edges rounded)
            // The end toward the closed wall is a 45-degree slope (like the original), so it prints without supports when the cage
            // stands on its closed wall; the end toward the open side is rounded (it narrows as it goes up, so that prints fine too).
            zb = lw_z0v - hook_h;  zt = lw_z0v;  yo = pd + front_t + hook_out;  yi = pd + front_t - 1.5;
            hull() {
                for (hz = [zb + hook_r, zt - hook_r], hy = [yi, yo - hook_r]) {
                    translate([xo - 2 - hook_r, hy, hz]) sphere(r = hook_r, $fn = 24);                              // rounded open end
                    translate([xo - hook_x_len - 2 + hook_chamfer, hy, hz]) rotate([0, 90, 0]) cylinder(r = hook_r, h = 0.01, $fn = 24);   // full size
                }
                for (hz = [zb + hook_chamfer + 0.25, zt - hook_chamfer - 0.25], hy = [yi, yo - hook_chamfer - 0.25])
                    translate([xo - hook_x_len - 2, hy, hz]) rotate([0, 90, 0]) cylinder(r = 0.25, h = 0.01, $fn = 12);   // shrunk start of the slope
            }
        }
        // concave curve across the back of the pad
        pad_cut();
        // camera pocket (open to the right)
        translate([px0, 0, pz0]) rbox(xo + 10 - px0, pz1 - pz0, pd, c[3] + clear);
        // shutter button: window through the top wall + channel in the ceiling out to the open side
        translate([bx0, by0, pz1 - 0.01]) cube([btn_w, btn_d, top_t + 1]);
        translate([bx0, by0, pz1 - 0.01]) cube([xo + 10 - bx0, btn_d, btn_h + 0.01]);
        // lens window: open to the right side and the ceiling of the pocket
        translate([lw_x0, pd - 1, lw_z0v]) cube([xo + 10 - lw_x0, front_t + 2, pz1 - lw_z0v]);
        // screen window
        translate([ox0 + scr_from_left_outer, pd - 1, oz0 + scr_from_bottom_outer]) cube([scr_w, front_t + 2, scr_h]);
        // PLACEHOLDER window through the left wall
        translate([ox0 - 1, lw_y0, pz0 + lw_z0]) cube([wall_l + 2, pd - lw_y0 - lw_y1, (pz1 - pz0) - lw_z0 - lw_z1]);
        // elastic cord hole through the back wall, with a notch around the opening on the open side
        translate([ox0 - 1, cord_y, lw_z0v]) stadium_x(cord_slot_w, cord_slot_t, xo - ox0 + 12);
        translate([xo - cord_notch_l, cord_y, lw_z0v]) stadium_x(cord_notch_w, cord_notch_t, cord_notch_l + 10);
        // channel of the elastic hook, open at the bottom
        hull() {
            translate([xo - hook_x_len - 2 - 1, pd + front_t + hook_out / 2 - hook_eye_t / 2, lw_z0v - hook_h + 0.5])
                cube([hook_x_len + 2, hook_eye_t, hook_eye_w - 0.5]);
            translate([xo - hook_x_len - 2 - 1, pd + front_t + hook_out / 2 - hook_eye_t / 2 - hook_flare, lw_z0v - hook_h - 0.5])
                cube([hook_x_len + 2, hook_eye_t + 2 * hook_flare, 0.01]);
        }
        // countersunk screw holes (head on the pocket side)
        for (sx = screw_xs) translate([sx, 0, 0]) {
            translate([0, -40, 0]) rotate([-90, 0, 0]) cylinder(d = screw_d, h = 41);
            translate([0, -csk_h, 0]) rotate([-90, 0, 0]) cylinder(d1 = screw_d, d2 = csk_d, h = csk_h + 0.01);
            rotate([-90, 0, 0]) cylinder(d = csk_d, h = 2);
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
if (PART == "backplate8")   rotate([-90, 0, 0]) mirror([1, 0, 0]) backplate(H8);
if (PART == "hero8_dummy")  flipx(H8[0])  dummy(H8);
if (PART == "hero13_dummy") flipx(H13[0]) dummy(H13);
if (PART == "cage8")        mirror([1, 0, 0]) cage(H8);
if (PART == "cage13")       mirror([1, 0, 0]) cage(H13);
if (PART == "preview8")     mirror([1, 0, 0]) assembly(H8);
if (PART == "preview13")    mirror([1, 0, 0]) assembly(H13);
