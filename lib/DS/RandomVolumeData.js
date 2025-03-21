export default class RandomVolumeData {
    // Note: Volume Data comes from Brainweb: https://brainweb.bic.mni.mcgill.ca
    constructor(max_value, voxel_size, x, y, z) {
      this.max_value = max_value;
      this.x = x;
      this.y = y;
      this.z = z;
      this._dims = [x, y, z];
      this._sizes = [voxel_size, voxel_size, voxel_size];
      this._data = [];
      for (var i = 0; i < x * y * z; i++){
        this._data.push(Math.random() * max_value);
        // this._data.push(4095);
      }
      
    }
    
    async init() {
      // dummy function so I dont have to change things
    }
}

