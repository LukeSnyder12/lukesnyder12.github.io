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

struct tint_symbol {
  /* @offset(0) */
  tint_symbol_1 : f32,
  /* @offset(4) */
  tint_symbol_2 : f32,
  /* @offset(8) */
  tint_symbol_3 : f32,
  /* @offset(12) */
  tint_symbol_4 : f32,
}

struct tint_symbol_5 {
  /* @offset(0) */
  tint_symbol_6 : tint_symbol,
  /* @offset(16) */
  tint_symbol_7 : vec2f,
}

struct tint_symbol_19_block {
  /* @offset(0) */
  inner : tint_symbol_5,
}

alias RTArr = array<u32>;

struct tint_symbol_20_block {
  /* @offset(0) */
  inner : RTArr,
}

struct tint_symbol_17 {
  /* @offset(0) */
  tint_symbol_18 : vec4f,
}

struct tint_symbol_22_block {
  /* @offset(0) */
  inner : tint_symbol_17,
}

struct tint_symbol_23 {
  /* @offset(0) */
  tint_symbol_24 : vec4f,
  /* @offset(16) */
  tint_symbol_25 : f32,
}

var<private> tint_symbol_24_1 : vec2f;

var<private> tint_symbol_27_1 : u32;

var<private> tint_symbol_24_2 = vec4f();

var<private> tint_symbol_25_1 = 0.0f;

var<private> tint_symbol_25_2 : f32;

var<private> value = vec4f();

var<private> tint_symbol_37_1 : vec3u;

@group(0) @binding(0) var<uniform> tint_symbol_19 : tint_symbol_19_block;

@group(0) @binding(1) var<storage> tint_symbol_20 : tint_symbol_20_block;

@group(0) @binding(2) var<storage, read_write> tint_symbol_21 : tint_symbol_20_block;

@group(0) @binding(3) var<uniform> tint_symbol_22 : tint_symbol_22_block;

fn tint_ftou(v : f32) -> u32 {
  return select(4294967295u, select(u32(v), 0u, (v < 0.0f)), (v < 4294967040.0f));
}

fn tint_symbol_8(tint_symbol_9 : tint_symbol, tint_symbol_10 : tint_symbol) -> tint_symbol {
  return tint_symbol(((tint_symbol_9.tint_symbol_1 * tint_symbol_10.tint_symbol_1) - (tint_symbol_9.tint_symbol_2 * tint_symbol_10.tint_symbol_2)), ((tint_symbol_9.tint_symbol_1 * tint_symbol_10.tint_symbol_2) + (tint_symbol_9.tint_symbol_2 * tint_symbol_10.tint_symbol_1)), ((((tint_symbol_9.tint_symbol_1 * tint_symbol_10.tint_symbol_3) + (tint_symbol_9.tint_symbol_2 * tint_symbol_10.tint_symbol_4)) + (tint_symbol_9.tint_symbol_3 * tint_symbol_10.tint_symbol_1)) - (tint_symbol_9.tint_symbol_4 * tint_symbol_10.tint_symbol_2)), ((((tint_symbol_9.tint_symbol_1 * tint_symbol_10.tint_symbol_4) - (tint_symbol_9.tint_symbol_2 * tint_symbol_10.tint_symbol_3)) + (tint_symbol_9.tint_symbol_3 * tint_symbol_10.tint_symbol_2)) + (tint_symbol_9.tint_symbol_4 * tint_symbol_10.tint_symbol_1)));
}

fn tint_symbol_11(tint_symbol_9_1 : tint_symbol) -> tint_symbol {
  return tint_symbol(tint_symbol_9_1.tint_symbol_1, -(tint_symbol_9_1.tint_symbol_2), -(tint_symbol_9_1.tint_symbol_3), -(tint_symbol_9_1.tint_symbol_4));
}

fn tint_symbol_12(tint_symbol_13 : tint_symbol, tint_symbol_14 : tint_symbol) -> tint_symbol {
  let x_115 = tint_symbol_11(tint_symbol_14);
  let x_116 = tint_symbol_8(tint_symbol_13, x_115);
  let x_117 = tint_symbol_8(tint_symbol_14, x_116);
  return x_117;
}

fn tint_symbol_15(tint_symbol_13_1 : vec2f, tint_symbol_14_1 : tint_symbol) -> vec2f {
  let x_123 = tint_symbol_12(tint_symbol(0.0f, 1.0f, tint_symbol_13_1.x, tint_symbol_13_1.y), tint_symbol_14_1);
  return vec2f((x_123.tint_symbol_3 / x_123.tint_symbol_2), (x_123.tint_symbol_4 / x_123.tint_symbol_2));
}

fn tint_mod(lhs : u32, rhs : u32) -> u32 {
  return (lhs % select(rhs, 1u, (rhs == 0u)));
}

fn tint_div(lhs_1 : u32, rhs_1 : u32) -> u32 {
  return (lhs_1 / select(rhs_1, 1u, (rhs_1 == 0u)));
}

