/* 
 * Copyright (c) 2025 SingChun LEE @ Bucknell University. CC BY-NC 4.0.
 * 
 * This code is provided mainly for educational purposes at Bucknell University.
 *
 * This code is licensed under the Creative Commons Attribution-NonCommerical 4.0
 * International License. To view a copy of the license, visit 
 *   https://creativecommons.org/licenses/by-nc/4.0/
 * or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
 *
 * You are free to:
 *  - Share: copy and redistribute the material in any medium or format.
 *  - Adapt: remix, transform, and build upon the material.
 *
 * Under the following terms:
 *  - Attribution: You must give appropriate credit, provide a link to the license,
 *                 and indicate if changes where made.
 *  - NonCommerical: You may not use the material for commerical purposes.
 *  - No additional restrictions: You may not apply legal terms or technological 
 *                                measures that legally restrict others from doing
 *                                anything the license permits.
 */

// struct to sture 3D PGA multivector
struct MultiVector {
  s: f32, 
  exey: f32, 
  exez: f32, 
  eyez: f32, 
  eoex: f32, 
  eoey: f32, 
  eoez: f32, 
  exeyez: f32, 
  eoexey: f32, 
  eoexez: f32, 
  eoeyez: f32,
  ex: f32, 
  ey: f32, 
  ez: f32, 
  eo: f32,
  eoexeyez: f32
}

// the geometric product 
fn geometricProduct(a: MultiVector, b: MultiVector) -> MultiVector { 
  // The geometric product rules are:
  //   1. eoeo = 0, exex = 1 and eyey = 1, ezez = 1
  //   2. eoex + exeo = 0, eoey + eyeo = 0, eoez + ezeo = 0
  //   3. exey + eyex = 0, exez + ezex = 0, eyez + ezey = 0
  // This results in the following product table:
  var r: MultiVector;
  r.s = a.s * b.s - a.exey * b.exey - a.exez * b.exez - a.eyez * b.eyez - a.exeyez * b.exeyez + a.ex * b.ex + a.ey * b.ey + a.ez * b.ez; // scalar
  r.exey = a.s * b.exey + a.exey * b.s - a.exez * b.eyez + a.eyez * b.exez + a.exeyez * b.ez + a.ex * b.ey - a.ey * b.ex + a.ez * b.exeyez; // exey
  r.exez = a.s * b.exez + a.exey * b.eyez + a.exez * b.s - a.eyez * b.exey - a.exeyez * b.ey + a.ex * b.ez - a.ey * b.exeyez - a.ez * b.ex; // exez
  r.eyez = a.s * b.eyez - a.exey * b.exez + a.exez * b.exey + a.eyez * b.s + a.exeyez * b.ex + a.ex * b.exeyez + a.ey * b.ez - a.ez * b.ey; // eyez
  r.eoex = a.s * b.eoex + a.exey * b.eoey + a.exez * b.eoez - a.eyez * b.eoexeyez + a.eoex * b.s - a.eoey * b.exey - a.eoez * b.exez + a.exeyez * b.eoeyez + a.eoexey * b.ey + a.eoexez * b.ez - a.eoeyez * b.exeyez - a.ex * b.eo + a.ey * b.eoexey + a.ez * b.eoexez + a.eo * b.ex - a.eoexeyez * b.eyez; // eoex
  r.eoey = a.s * b.eoey - a.exey * b.eoex + a.exez * b.eoexeyez + a.eyez * b.eoez + a.eoex * b.exey + a.eoey * b.s - a.eoez * b.eyez - a.exeyez * b.eoexez - a.eoexey * b.ex + a.eoexez * b.exeyez + a.eoeyez * b.ey - a.ex * b.eoexey - a.ey * b.eo + a.ez * b.eoeyez + a.eo * b.ey + a.eoexeyez * b.exez; // eoey
  r.eoez = a.s * b.eoez - a.exey * b.eoexeyez - a.exez * b.eoex - a.eyez * b.eoey + a.eoex * b.exez + a.eoey * b.eyez + a.eoez * b.s + a.exeyez * b.eoexey - a.eoexey * b.exeyez - a.eoexez * b.ex - a.eoeyez * b.ey - a.ex * b.eoexez - a.ey * b.eoeyez - a.ez * b.eo + a.eo * b.ez - a.eoexeyez * b.exey; // eoez
  r.exeyez = a.s * b.exeyez + a.exey * b.ez - a.exez * b.ey + a.eyez * b.ex + a.exeyez * b.s + a.ex * b.eyez - a.ey * b.exez + a.ez * b.exey; // exeyez
  r.eoexey = a.s * b.eoexey + a.exey * b.eo - a.exez * b.eoeyez + a.eyez * b.eoexez + a.eoex * b.ey - a.eoey * b.ex + a.eoez * b.exeyez - a.exeyez * b.eoez + a.eoexey * b.s - a.eoexez * b.eyez + a.eoeyez * b.exez - a.ex * b.eoey + a.ey * b.eoex - a.ez * b.eoexeyez + a.eo * b.exey + a.eoexeyez * b.ez; // eoexey
  r.eoexez = a.s * b.eoexez + a.exey * b.eoeyez + a.exez * b.eo - a.eyez * b.eoexey + a.eoex * b.ez - a.eoey * b.exeyez - a.eoez * b.ex + a.exeyez * b.eoey + a.eoexey * b.eyez + a.eoexez * b.s - a.eoeyez * b.exey - a.ex * b.eoez + a.ey * b.eoexeyez + a.ez * b.eoex + a.eo * b.exez - a.eoexeyez * b.ey; // eoexez
  r.eoeyez = a.s * b.eoeyez - a.exey * b.eoexez + a.exez * b.eoexey + a.eyez * b.eo + a.eoex * b.exeyez + a.eoey * b.ez - a.eoez * b.ey - a.exeyez * b.eoex - a.eoexey * b.exez + a.eoexez * b.exey + a.eoeyez * b.s - a.ex * b.eoexeyez - a.ey * b.eoez + a.ez * b.eoey + a.eo * b.eyez + a.eoexeyez * b.ex; // eoeyez
  r.ex = a.s * b.ex + a.exey * b.ey + a.exez * b.ez - a.eyez * b.exeyez - a.exeyez * b.eyez + a.ex * b.s - a.ey * b.exey - a.ez * b.exez; // ex
  r.ey = a.s * b.ey - a.exey * b.ex + a.exez * b.exeyez + a.eyez * b.ez + a.exeyez * b.exez + a.ex * b.exey + a.ey * b.s - a.ez * b.eyez; // ey
  r.ez = a.s * b.ez - a.exey * b.exeyez - a.exez * b.ex - a.eyez * b.ey - a.exeyez * b.exey + a.ex * b.exez + a.ey * b.eyez + a.ez * b.s; // ez
  r.eo = a.s * b.eo - a.exey * b.eoexey - a.exez * b.eoexez - a.eyez * b.eoeyez + a.eoex * b.ex + a.eoey * b.ey + a.eoez * b.ez + a.exeyez * b.eoexeyez - a.eoexey * b.exey - a.eoexez * b.exez - a.eoeyez * b.eyez - a.ex * b.eoex - a.ey * b.eoey - a.ez * b.eoez + a.eo * b.s - a.eoexeyez * b.exeyez; // eo
  r.eoexeyez = a.s * b.eoexeyez + a.exey * b.eoez - a.exez * b.eoey + a.eyez * b.eoex + a.eoex * b.eyez - a.eoey * b.exez + a.eoez * b.exey - a.exeyez * b.eo + a.eoexey * b.ez - a.eoexez * b.ey + a.eoeyez * b.ex - a.ex * b.eoeyez + a.ey * b.eoexez - a.ez * b.eoexey + a.eo * b.exeyez + a.eoexeyez * b.s; // eoexeyez
  return r;
}

