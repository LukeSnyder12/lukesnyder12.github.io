export default class SphereVolumeData {
    // Note: Volume Data comes from Brainweb: https://brainweb.bic.mni.mcgill.ca
    constructor(radius, center, voxel_size, x, y, z) {
      this.radius = radius;
      this.x = x;
      this.y = y;
      this.z = z;
      this._dims = [x, y, z];
      this._sizes = [voxel_size, voxel_size, voxel_size];
      this._data = [];
      for (var i = 0; i < x; i++){
        for (var j = 0; j < y; j++){
            for (var k = 0; k < z; k++){
                
                if ((i - center[0])**2 + (j - center[1])**2 + (k - center[2])**2 <= radius**2){
                    this._data.push(10000);
                }
                else{
                    this._data.push(0);
                }
            }
        }
      }
      
    }
    
    async init() {
      // dummy function so I dont have to change things
    }
}