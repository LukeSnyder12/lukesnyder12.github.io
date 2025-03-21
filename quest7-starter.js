/*!
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

// Check your browser supports: https://github.com/gpuweb/gpuweb/wiki/Implementation-Status#implementation-status
// Need to enable experimental flags chrome://flags/
// Chrome & Edge 113+ : Enable Vulkan, Default ANGLE Vulkan, Vulkan from ANGLE, Unsafe WebGPU Support, and WebGPU Developer Features (if exsits)
// Firefox Nightly: sudo snap install firefox --channel=latext/edge or download from https://www.mozilla.org/en-US/firefox/channel/desktop/

import RayTracer from '/lib/Viz/RayTracer.js'
import StandardTextObject from '/lib/DSViz/StandardTextObject.js'
import VolumeRenderingSimpleObject from '/lib/DSViz/VolumeRenderingSimpleObject.js'
import Camera from '/lib/Viz/3DCamera.js'
import VolumeData from "/lib/DS/VolumeData.js"
import RandomVolumeData from "/lib/DS/RandomVolumeData.js";
import SphereVolumeData from "/lib/DS/SphereVolumneData.js";
import PerlinNoiseVolume from './lib/DS/PerlinNoiseVolume.js'

async function init() {
  // Create a canvas tag
  const canvasTag = document.createElement('canvas');
  canvasTag.id = "renderCanvas";
  document.body.appendChild(canvasTag);
  // Create a ray tracer
  const tracer = new RayTracer(canvasTag);
  await tracer.init();
  // Create a 3D Camera
  var camera = new Camera();
  // Create an object to trace
  
  var xDim = 181;
  var yDim = 217;
  var zDim = 181;
  
  var brainVolume = new VolumeData('/assets/brainweb-t1-1mm-pn0-rf0.raws');
  var randomVolume = new RandomVolumeData(4095, 1, 300, 217, 181);
  var sphereVolume = new SphereVolumeData(75, [xDim/2, yDim/2, zDim/2], 1, xDim, yDim, zDim);
  var perlinVolume = new PerlinNoiseVolume(4095, 1, xDim, yDim, zDim);
  var volumes = [brainVolume, randomVolume, sphereVolume, perlinVolume];
  var volumeIndex = 0;
  var tracerObj = new VolumeRenderingSimpleObject(tracer._device, tracer._canvasFormat, camera, volumes[volumeIndex]);
  await tracer.setTracerObject(tracerObj);
  
  let fps = '??';
  var fpsText = new StandardTextObject('fps: ' + fps +"\nad: Move x\nws: Move y\nqe: Move z\njl: Rotate x\nik: Rotate y\nuo: Rotate z\nzx: Change Focal\nc: Camera Type\nv: change volume\neasier to see in ortho\nb: change march setting");

  const moveStep = .1;
  const angleStep = 2;
  const focalStep = .1;
  window.addEventListener("keydown", (e) => {
    switch (e.key) {
      case 'ArrowUp': case 'w': case 'W': //positive x axis
        camera.moveY(moveStep);
        break;
      case 'ArrowDown': case 's': case 'S':   //negative x axis
        camera.moveY(-moveStep);
        break;
      case 'ArrowLeft': case 'a': case 'A':  //negative y axis
        camera.moveX(-moveStep);
        break;
      case 'ArrowRight': case 'd': case 'D': //negative y axis
        camera.moveX(moveStep);
        break;
      case 'q': case 'Q':  //negative z axis
        camera.moveZ(-moveStep);
        break;
      case 'e': case 'E': //positive z axis
        camera.moveZ(moveStep);
        break;
      case 'f': case 'F': fpsText.toggleVisibility(); break;
      case 'i': case 'I': 
        camera.rotateY(angleStep);
        break;
      case 'k': case 'K': 
        camera.rotateY(-angleStep);
        break;
      case 'j': case 'J': 
        camera.rotateX(-angleStep);
        break;
      case 'l': case 'L':
        camera.rotateX(angleStep);
        break;
      case 'u': case 'U':
        camera.rotateZ(-angleStep);
        break;
      case 'o': case 'O':
        camera.rotateZ(angleStep);
        break;
      case 'z': case 'Z':
        camera.changeFocal(-focalStep);
        tracerObj.updateCameraFocal();
        break;
      case 'x': case 'X':
        camera.changeFocal(focalStep);
        tracerObj.updateCameraFocal();
        break;
      case 'c': case 'C':
        camera.toggleCameraType();
        break;
      case 'v': case 'V':
        volumeIndex = (volumeIndex+1) % volumes.length;
        tracerObj.recreateGeometry(volumes[volumeIndex])
        break;
      case 'b': case 'B':
        tracerObj.changeRenderSetting();
    }
    tracerObj.updateCameraPose(camera._pose);
});
  // run animation at 60 fps
  var frameCnt = 0;
  var tgtFPS = 60;
  var secPerFrame = 1. / tgtFPS;
  var frameInterval = secPerFrame * 1000;
  var lastCalled;
  let renderFrame = () => {
    let elapsed = Date.now() - lastCalled;
    if (elapsed > frameInterval) {
      ++frameCnt;
      lastCalled = Date.now() - (elapsed % frameInterval);
      tracer.render();
    }
    requestAnimationFrame(renderFrame);
  };
  lastCalled = Date.now();
  renderFrame();
  setInterval(() => { 
    fpsText.updateText('fps: ' + frameCnt +"\nad: Move x\nws: Move y\nqe: Move z\njl: Rotate x\nik: Rotate y\nuo: Rotate z\nzx: Change Focal\nc: Camera Type\nv: change volume\neasier to see in ortho\nb: change march setting");
    frameCnt = 0;
  }, 1000); // call every 1000 ms
  return tracer;
}

init().then( ret => {
  console.log(ret);
}).catch( error => {
  const pTag = document.createElement('p');
  pTag.innerHTML = navigator.userAgent + "</br>" + error.message;
  document.body.appendChild(pTag);
  document.getElementById("renderCanvas").remove();
});