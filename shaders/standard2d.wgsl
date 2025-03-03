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
struct Vert{
  pos: vec2f
}

@group(0) @binding(0) var<uniform> mouseIn: Vert;
@group(0) @binding(1) var<storage> vertexIn: array<Vert>;
@group(0) @binding(2) var<storage, read_write> windingOut: array<f32>;


@vertex // this compute the scene coordinate of each input vertex
fn vertexMain(@location(0) pos: vec2f) -> @builtin(position) vec4f {
  return vec4f(pos, 0, 1); // (pos, Z, W) = (X, Y, Z, W)
}

// @vertex // this compute the scene coordinate of each input vertex
// fn vertexMain(@builtin(instance_index) idx: u32, @builtin(vertex_index) vIdx: u32) -> @builtin(position) vec4f {
//   let pos = vertexIn[idx].pos;
//   return vec4f(pos[0], pos[1], 0, 1); // (pos, Z, W) = (X, Y, Z, W)
// }

@fragment // this compute the color of each pixel
fn fragmentMain() -> @location(0) vec4f {
  return vec4f(238.f/255, 118.f/255, 35.f/255, 1); // (R, G, B, A)
}

@compute @workgroup_size(256)
fn computeMain(@builtin(global_invocation_id) gid: vec3<u32>){
  let idx = gid.x;
  if (idx < arrayLength(&vertexIn)) {
    var mouseX = mouseIn.pos[0];
    var mouseY = mouseIn.pos[1];
    var pos = vec2f(mouseX, mouseY);
    for(var i = 0; i < i32(arrayLength(&vertexIn)-1); i++){
      var v1 = vertexIn[i];
      var v2 = vertexIn[i+1];
      //check if mouseY is between the two y coords for the verticies, if not dont check them
      if ((v1.pos[1] <= mouseY && mouseY <= v2.pos[1]) || (v2.pos[1] <= mouseY && mouseY <= v1.pos[1])){
        //perform triangle test for inside/outside
        var pIn = Vert(vec2f(mouseX, mouseY));
        var answer = isInside(v1, v2, pIn);
        //check to see if this is to the right or to the left to adjust the correct winding number
        var xAvg = (v1.pos[0] + v2.pos[0])/2;
        if (mouseX < xAvg){
          if (answer > 0){
            windingOut[0] += 1;
          }
          else{
            windingOut[0] -= 1;
          }
        }
        else{
          if (answer > 0){
            windingOut[1] += 1;
          }
          else{
            windingOut[1] -= 1;
          }
        } 
      }
    }
  }
}

fn isInside(in1: Vert, in2: Vert, pIn: Vert) -> f32{
    var v0 = in1.pos;
    var v1 = in2.pos;
    var p = pIn.pos;
    return (v1[0] - v0[0]) * (p[1] - v0[1]) - (v1[1] - v0[1]) * (p[0] - v0[0]);
  }