// the reverse of a Multivector
fn reverse(a: MultiVector) -> MultiVector {
  // The reverse is the reverse order of the basis elements
  //  the reverse of a scalar is the scalar
  //  the reverse of exey is eyex = -exey
  //  the reverse of exez is ezex = -exez
  //  the reverse of eyez is ezey = -eyez
  //  the reverse of eoex is exeo = -eoex
  //  the reverse of eoey is eyeo = -eoey
  //  the reverse of eoez is ezeo = -eoez
  //  the reverse of exeyez is ezeyex = exezey = -exeyez
  //  the reverse of eoexey is eyexeo = eoeyex = -eoexey
  //  the reverse of eoexez is ezexeo = eoezex = -eoexez
  //  the reverse of eoeyez is ezeyeo = eoezey = -eoeyez
  //  the reverse of ex, ey, ez, eo are ex, ey, ez, eo
  //  the reverse of eoexeyez is ezeyexeo = -eoezeyex = -eoexezey = eoexeyez
  // So, for [s, exey, exez, eyez, eoex, eoey, eoez, exeyez, eoexey, eoexez, eoeyez, ex, ey, ez, eo, eoexeyez],
  // Its reverse is [s, -exey, -exez, eyez, -eoex, -eoey, -eoez, -exeyez, -eoexey, -eoexez, -eoeyez, ex, ey, ez, eo, eoexeyez].
  return MultiVector(a.s, -a.exey, -a.exez, -a.eyez, -a.eoex, -a.eoey, -a.eoez, -a.exeyez, -a.eoexey, -a.eoexez, -a.eoeyez, a.ex, a.ey, a.ez, a.eo, a.eoexeyez);
}

fn applyMotor(p: MultiVector, m: MultiVector) -> MultiVector {
  // To apply a motor to a point, we use the sandwich operation
  // The formula is m * p * reverse of m
  // Here * is the geometric product
  return geometricProduct(m, geometricProduct(p, reverse(m)));
}

fn motorNorm(m: MultiVector) -> f32 {
  // The norm of a motor is square root of the sum of square of the terms:
  // we have
  var sum = 0.;
  sum += m.s * m.s;
  sum += m.exey * m.exey;
  sum += m.exez * m.exez;
  sum += m.eyez * m.eyez;
  sum += m.eoex * m.eoex;
  sum += m.eoey * m.eoey;
  sum += m.eoez * m.eoez;
  sum += m.exeyez * m.exeyez;
  sum += m.eoexey * m.eoexey;
  sum += m.eoexez * m.eoexez;
  sum += m.eoeyez * m.eoeyez;
  sum += m.ex * m.ex;
  sum += m.ey * m.ey;
  sum += m.ez * m.ez;
  sum += m.eo * m.eo;
  sum += m.eoexeyez * m.eoexeyez;
  return sqrt(sum);
}

