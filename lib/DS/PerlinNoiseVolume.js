import PerlinNoise from  '/lib/Math/Noises.js'

export default class PerlinNoiseVolume {
    // Note: Volume Data comes from Brainweb: https://brainweb.bic.mni.mcgill.ca
    constructor(max_value, voxel_size, x, y, z) {
      this.max_value = max_value;
      this.x = x;
      this.y = y;
      this.z = z;
      this._dims = [x, y, z];
      this._sizes = [voxel_size, voxel_size, voxel_size];
      this._data = [];
      this._perlinNoise = new PerlinNoise(); // create an object for generating perline noise
      this._data = Array(this._dims[0] * this._dims[1] * this._dims[2]).fill(0); // init values to 0s
      // Then fill it the volume data with noise
      for (let z = 0; z < this._dims[2]; ++z) {
        for (let y = 0; y < this._dims[1]; ++y) {
          for (let x = 0; x < this._dims[0]; ++x) {
            let noise = (this._perlinNoise.noise3d(x, y, z) + 2) / 4; // remap to [0, 1]
            this._data[z * (this._dims[0] * this._dims[1]) + y * this._dims[0] + x] = noise;
          }
        }
      }
      
    }
    
    async init() {
      // dummy function so I dont have to change things
    }
}