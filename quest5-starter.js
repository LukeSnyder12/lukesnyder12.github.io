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

import Renderer from '/lib/Viz/2DRenderer.js'
import PolygonObject from '/lib/DSViz/PolygonObject.js'
import StandardTextObject from '/lib/DSViz/StandardTextObject.js'

async function init() {
  // Create a canvas tag
  const canvasTag = document.createElement('canvas');
  canvasTag.id = "renderCanvas";
  document.body.appendChild(canvasTag);
  // Create a 2d animated renderer
  const renderer = new Renderer(canvasTag);
  await renderer.init();
  // const polygon = new PolygonObject(renderer._device, renderer._canvasFormat, '/assets/box.polygon');
  // const circle = new PolygonObject(renderer._device, renderer._canvasFormat, '/assets/circle.polygon');
  const polygon = new PolygonObject(renderer._device, renderer._canvasFormat, '/assets/human.polygon');
  await renderer.appendSceneObject(polygon);
  // await renderer.appendSceneObject(circle);
  // await renderer.appendSceneObject(dense);
  let fps = '??';
  
  
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
      renderer.render();
    }
    requestAnimationFrame(renderFrame);
  };
  var mouseX = 0;
  var mouseY = 0;
  canvasTag.addEventListener('mousemove', async (e) => {
    mouseX = (e.clientX / window.innerWidth) * 2 - 1;
    mouseY = (-e.clientY / window.innerHeight) * 2 + 1;
    
  });
  var tree_result = false;
  var gpu_result = false;

  var fpsText = new StandardTextObject('fps: ' + fps + "\ngpu result: " + gpu_result + "\ncpu tree result: " + tree_result);

  lastCalled = Date.now();
  renderFrame();
  setInterval(() => { 
    fpsText.updateText('fps: ' + frameCnt + "\ngpu result: " + gpu_result + "\ncpu tree result: " + tree_result);
    frameCnt = 0;
  }, 75); // call every 1000 ms


  setInterval(async () => { 
    polygon.startTest(mouseX, mouseY);
    await sleep(75);
    tree_result = polygon._tree.testPointInside(mouseX, mouseY);
    gpu_result = await polygon.read_stagebuffer();
    console.log("gpu result: " + gpu_result, ", cpu tree result: " + tree_result);
  }, 90); // call every 1000 ms
  return renderer;
}

init().then( ret => {
  console.log(ret);
}).catch( error => {
  const pTag = document.createElement('p');
  pTag.innerHTML = navigator.userAgent + "</br>" + error.message;
  document.body.appendChild(pTag);
  document.getElementById("renderCanvas").remove();
});


function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}