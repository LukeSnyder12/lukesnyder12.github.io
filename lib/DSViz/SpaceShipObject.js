import Standard2DPGAPosedVertexColorObject from "/lib/DSViz/Standard2DPGAPosedVertexColorObject.js"
import PGA2D from "/lib/Math/PGA2D.js"
export default class SpaceShipObject extends Standard2DPGAPosedVertexColorObject {
  constructor(device, canvasFormat, pose, x, y, width, height, step) {
    
    let _vertices = [
      //silver rectangular body
      //x, y, r, g, b, a
      x, y, 192/256, 192/256 , 192/256, 1,
      x+width, y, 192/256, 192/256 , 192/256, 1,
      x+width, y+height, 192/256, 192/256 , 192/256, 1,

      x, y, 192/256, 192/256 , 192/256, 1,
      x,y+height, 192/256, 192/256 , 192/256, 1,
      x+width, y+height, 192/256, 192/256 , 192/256, 1,

      //red cap
      x - width/5, y+height, 1,0,0,1,
      x + width + width/5, y+height, 1,0,0,1,
      x + width/2, y+ 3 * height/2, 1,0,0,1,
    ];

    //add "circle" windows
    const numTriangles = 10;
    const radius = width/4;
    let centerX = x+ width/2;
    let centerY = y + 4 * height/5;
    
    const angleStep = (2 * Math.PI) / numTriangles;
    for (let i = 0; i < numTriangles; i++) {
      // Angle for the current and next triangle
      const currentAngle = i * angleStep;
      const nextAngle = (i + 1) * angleStep;

      // Calculate points of the triangle with normalized coordinates
      const x2 = centerX + radius * Math.cos(currentAngle);
      const y2 = centerY + radius * Math.sin(currentAngle);

      const x3 = centerX + radius * Math.cos(nextAngle);
      const y3 = centerY + radius * Math.sin(nextAngle);

      // Add the triangle's vertices to the list
      _vertices.push(
          centerX, centerY, 0, 0, 0, .1, // Center vertex
          x2, y2, 0, 0, 0, .1, // Current edge vertex
          x3, y3, 0, 0, 0, 1  // Next edge vertex
      );
    }

    centerY = y + 2 * height/5;
    for (let i = 0; i < numTriangles; i++) {
      // Angle for the current and next triangle
      const currentAngle = i * angleStep;
      const nextAngle = (i + 1) * angleStep;

      // Calculate points of the triangle with normalized coordinates
      const x2 = centerX + radius * Math.cos(currentAngle);
      const y2 = centerY + radius * Math.sin(currentAngle);

      const x3 = centerX + radius * Math.cos(nextAngle);
      const y3 = centerY + radius * Math.sin(nextAngle);

      // Add the triangle's vertices to the list
      _vertices.push(
          centerX, centerY, 0, 0, 0, .1, // Center vertex
          x2, y2, 0, 0, 0, .1, // Current edge vertex
          x3, y3, 0, 0, 0, 1  // Next edge vertex
      );
    }
    
    _vertices = new Float32Array(_vertices);
    super(device, canvasFormat, _vertices, pose);
    this._interval = 100;
    this._t = 0;
    this._step = step;
    this._pose0 = [-1, 0, 0.5, 0.5, 0.5, 0.5];
    //rotate the ship 90 degrees
    let rotor = PGA2D.createRotor(-Math.PI/4, x, y);
    const new_pose = PGA2D.geometricProduct(rotor, this._pose0);
    const p1 = PGA2D.createPoint(.2, .2);
    const p2 = PGA2D.createPoint(.4, .05);
    const p3 = PGA2D.createPoint(.1, .05);
    this._interpolatePose = [p1, p2, p3];
    this.i = 0;
    
  }
 

  updateGeometry() {
    // linearly interpolate the motor, 0 <= t <= 33 is first phase, 34 to 66 is second pase, 67 to 100 is final phase
    this._t += this._step;
    const division = this._interval / this._interpolatePose.length;
    
    let s = this.i;
    let e = (this.i + 1) % this._interpolatePose.length;
    this._pose[0] = this._interpolatePose[s][0] * (1 - this._t / this._interval) + this._interpolatePose[e][0] * this._t / this._interval;
    this._pose[1] = this._interpolatePose[s][1] * (1 - this._t / this._interval) + this._interpolatePose[e][1] * this._t / this._interval;
    this._pose[2] = this._interpolatePose[s][2] * (1 - this._t / this._interval) + this._interpolatePose[e][2] * this._t / this._interval;
    this._pose[3] = this._interpolatePose[s][3] * (1 - this._t / this._interval) + this._interpolatePose[e][3] * this._t / this._interval;
    // interpolating back and forth
    this._t += this._step;
    if (this._t >= 100) {
      this._t = 0;
      this.i = (this.i + 1) % this._interpolatePose.length;
    }
    super.updateGeometry();
    
    super.updateGeometry();
  }
}