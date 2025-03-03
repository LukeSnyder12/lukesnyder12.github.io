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

import SceneObject from "/lib/DSViz/SceneObject.js"
import Polygon from "/lib/DS/Polygon.js"
import TreeGrid from "/lib/DS/TreeGrid.js";

export default class PolygonObject extends SceneObject {
  constructor(device, canvasFormat, filename) {
    super(device, canvasFormat);
    this._polygon = new Polygon(filename);
    
  }
  
  async createGeometry() {
    // Read vertices from polygon files
    await this._polygon.init();
    console.log("init tree");
    this._tree = new TreeGrid(this._polygon._polygon, 4);
    this._numV = this._polygon._numV;
    this._dim = this._polygon._dim;
    this._vertices = this._polygon._polygon.flat();
    this._inside = false;
    // Create vertex buffer to store the vertices in GPU
    this._vertexBuffer = this._device.createBuffer({
      label: "Vertices Normals and More " + this.getName(),
      size: this._vertices.length * Float32Array.BYTES_PER_ELEMENT,
      usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST | GPUBufferUsage.VERTEX,
      mappedAtCreation: true
    });
    // Copy from CPU to GPU
    new Float32Array(this._vertexBuffer.getMappedRange()).set(this._vertices);
    this._vertexBuffer.unmap();
    // Defne vertex buffer layout - how the GPU should read the buffer
    this._vertexBufferLayout = {
      arrayStride: this._dim * Float32Array.BYTES_PER_ELEMENT,
      attributes: [
      { // vertices
        format: "float32x"+this._dim.toString(), // 32 bits, each has two/three coordiantes
        offset: 0,
        shaderLocation: 0, // position in the vertex shader
        
      },
      ]
    };

    this._mouse = new Float32Array([0,0]);
    this._mouseBuffer = this._device.createBuffer({
      label: "mouse coord buffer",
      size: this._mouse.length * Float32Array.BYTES_PER_ELEMENT,
      usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST
    })
    this._device.queue.writeBuffer(this._mouseBuffer, 0, this._mouse);

    this._windingBuffer = this._device.createBuffer({
      label: "winding buffer",
      size: this._mouse.length * this._mouse.BYTES_PER_ELEMENT,
      usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_SRC | GPUBufferUsage.COPY_DST
    });
    this._device.queue.writeBuffer(this._windingBuffer, 0, new Int32Array([0, 0]));

    this._stageBuffer = this._device.createBuffer({
      label: "stage buffer",
      size: this._mouse.length * this._mouse.BYTES_PER_ELEMENT,
      usage: GPUBufferUsage.MAP_READ | GPUBufferUsage.COPY_DST,
    });
    this._device.queue.writeBuffer(this._stageBuffer, 0, new Int32Array([0, 0]));
  }
  
  async createShaders() {
    let shaderCode = await this.loadShader("/shaders/standard2d.wgsl");
    this._shaderModule = this._device.createShaderModule({
      label: "Shader " + this.getName(),
      code: shaderCode,
    }); 

    
    this._bindGroupLayout = this._device.createBindGroupLayout({
      label: "Mouse Bind Group Layout " + this.getName(),
      entries: [{
        binding: 0,
        visibility: GPUShaderStage.COMPUTE,
        buffer: {type: "uniform"} // mouse uniform buffer
      }, {
        binding: 1,
        visibility: GPUShaderStage.VERTEX | GPUShaderStage.COMPUTE,
        buffer: { type: "read-only-storage"} // vertex input
      }, {
        binding: 2,
        visibility: GPUShaderStage.COMPUTE,
        buffer: {type: "storage"} //stage buffer
      }]
    });
    this._pipelineLayout = this._device.createPipelineLayout({
      label: "Grid Pipeline Layout",
      bindGroupLayouts: [ this._bindGroupLayout ],
    });
  }
  
  async createRenderPipeline() {
    this._renderPipeline = this._device.createRenderPipeline({
      label: "Render Pipeline " + this.getName(),
      layout: this._pipelineLayout,
      vertex: {
        module: this._shaderModule,     // the shader code
        entryPoint: "vertexMain",          // the shader function
        buffers: [this._vertexBufferLayout] // the binded buffer layout
      },
      fragment: {
        module: this._shaderModule,     // the shader code
        entryPoint: "fragmentMain",        // the shader function
        targets: [{
          format: this._canvasFormat        // the target canvas format
        }]
      },
      primitive: {
        topology: 'line-strip'
      }
    }); 
    this._bindGroup = this._device.createBindGroup({
      label: "Renderer Bind Group 1 " + this.getName(),
      layout: this._renderPipeline.getBindGroupLayout(0),
      entries: [{
        binding: 0,
        resource: { buffer: this._mouseBuffer }
      }, {
        binding: 1,
        resource: { buffer: this._vertexBuffer }
      }, {
        binding: 2,
        resource: {buffer: this._windingBuffer}
      }]});
  }
  
  render(pass) {
    // add to render pass to draw the plane
    pass.setPipeline(this._renderPipeline);
    pass.setVertexBuffer(0, this._vertexBuffer); // bind the vertex buffer
    pass.setBindGroup(0, this._bindGroup);    
    pass.draw(this._numV);         // draw all vertices
  }
  
  async createComputePipeline() {
    // Create a compute pipeline that updates the game state.
    this._computePipeline = this._device.createComputePipeline({
      label: "Grid update pipeline " + this.getName(),
      layout: this._pipelineLayout,
      compute: {
        module: this._shaderModule,
        entryPoint: "computeMain",
      }
    });
  }
  
  compute(pass) {
    this.createComputePipeline();
    pass.setPipeline(this._computePipeline);
    pass.setBindGroup(0, this._bindGroup);     // bind the uniform buffer
    pass.dispatchWorkgroups(Math.ceil(this._polygon._polygon.length / 256)); // sending how many instances to compute for each work group
    this.read_stagebuffer();
  }

  async read_stagebuffer(){
    let encoder = this._device.createCommandEncoder();
    if (this._stageBuffer.mapState != "unmapped"){
      // console.log("buffer not ready");
      return this._inside; // use the last result while waiting for the stage buffer to be ready
    } 
    
    encoder.copyBufferToBuffer(this._windingBuffer, 0, this._stageBuffer, 0, 8); // this line use the command encoder to copy from the GPU storage buffer named this._windingNumberBuffer to the stage buffer this._stageBuffer with offset 0 and total 8 bytes
    this._device.queue.submit([encoder.finish()]); // submit all GPU commands, now it will include the command to copy the results back to CPU
    await this._stageBuffer.mapAsync(GPUMapMode.READ); // this line map the buffer to read the result
    var windingNumber = new Int32Array(this._stageBuffer.getMappedRange()); // this line cast the result back to javascritp array
    
    this._inside = windingNumber[0] != 0 && windingNumber[1] != 0; // this is how we use the winding number to check if it is inside
    if (windingNumber[0] > 100)
      windingNumber[0] = 100;
    if (windingNumber[1] > 100)
      windingNumber[1] = 100;
    // console.log("windingNumber: " + windingNumber, ", inside: " + this._inside);
    this._stageBuffer.unmap(); // this asks the GPU to unmap it for later use
    return this._inside;
  }

  startTest(x, y){
    
    this._device.queue.writeBuffer(this._windingBuffer, 0, new Int32Array([0, 0]));
    this._device.queue.writeBuffer(this._mouseBuffer, 0, new Float32Array([x, y]));
  }
}