fn createTranslator(d: vec3f) -> MultiVector {
  // Given dx and dy describing the moveming in the x and y directions,
  // the translator is given by 1 + dx/2 exeo + dy/2 eyeo + dz/2 ezeo
  // In code, we always store the coefficents of
  //    scalar, exey, exez, eyez, eoex, eoey, eoez, exeyez, eoexey, eoexez, eoeyez, ex, ey, ez, eo, eoexeyez
  // Hence the implementation is as below
  return MultiVector(1, 0, 0, 0, -d.x / 2, -d.y / 2, -d.z / 2, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

fn extractTranslator(m: MultiVector) -> MultiVector {
  // Given a general motor, we can extract the translator part
  return MultiVector(1, 0, 0, 0, m.eoex, m.eoey, m.eoez, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

fn createDir(d: vec3f) -> MultiVector {
  // A direction is given by dx eyez + dy ezex + dz exey
  //    scalar, exey, exez, eyez, eoex, eoey, eoez, exeyez, eoexey, eoexez, eoeyez, ex, ey, ez, eo, eoexeyez
  return MultiVector(0, d.z, -d.y, d.x, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

fn createLine(s: vec3f, d: vec3f) -> MultiVector {
  // A line is given by a starting point (sx, sy, sz) and a direction (dx, dy, dz)
  //  in this form: dx eyez + dy ezex + dz exey + (dy * sz - dz * sy) exeo + (dz * sx - dx * sz) eyeo + (dx * sy - dy * sx) ezeo
  let n = createDir(d); // represent the input direction in PGA
  let dir = normalizeMotor(n); // normalize the direction to make sure it is a unit direction
  // Note dir.exey = dz, dir.exez = -dy, dir.eyez = dx
  return MultiVector(0, dir.exey, dir.exez, dir.eyez, -(-dir.exez * s.z - dir.exey * s.y), -(dir.exey * s.x - dir.eyez * s.z), -(dir.eyez * s.y + dir.exez * s.x), 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

fn createRotor(angle: f32, d: vec3f, spt: vec3f) -> MultiVector {
  // Given an angle and a rotation axis direction (dx, dy, dz) and a start point of the rotation axis,
  // the rotor is given by cos(angle / 2 ) + sin(angle / 2 ) L
  //  where L is the line in 3D PGA formed by the direction and the start point
  let c = cos(angle / 2);
  let s = sin(angle / 2);
  let L = createLine(spt, d);
  return MultiVector(c, s * L.exey, s * L.exez, s * L.eyez, s * L.eoex, s * L.eoey, s * L.eoez, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

fn extractRotor(m: MultiVector) -> MultiVector {
  // Given a general motor, we can extract the rotor part
  return MultiVector(m.s, m.exey, m.exez, m.eyez, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

fn createPoint(p: vec3f) -> MultiVector {
  // Given a point in 3D with coordinates (x, y, z)
  // A point in PGA is given by exeyez + x eoezey + y eoexez + z eoeyex
  // In code, we always store the coefficents of 
  //    scalar, exey, exez, eyez, eoex, eoey, eoez, exeyez, eoexey, eoexez, eoeyez, ex, ey, ez, eo, eoexeyez
  return MultiVector(0, 0, 0, 0, 0, 0, 0, 1, -p.z, p.y, -p.x, 0, 0, 0, 0, 0);
}

fn extractPoint(p: MultiVector) -> vec3f {
  // to extract the 3d point from a exeyez + b eoezey + c eoexez + d eoeyex
  // we have x = -b/a and y = c/a and z = -d/a
  return vec3f(-p.eoeyez / p.exeyez, p.eoexez / p.exeyez, -p.eoexey / p.exeyez);
}

fn createPlane(n: vec3f, d: f32) -> MultiVector {
  // Given a plane in 3D with normal (nx, ny, nz) and distance from the origin d
  // A plane in PGA is given by nx ex + ny ey + nz ez - deo
  // In code, we always store the coefficents of 
  //    scalar, exey, exez, eyez, eoex, eoey, eoez, exeyez, eoexey, eoexez, eoeyez, ex, ey, ez, eo, eoexeyez
  return MultiVector(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, n.x, n.y, n.z, -d, 0);
}

fn createPlaneFromPoints(p1: vec3f, p2: vec3f, p3: vec3f) -> MultiVector {
  // Given three poitns (x1, y1, z1), (x2, y2, z2), (x3, y3, z3)
  // A plane in PGA is given by 
  //        ((y2 * z3 - y3 * z2) -      (y1 * z3 - y3 * z1) +      (y1 * z2 - y2 * z1)) ex 
  // -      ((x2 * z3 - x3 * z2) -      (x1 * z3 - x3 * z1) +      (x1 * z2 - x2 * z1)) ey 
  // +      ((x2 * y3 - x3 * y2) -      (x1 * y3 - x3 * y1) +      (x1 * y2 - x2 * y1)) ez 
  // + (x1 * (y2 * z3 - y3 * z2) - x2 * (y1 * z3 - y3 * z1) + x3 * (y1 * z2 - y2 * z1)) eo
  let nx =          (p2[1] * p3[2] - p3[1] * p2[2]) -         (p1[1] * p3[2] - p3[1] * p1[2]) +         (p1[1] * p2[2] - p2[1] * p1[2]);
  let ny =          (p2[0] * p3[2] - p3[0] * p2[2]) -         (p1[0] * p3[2] - p3[0] * p1[2]) +         (p1[0] * p2[2] - p2[0] * p1[2]);
  let nz =          (p2[0] * p3[1] - p3[0] * p2[1]) -         (p1[0] * p3[1] - p3[0] * p1[1]) +         (p1[0] * p2[1] - p2[0] * p1[1]);
  let d = (p1[0] * (p2[1] * p3[2] - p3[1] * p2[2]) - p2[0] * (p1[1] * p3[2] - p3[1] * p1[2]) + p3[0] * (p1[1] * p2[2] - p2[1] * p1[2]));
  return createPlane(vec3f(nx, -ny, nz), d);
}

// define a constant
const EPSILON : f32 = 0.00000001;

// a structure to store the hit information
struct HitInfo {
  p: vec3f,      // where it hits
  hit: bool,     // if it hits
  inPlane: bool, // if it does not hit, is it in the plane?
}

fn linePlaneIntersection(L: MultiVector, P: MultiVector) -> HitInfo {
  // In PGA, the intersection point is simply embedded in the geometric product betwen them
  let new_p = geometricProduct(L, P);
  var hitInfo: HitInfo;
  hitInfo.p = extractPoint(new_p);
  hitInfo.hit = !(abs(new_p.exeyez) <= EPSILON);
  hitInfo.inPlane = hitInfo.hit && abs(new_p.eoexey) <= EPSILON && abs(new_p.eoexez) <= EPSILON && abs(new_p.eoeyez) <= EPSILON;
  return hitInfo;
}

fn normalizeMotor(m: MultiVector) -> MultiVector {
  // To normalize a motor, we divide each coefficient by its norm
  let mnorm = motorNorm(m);
  if (mnorm == 0.0) {
    return MultiVector(1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  }
  return MultiVector(m.s / mnorm, m.exey / mnorm, m.exez / mnorm, m.eyez / mnorm, m.eoex / mnorm, m.eoey / mnorm, m.eoez / mnorm, m.exeyez / mnorm, m.eoexey / mnorm, m.eoexez / mnorm, m.eoeyez / mnorm, m.ex / mnorm, m.ey / mnorm, m.ez / mnorm, m.eo / mnorm, m.eoexeyez / mnorm);
}

fn applyMotorToPoint(p: vec3f, m: MultiVector) -> vec3f {
  // apply the motor m to transform the point p
  // this code covert the 3d point p into PGA and apply the motor to transform it
  // then extra the result from PGA
  let new_p = applyMotor(createPoint(p), m);
  return extractPoint(new_p);
};

fn applyMotorToDir(d: vec3f, m: MultiVector) -> vec3f {
  // apply the motor m to transform the direction d
  // this code convert the 3d direction d into PGA, then extract the rotor from the motor
  // and transform the direction using the rotor
  // last, extra the result from PGA
  let r = extractRotor(m);
  let new_d = applyMotor(createPoint(d), r);
  return extractPoint(new_d);
}

// struct to store 3D PGA pose
struct Camera {
  motor: MultiVector,
  focal: vec2f,
  res: vec2f,
}

// struct to store the volume info
struct VolInfo {
  dims: vec4f, // volume dimension
  sizes: vec4f, // voxel sizes
}

// binding the camera pose
@group(0) @binding(0) var<uniform> cameraPose: Camera ;
// binding the volume info
@group(0) @binding(1) var<uniform> volInfo: VolInfo;
// binding the volume data
@group(0) @binding(2) var<storage> volData: array<f32>;
// binding the output texture to store the ray tracing results
@group(0) @binding(3) var outTexture: texture_storage_2d<rgba8unorm, write>;
@group(0) @binding(4) var<storage> parameters: array<u32>;

// a function to transform the direction to the model coordiantes
fn transformDir(d: vec3f) -> vec3f {
  // transform the direction using the camera pose
  var out = applyMotorToDir(d, cameraPose.motor);
  return out;
}

// a function to transform the start pt to the model coordiantes
fn transformPt(pt: vec3f) -> vec3f {
  // transform the point using the camera pose
  var out = applyMotorToPoint(pt, cameraPose.motor);
  return out;
}

// a function to asign the pixel color
fn assignColor(uv: vec2i) {
  var color: vec4f;
  color = vec4f(0.f/255, 56.f/255, 101.f/255, 1.); // Bucknell Blue
  textureStore(outTexture, uv, color);  
}

// a helper function to keep track of the two ray-volume hit values
fn compareVolumeHitValues(curValue: vec2f, t: f32) -> vec2f {
  var result = curValue;
  if (curValue.x < 0) { // no hit value yet
    result.x = t; // update the closest
  }
  else {
    if (t < curValue.x) { // if find a closer hit value
      result.y = curValue.x; // update the second closest
      result.x = t;          // update the closest
    }
    else {
      if (curValue.y < 0) { // no second hit value yet
        result.y = t;
      }
      else if (t < curValue.y) { // if find a second closer
        result.y = t;
      }
    }
  }
  return result;
}

// a helper function to compute the ray-volume hit values
fn getVolumeHitValues(checkval: f32, halfsize: vec2f, pval: f32, dval: f32, p: vec2f, d: vec2f, curT: vec2f) -> vec2f {
  var cur = curT;
  if (abs(dval) > EPSILON) {
    let t = (checkval - pval) / dval; // compute the current hit point to the check value
    if (t > 0) {
      let hPt = p + t * d;
      if (-halfsize.x < hPt.x && hPt.x < halfsize.x && -halfsize.y < hPt.y && hPt.y < halfsize.y) {
        cur = compareVolumeHitValues(cur, t);
      }
    }
  }
  return cur;
}

// a function to compute the start and end t values of the ray hitting the volume
fn rayVolumeIntersection(p: vec3f, d: vec3f) -> vec2f {
  var hitValues = vec2f(-1, -1);
  let halfsize = volInfo.dims * volInfo.sizes * 0.5 / max(max(volInfo.dims.x, volInfo.dims.y), volInfo.dims.z); // 1mm
  //let halfsize = vec3f(0.5, 0.5, 0.5) * volInfo.sizes.xyz;
  // hitPt = p + t * d => t = (hitPt - p) / d
  hitValues = getVolumeHitValues(halfsize.z, halfsize.xy, p.z, d.z, p.xy, d.xy, hitValues); // z = halfsize.z
  hitValues = getVolumeHitValues(-halfsize.z, halfsize.xy, p.z, d.z, p.xy, d.xy, hitValues); // z = -halfsize.z
  hitValues = getVolumeHitValues(-halfsize.x, halfsize.yz, p.x, d.x, p.yz, d.yz, hitValues); // x = -halfsize.x
  hitValues = getVolumeHitValues(halfsize.x, halfsize.yz, p.x, d.x, p.yz, d.yz, hitValues); // x = halfsize.x
  hitValues = getVolumeHitValues(halfsize.y, halfsize.xz, p.y, d.y, p.xz, d.xz, hitValues); // y = halfsize.y
  hitValues = getVolumeHitValues(-halfsize.y, halfsize.xz, p.y, d.y, p.xz, d.xz, hitValues); // y = -halfsize.y
  return hitValues;
}

// a helper function to get the next hit value
fn getNextHitValue(startT: f32, curT: f32, checkval: f32, minCorner: vec2f, maxCorner: vec2f, pval: f32, dval: f32, p: vec2f, d: vec2f) -> f32 {
  var cur = curT;
  if (abs(dval) > EPSILON) {
    let t = (checkval - pval) / dval; // compute the current hit point to the check value
    let hPt = p + t * d;
    if (minCorner.x < hPt.x && hPt.x < maxCorner.x && minCorner.y < hPt.y && hPt.y < maxCorner.y) {
      if (t > startT && cur < t) {
        cur = t;
      }
    }
  }
  return cur;
}

// a function to trace the volume - volume rendering
fn traceScene(uv: vec2i, p: vec3f, d: vec3f) {
  var setting = parameters[3];
  if (setting == 0){
    maxIntensityCompute(uv, p, d);
  }
  else if (setting == 1){
    DDRCompute(uv, p, d);
  }
  else if (setting == 2){
    DepthColorCompute(uv, p, d);
  }
  // else{
  //   fogCompute(uv, p, d);
  // }
  
}

fn depthEncoding(t0: f32, t1: f32, tmin: f32, tmax: f32) -> vec4f {
  let r = vec4f(1, 0, 0, 1);
  let g = vec4f(0, 1, 0, 1);
  let b = vec4f(0, 0, 1, 1);
  let t = (t1 + t0) * 0.5;
  let m = (tmax + tmin) * 0.5;
  if (t > m) { // intepolating between green and blue
    let lambda = (t - m) / (tmax - m);
    return b * lambda + g * (1 - lambda);
  }
  let lambda = (m - t) / (m - tmin);
  return r * lambda + g * (1 - lambda);
}

fn DepthColorCompute(uv: vec2i, p: vec3f, d: vec3f){
  // find the start and end point
  var hits = rayVolumeIntersection(p, d);
  var color = vec4f(0.f/255, 0.f/255, 0.f/255, 1.); 
  // if there is only one hit point, we trace from the camera center
  if (hits.y < 0 && hits.x > 0) {
    hits.y = hits.x;
    hits.x = 0;
  }
  // assign colors
  // if (hits.x >= 0) { 
  //   let diff = hits.y - hits.x;
  //   color = vec4f(diff, 1 - diff, 0, 1.);
  // }
  if (hits.x >= 0){
    var currentHit = hits.x;
    var sizes = volInfo.sizes.xyz;
    var dims = volInfo.dims.xyz;
    while (currentHit < hits.y){
      var currentPoint = p + d * (currentHit + (EPSILON * 20));
      //currentHit is a world position that we need to convert to a (x,y,z) index of the voxel data
      //volumn origin is (0,0,0) - (x dim * x size, y dim * y size, z dim * z size)/2
      //var origin = -(dims * sizes)/2;
      let halfsize = dims * sizes * 0.5 / max(max(volInfo.dims.x, volInfo.dims.y), volInfo.dims.z); // 1mm
      let delta = sizes / max(max(volInfo.dims.x, volInfo.dims.y), volInfo.dims.z);
      //shift our hit point by this origin, then divide by the grid size to find which cell it is in, take the floor to get the exact indicies
      var index = floor((currentPoint + halfsize)/(delta));
      //linear index = z(x dim * y dim) + y(x dim) + x

      
      var corner = -halfsize + index * delta;
      var nextCorner = corner + delta;
      
      var nextHit = hits.y;
      nextHit = getNextHitValue(currentHit, nextHit, corner.z, corner.xy, nextCorner.xy, p.z, d.z, p.xy, d.xy);
      nextHit = getNextHitValue(currentHit, nextHit, nextCorner.z, corner.xy, nextCorner.xy, p.z, d.z, p.xy, d.xy);

      nextHit = getNextHitValue(currentHit, nextHit, corner.y, corner.xz, nextCorner.xz, p.y, d.y, p.xz, d.xz);
      nextHit = getNextHitValue(currentHit, nextHit, nextCorner.y, corner.xz, nextCorner.xz, p.y, d.y, p.xz, d.xz);

      nextHit = getNextHitValue(currentHit, nextHit, corner.x, corner.yz, nextCorner.yz, p.x, d.x, p.yz, d.yz);
      nextHit = getNextHitValue(currentHit, nextHit, nextCorner.x, corner.yz, nextCorner.yz, p.x, d.x, p.yz, d.yz);
      var currentIntensity = volData[i32(index.z * (dims.x* dims.y) + index.y * dims.x + index.x)];
      var t = nextHit - currentHit + EPSILON * 20;
      //accumulate the color by adding delta t * voxel value / 4095 * depthEncoding(current hitvalue, next hitvalue, hits.x, hits.y)
      color += t * currentIntensity * depthEncoding(currentHit, nextHit, hits.x, hits.y) / 4095;
      
      currentHit = nextHit;
    }

    //set color = color / (hits.y - hits.x)
    //set color.w = 1 (we keep the alpha channel to 1)
    color = color / (hits.y - hits.x);
    color.w = 1;
  }
  else {
    color = vec4f(0.f/255, 56.f/255, 101.f/255, 1.); // Bucknell Blue
  }
  textureStore(outTexture, uv, color); 
}
/*
fn fogCompute(uv: vec2i, p: vec3f, d: vec3f){
  // find the start and end point
  var hits = rayVolumeIntersection(p, d);
  var color = vec4f(0.f/255, 0.f/255, 0.f/255, 1.); 
  
  // if there is only one hit point, we trace from the camera center
  if (hits.y < 0 && hits.x > 0) {
    hits.y = hits.x;
    hits.x = 0;
  }
  /*
  // Ray marching
  while (the current hitvalue < hits.y) // i.e. still inside the volume
    set density to the voxel value
    set alpha to density * 0.02 and clamp it values between 0.0 and 0.1 // this control the opacity of the fog
    set opacity to alpha * current light intensity // this is how much light obsorted
    accumulate the color by adding opacity * fog color // this is how much color contributed to the final color
    set current hitvalue = next hitvalue + epsilon
    if current light intensity < a threshold // this control how much light can see
      break the while loop

  // final coloring
  if current light intensity > another threshold // I use it to discard low intensity color
    set color to the background color (e.g. Bucknell blue)
  else // otherwise, we blend the color
    set color equal to blending color between the current color and the background color
  */
  if (hits.x >= 0){
    var currentHit = hits.x;
    var attenuationValue = 0.;
    var sizes = volInfo.sizes.xyz;
    var dims = volInfo.dims.xyz;
    var fogColor = vec4f(.7, .7, .8, 1);
    var lightIntensity = 1;
    var density = 0;
    var alpha = 1;
    var opacity = 0;
    while (currentHit < hits.y){
      var currentPoint = p + d * (currentHit + (EPSILON * 20));
      //currentHit is a world position that we need to convert to a (x,y,z) index of the voxel data
      //volumn origin is (0,0,0) - (x dim * x size, y dim * y size, z dim * z size)/2
      //var origin = -(dims * sizes)/2;
      let halfsize = dims * sizes * 0.5 / max(max(volInfo.dims.x, volInfo.dims.y), volInfo.dims.z); // 1mm
      let delta = sizes / max(max(volInfo.dims.x, volInfo.dims.y), volInfo.dims.z);
      //shift our hit point by this origin, then divide by the grid size to find which cell it is in, take the floor to get the exact indicies
      var index = floor((currentPoint + halfsize)/(delta));
      //linear index = z(x dim * y dim) + y(x dim) + x

      
      var corner = -halfsize + index * delta;
      var nextCorner = corner + delta;
      
      var nextHit = hits.y;
      nextHit = getNextHitValue(currentHit, nextHit, corner.z, corner.xy, nextCorner.xy, p.z, d.z, p.xy, d.xy);
      nextHit = getNextHitValue(currentHit, nextHit, nextCorner.z, corner.xy, nextCorner.xy, p.z, d.z, p.xy, d.xy);

      nextHit = getNextHitValue(currentHit, nextHit, corner.y, corner.xz, nextCorner.xz, p.y, d.y, p.xz, d.xz);
      nextHit = getNextHitValue(currentHit, nextHit, nextCorner.y, corner.xz, nextCorner.xz, p.y, d.y, p.xz, d.xz);

      nextHit = getNextHitValue(currentHit, nextHit, corner.x, corner.yz, nextCorner.yz, p.x, d.x, p.yz, d.yz);
      nextHit = getNextHitValue(currentHit, nextHit, nextCorner.x, corner.yz, nextCorner.yz, p.x, d.x, p.yz, d.yz);
      density = volData[i32(index.z * (dims.x* dims.y) + index.y * dims.x + index.x)];
      
      var t = currentHit - nextHit + EPSILON;
      attenuationValue += t * currentIntensity / 4095;
      alpha = density * .2;
      
      currentHit = nextHit;
    }
    var intensity = min(max(1 - pow(2.718, attenuationValue), 0), 1);
    color = vec4f(intensity, intensity, intensity, 1);
  }
  else {
    color = vec4f(0.f/255, 56.f/255, 101.f/255, 1.); // Bucknell Blue
  }
  textureStore(outTexture, uv, color); 
}
*/

fn DDRCompute(uv: vec2i, p: vec3f, d: vec3f){
  // find the start and end point
  var hits = rayVolumeIntersection(p, d);
  var color = vec4f(0.f/255, 0.f/255, 0.f/255, 1.); 
  // if there is only one hit point, we trace from the camera center
  if (hits.y < 0 && hits.x > 0) {
    hits.y = hits.x;
    hits.x = 0;
  }
  // assign colors
  // if (hits.x >= 0) { 
  //   let diff = hits.y - hits.x;
  //   color = vec4f(diff, 1 - diff, 0, 1.);
  // }
  if (hits.x >= 0){
    var currentHit = hits.x;
    var attenuationValue = 0.;
    var sizes = volInfo.sizes.xyz;
    var dims = volInfo.dims.xyz;
    while (currentHit < hits.y){
      var currentPoint = p + d * (currentHit + (EPSILON * 20));
      //currentHit is a world position that we need to convert to a (x,y,z) index of the voxel data
      //volumn origin is (0,0,0) - (x dim * x size, y dim * y size, z dim * z size)/2
      //var origin = -(dims * sizes)/2;
      let halfsize = dims * sizes * 0.5 / max(max(volInfo.dims.x, volInfo.dims.y), volInfo.dims.z); // 1mm
      let delta = sizes / max(max(volInfo.dims.x, volInfo.dims.y), volInfo.dims.z);
      //shift our hit point by this origin, then divide by the grid size to find which cell it is in, take the floor to get the exact indicies
      var index = floor((currentPoint + halfsize)/(delta));
      //linear index = z(x dim * y dim) + y(x dim) + x

      
      var corner = -halfsize + index * delta;
      var nextCorner = corner + delta;
      
      var nextHit = hits.y;
      nextHit = getNextHitValue(currentHit, nextHit, corner.z, corner.xy, nextCorner.xy, p.z, d.z, p.xy, d.xy);
      nextHit = getNextHitValue(currentHit, nextHit, nextCorner.z, corner.xy, nextCorner.xy, p.z, d.z, p.xy, d.xy);

      nextHit = getNextHitValue(currentHit, nextHit, corner.y, corner.xz, nextCorner.xz, p.y, d.y, p.xz, d.xz);
      nextHit = getNextHitValue(currentHit, nextHit, nextCorner.y, corner.xz, nextCorner.xz, p.y, d.y, p.xz, d.xz);

      nextHit = getNextHitValue(currentHit, nextHit, corner.x, corner.yz, nextCorner.yz, p.x, d.x, p.yz, d.yz);
      nextHit = getNextHitValue(currentHit, nextHit, nextCorner.x, corner.yz, nextCorner.yz, p.x, d.x, p.yz, d.yz);
      var currentIntensity = volData[i32(index.z * (dims.x* dims.y) + index.y * dims.x + index.x)];
      var t = currentHit - nextHit + EPSILON;
      attenuationValue += t * currentIntensity / 4095;
      
      currentHit = nextHit;
    }
    var intensity = min(max(1 - pow(2.718, attenuationValue), 0), 1);
    color = vec4f(intensity, intensity, intensity, 1);
  }
  else {
    color = vec4f(0.f/255, 56.f/255, 101.f/255, 1.); // Bucknell Blue
  }
  textureStore(outTexture, uv, color); 
}

fn maxIntensityCompute(uv: vec2i, p: vec3f, d: vec3f){
  // find the start and end point
  var hits = rayVolumeIntersection(p, d);
  var color = vec4f(0.f/255, 0.f/255, 0.f/255, 1.); 
  // if there is only one hit point, we trace from the camera center
  if (hits.y < 0 && hits.x > 0) {
    hits.y = hits.x;
    hits.x = 0;
  }
  // assign colors
  // if (hits.x >= 0) { 
  //   let diff = hits.y - hits.x;
  //   color = vec4f(diff, 1 - diff, 0, 1.);
  // }
  if (hits.x >= 0){
    var currentHit = hits.x;
    var maxIntensity = 0.;
    var sizes = volInfo.sizes.xyz;
    var dims = volInfo.dims.xyz;
    var step = 0;
    while (currentHit < hits.y){
      var currentPoint = p + d * (currentHit + (EPSILON * 20));
      //currentHit is a world position that we need to convert to a (x,y,z) index of the voxel data
      //volumn origin is (0,0,0) - (x dim * x size, y dim * y size, z dim * z size)/2
      //var origin = -(dims * sizes)/2;
      let halfsize = dims * sizes * 0.5 / max(max(volInfo.dims.x, volInfo.dims.y), volInfo.dims.z); // 1mm
      let delta = sizes / max(max(volInfo.dims.x, volInfo.dims.y), volInfo.dims.z);
      //shift our hit point by this origin, then divide by the grid size to find which cell it is in, take the floor to get the exact indicies
      var index = floor((currentPoint + halfsize)/(delta));
      //linear index = z(x dim * y dim) + y(x dim) + x
      var currentIntensity = volData[i32(index.z * (dims.x* dims.y) + index.y * dims.x + index.x)];
      if (currentIntensity > maxIntensity){
        maxIntensity = currentIntensity;
      }
      var corner = -halfsize + index * delta;
      var nextCorner = corner + delta;
      //var xyHit = getNextHitValue(hits.x, currentHit, checkVal, minCorner, maxCorner, pval, dval, p, d);
      //checkval: the coord not inside the plane name, ie z in xy plane
      //minCorner: the min values of the plane to be checked
      //maxCorner: max values of the plane to be checked
      //pval: other 2 coords of the start contained in the plane, ie s.xy for xy plane
      //dval: same as pval but for the starting direction
      //check xy plane first
      //var xyHit = getNextHitValue(hits.x, currentHit, checkVal, minCorner, maxCorner, pval, dval, p, d);
      //fn getNextHitValue(startT: f32, curT: f32, checkval: f32, minCorner: vec2f, maxCorner: vec2f, pval: f32, dval: f32, p: vec2f, d: vec2f) -> f32 {
      
      var nextHit = hits.y;
      nextHit = getNextHitValue(currentHit, nextHit, corner.z, corner.xy, nextCorner.xy, p.z, d.z, p.xy, d.xy);
      nextHit = getNextHitValue(currentHit, nextHit, nextCorner.z, corner.xy, nextCorner.xy, p.z, d.z, p.xy, d.xy);

      nextHit = getNextHitValue(currentHit, nextHit, corner.y, corner.xz, nextCorner.xz, p.y, d.y, p.xz, d.xz);
      nextHit = getNextHitValue(currentHit, nextHit, nextCorner.y, corner.xz, nextCorner.xz, p.y, d.y, p.xz, d.xz);

      nextHit = getNextHitValue(currentHit, nextHit, corner.x, corner.yz, nextCorner.yz, p.x, d.x, p.yz, d.yz);
      nextHit = getNextHitValue(currentHit, nextHit, nextCorner.x, corner.yz, nextCorner.yz, p.x, d.x, p.yz, d.yz);
      
      currentHit = nextHit;
      
      //currentHit += 0.01;
      step += 1;
    }
    maxIntensity = maxIntensity / 4095;
    color = vec4f(maxIntensity, maxIntensity, maxIntensity, 1);
  }
  else {
    color = vec4f(0.f/255, 56.f/255, 101.f/255, 1.); // Bucknell Blue
  }
  textureStore(outTexture, uv, color); 
}

@compute
@workgroup_size(16, 16)
fn computeOrthogonalMain(@builtin(global_invocation_id) global_id: vec3u) {
  // get the pixel coordiantes
  let uv = vec2i(global_id.xy);
  let texDim = vec2i(textureDimensions(outTexture));
  if (uv.x < texDim.x && uv.y < texDim.y) {
    // compute the pixel size
    let psize = vec2f(2, 2) / cameraPose.res.xy;
    // orthogonal camera ray sent from each pixel center at z = 0
    var spt = vec3f((f32(uv.x) + 0.5) * psize.x - 1, (f32(uv.y) + 0.5) * psize.y - 1, 0);
    var rdir = vec3f(0, 0, 1);
    // apply transformation
    spt = transformPt(spt);
    rdir = transformDir(rdir);
    // trace scene
    traceScene(uv, spt, rdir);
  }
}

@compute
@workgroup_size(16, 16)
fn computeProjectiveMain(@builtin(global_invocation_id) global_id: vec3u) {
  // TODO: write code to generate projection camera ray and trace the ray to assign the pixel color
  // This should be very similar to the orthogonal one above
  // get the pixel coordiantes
  let uv = vec2i(global_id.xy);
  let texDim = vec2i(textureDimensions(outTexture));

  if (uv.x < texDim.x && uv.y < texDim.y) {
    // compute the pixel size
    let psize = vec2f(2, 2) / cameraPose.res.xy * cameraPose.focal.xy;
    var spt = vec3f(0, 0, 0);
    //we are looking at the screen from 0,0,0 along the z axis
    //compute the amount of pixels away from the center and use that as your direction, then normalize that
    var xHalf   = f32(texDim.x) / 2;
    var yHalf   = f32(texDim.y) / 2;
    var xOffset = f32(uv.x) - xHalf + .5;
    var yOffset = f32(uv.y) - yHalf + .5;
    var rdir = vec3f(xOffset * psize.x, yOffset * psize.y, 1.0);
    rdir = normalize(rdir);
    // apply transformation
    spt = transformPt(spt);
    rdir = transformDir(rdir);
    // assign colors
    traceScene(uv, spt, rdir);
  }
}