fn tint_symbol_26_inner(tint_symbol_24 : vec2f, tint_symbol_27 : u32) -> tint_symbol_23 {
  var tint_symbol_40 = tint_symbol_23(vec4f(), 0.0f);
  let x_163 = tint_symbol_22.inner.tint_symbol_18[0i];
  let x_165 = tint_symbol_22.inner.tint_symbol_18.y;
  let x_168 = tint_symbol_22.inner.tint_symbol_18.z;
  let x_173 = (tint_symbol_22.inner.tint_symbol_18.w / 2.0f);
  let x_175 = tint_ftou(x_163);
  let x_174 = tint_mod(tint_symbol_27, x_175);
  let x_177 = tint_ftou(x_163);
  let x_176 = tint_div(tint_symbol_27, x_177);
  let x_182 = vec2f((f32(x_174) / x_165), (f32(x_176) / x_163));
  let x_197 = tint_symbol_19.inner.tint_symbol_6;
  let x_194 = tint_symbol_11(x_197);
  let x_198 = tint_symbol_15((vec2f((tint_symbol_24.x / x_165), (tint_symbol_24.y / x_163)) + vec2f((x_168 * x_182.x), (x_168 * x_182.y))), x_194);
  let x_202 = (x_198 * tint_symbol_19.inner.tint_symbol_7);
  tint_symbol_40.tint_symbol_24 = vec4f(x_202.x, x_202.y, 0.0f, 1.0f);
  tint_symbol_40.tint_symbol_25 = f32(tint_symbol_20.inner[tint_symbol_27]);
  let x_217 = tint_symbol_40;
  return x_217;
}

fn tint_symbol_26_1() {
  let x_223 = tint_symbol_24_1;
  let x_224 = tint_symbol_27_1;
  let x_222 = tint_symbol_26_inner(x_223, x_224);
  tint_symbol_24_2 = x_222.tint_symbol_24;
  tint_symbol_25_1 = x_222.tint_symbol_25;
  return;
}

struct tint_symbol_26_out {
  @builtin(position)
  tint_symbol_24_2_1 : vec4f,
  @location(0)
  tint_symbol_25_1_1 : f32,
}

@vertex
fn vertexMain(@location(0) tint_symbol_24_1_param : vec2f, @builtin(instance_index) tint_symbol_27_1_param : u32) -> tint_symbol_26_out {
  tint_symbol_24_1 = tint_symbol_24_1_param;
  tint_symbol_27_1 = tint_symbol_27_1_param;
  tint_symbol_26_1();
  return tint_symbol_26_out(tint_symbol_24_2, tint_symbol_25_1);
}

fn tint_symbol_41_inner(tint_symbol_25 : f32) -> vec4f {
  return (vec4f(0.93333333730697631836f, 0.46274510025978088379f, 0.13725490868091583252f, 1.0f) * tint_symbol_25);
}

fn tint_symbol_41_1() {
  let x_239 = tint_symbol_25_2;
  let x_238 = tint_symbol_41_inner(x_239);
  value = x_238;
  return;
}

struct tint_symbol_41_out {
  @location(0)
  value_1 : vec4f,
}

@fragment
fn fragmentMain(@location(0) tint_symbol_25_2_param : f32) -> tint_symbol_41_out {
  tint_symbol_25_2 = tint_symbol_25_2_param;
  tint_symbol_41_1();
  return tint_symbol_41_out(value);
}

fn tint_symbol_42_inner(tint_symbol_37 : vec3u) {
  var x_283 : bool;
  var x_284 : bool;
  let x_246 = tint_symbol_22.inner.tint_symbol_18[0i];
  let x_244 = tint_ftou(x_246);
  let x_249 = tint_symbol_22.inner.tint_symbol_18.y;
  let x_247 = tint_ftou(x_249);
  let x_250 = tint_symbol_37.x;
  let x_251 = tint_symbol_37.y;
  let x_274 = (((tint_symbol_20.inner[((x_251 * x_244) + (x_250 + 1u))] + tint_symbol_20.inner[((x_251 * x_244) + (x_250 - 1u))]) + tint_symbol_20.inner[(((x_251 + 1u) * x_247) + x_250)]) + tint_symbol_20.inner[(((x_251 - 1u) * x_247) + x_250)]);
  let x_276 = ((x_251 * x_247) + x_250);
  let x_278 = (x_274 < 2u);
  x_284 = x_278;
  if (x_278) {
    x_283 = (tint_symbol_20.inner[x_276] == 1u);
    x_284 = x_283;
  }
  var x_293 : bool;
  var x_294 : bool;
  var x_299 : bool;
  var x_300 : bool;
  if (x_284) {
    tint_symbol_21.inner[x_276] = 0u;
  } else {
    let x_289 = (x_274 == 2u);
    x_294 = x_289;
    if (x_289) {
    } else {
      x_293 = (x_274 == 3u);
      x_294 = x_293;
    }
    x_300 = x_294;
    if (x_294) {
      x_299 = (tint_symbol_20.inner[x_276] == 1u);
      x_300 = x_299;
    }
    var x_310 : bool;
    var x_311 : bool;
    if (x_300) {
      tint_symbol_21.inner[x_276] = 1u;
    } else {
      let x_305 = (x_274 > 3u);
      x_311 = x_305;
      if (x_305) {
        x_310 = (tint_symbol_20.inner[x_276] == 1u);
        x_311 = x_310;
      }
      var x_321 : bool;
      var x_322 : bool;
      if (x_311) {
        tint_symbol_21.inner[x_276] = 0u;
      } else {
        let x_316 = (x_274 == 2u);
        x_322 = x_316;
        if (x_316) {
          x_321 = (tint_symbol_20.inner[x_276] == 0u);
          x_322 = x_321;
        }
        if (x_322) {
          tint_symbol_21.inner[x_276] = 1u;
        } else {
          tint_symbol_21.inner[x_276] = 0u;
        }
      }
    }
  }
  return;
}

fn tint_symbol_42_1() {
  let x_331 = tint_symbol_37_1;
  tint_symbol_42_inner(x_331);
  return;
}

@compute @workgroup_size(20i, 10i, 1i)
fn computeMain(@builtin(global_invocation_id) tint_symbol_37_1_param : vec3u) {
  tint_symbol_37_1 = tint_symbol_37_1_param;
  tint_symbol_42_1();
}
