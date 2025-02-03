import Standard2DPGAPosedVertexColorObject from "/lib/DSViz/Standard2DPGAPosedVertexColorObject.js"
import PGA2D from "/lib/Math/PGA2D.js"
export default class CircleObject extends Standard2DPGAPosedVertexColorObject {
  constructor(device, canvasFormat, pose, numTriangles, radius, x, y, r, g, b, orbit, step) {

    let _vertices = [];
    

    // Calculate angle step for each triangle
    const angleStep = (2 * Math.PI) / numTriangles;

    for (let i = 0; i < numTriangles; i++) {
        // Angle for the current and next triangle
        const currentAngle = i * angleStep;
        const nextAngle = (i + 1) * angleStep;

        // Calculate points of the triangle with normalized coordinates
        const x2 = x + radius * Math.cos(currentAngle);
        const y2 = y + radius * Math.sin(currentAngle);

        const x3 = x + radius * Math.cos(nextAngle);
        const y3 = y + radius * Math.sin(nextAngle);

        // Add the triangle's vertices to the list
        _vertices.push(
            x, y, r, g, b, 1, // Center vertex
            x2, y2, r, g, b, 1, // Current edge vertex
            x3, y3, r, g, b, 1  // Next edge vertex
        );
    }

    _vertices = new Float32Array(_vertices);
    super(device, canvasFormat, _vertices, pose);
    this._interval = 100;
    this._t = 0;
    this._step = step;
    this._pose0 = pose;
    this._pose1 = [pose[0], pose[1], pose[2], pose[2], pose[3], pose[4]];
    this._doesOrbit = orbit;
  }
 

  updateGeometry() {
    // linearly interpolate the motor
    if (this._doesOrbit){

        
        // this._pose[0] = this._pose0[0] * (1 - this._t / this._interval) + this._pose1[0] * this._t / this._interval;
        // this._pose[1] = this._pose0[1] * (1 - this._t / this._interval) + this._pose1[1] * this._t / this._interval;
        // this._pose[2] = this._pose0[2] * (1 - this._t / this._interval) + this._pose1[2] * this._t / this._interval;
        // this._pose[3] = this._pose0[3] * (1 - this._t / this._interval) + this._pose1[3] * this._t / this._interval;
        // interpolating back and forth
        const angle = 2 * Math.PI * this._step /100;
        const rotor = PGA2D.createRotor(angle);
        const new_pose = PGA2D.geometricProduct(rotor, this._pose);
        this._pose = new Float32Array([...new_pose, this._pose[4], this._pose[5]]);
    }
    
    super.updateGeometry();
  }
}