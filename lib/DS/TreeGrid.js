import PGA2D from "/lib/Math/PGA2D.js"

export default class TreeGrid{
    static EXTERIOR = 'exterior';
    static INTERIOR = 'interior';
    static MIXED = 'mixed';
    static UNKNOWN = 'unknown';

    constructor(polygon, max_depth) {
        this._polygon = JSON.parse(JSON.stringify(polygon)); // deep copy the input polygon
        if (this._polygon[0].length != 2) throw new Error("TwoDGrid works only for 2D Polygons.");
        this.max_depth = max_depth;
        if (Math.floor(this.max_depth) != this.max_depth || this.max_depth < 1) throw new Error("Tree depth must be an integer greater than 0.");
        this.root = new Node([-1, -1], [1, 1], this._polygon);
        console.log("root created");
        this.createTree(this.root, 0);
        console.log("tree created");
        this.root.computeStatus(this._polygon);
        console.log("status computed");
    }

    createTree(root, depth){
        //stop creating new children if you are either empty or run out of depth
        if (depth > this.max_depth){
            return;
        }
        //only create children if we are mixed
        if (this.status == TreeGrid.MIXED){
            //split the current root into its 4 sections
            var xdist = (root.rtop[0] - root.lbot[0])/2;
            var ydist = (root.rtop[1] - root.lbot[1])/2;
            var halfHeight = root.lbot[1] + ydist;
            var halfWidth = root.lbot[0] + xdist;
            //left bottom
            root.botleftNode = new Node(root.lbot, [halfWidth, halfHeight], this._polygon);
            this.createTree(root.botleftNode, depth + 1);
            //right bottom
            root.botrightNode = new Node([halfWidth, root.lbot[1]], [root.rtop[0], halfHeight], this._polygon);
            this.createTree(root.botrightNode, depth + 1);
            //left top
            root.topleftNode = new Node([root.lbot[0], halfHeight], [halfWidth, root.rtop[1]], this._polygon);
            this.createTree(root.topleftNode, depth + 1);
            //right top
            root.toprightNode = new Node([halfWidth, halfHeight], root.rtop, this._polygon);
            this.createTree(root.toprightNode, depth + 1);
        }
        
    }

    testPointInside(x, y){
        return this.root.searchChildren(x, y, this._polygon);
    }
}

class Node{
    
    constructor(lbot, rtop, polygon){
        this.lbot = lbot;
        this.rtop = rtop;

        this.botleftNode = null;
        this.botrightNode = null;
        this.topleftNode = null;
        this.toprightNode = null;
        this.status = TreeGrid.UNKNOWN
        this.checkIfContainsEdges(polygon);
        // this.printBounds();
    }

    checkIfContainsEdges(polygon){
        for (var i = 0; i < polygon.length-1; i++){
            var v1 = polygon[i];
            var v2 = polygon[i+1];
            
            //check if v1 falls within boundaries
            if (this.pointInBounds(v1)){
                this.status = TreeGrid.MIXED;
                return;
            }//check if v2 is within boundaries
            if (this.pointInBounds(v2)){
                this.status = TreeGrid.MIXED;
                return;
            }
        }
    }

    searchChildren(x, y, polygon){
        // this.printBounds();
        //if we are mixed, we need to check if we have children to search
        if (this.status == TreeGrid.MIXED && this.botleftNode != null){
            var point = [x, y];
            if (this.botleftNode.pointInBounds(point)){
                return this.botleftNode.searchChildren(x, y, polygon);
            }
            if (this.botrightNode.pointInBounds(point)){
                return this.botrightNode.searchChildren(x, y, polygon);
            }
            if (this.topleftNode.pointInBounds(point)){
                return this.topleftNode.searchChildren(x, y, polygon);
            }
            if (this.toprightNode.pointInBounds(point)){
                return this.toprightNode.searchChildren(x, y, polygon);
            }
        }
        if (this.status == TreeGrid.MIXED){
            return this.windingNumberTest(x, y, polygon);
        }
        if (this.status == TreeGrid.INTERIOR){
            return true;
        }
        if (this.status == TreeGrid.EXTERIOR){
            return false;
        }
            
        if (this.status == TreeGrid.UNKNOWN)
            console.log("found an unknown tree node");
        return false;
    }

    computeStatus(polygon){
        //if the result has already been defined as mixed, we need to check what the children are
        // this.printBounds();
        if (this.status == TreeGrid.MIXED){
            if (this.botleftNode != null){
                this.botleftNode.computeStatus(polygon);
                this.botrightNode.computeStatus(polygon);
                this.toprightNode.computeStatus(polygon);
                this.topleftNode.computeStatus(polygon);
            }
        }
        //if it does not have children, this is a leaf node and we can use the winding number to figure out if a test point is inside the shape.
        else{
            var result = this.windingNumberTest(this.lbot[0] + .000001, this.lbot[1] + .000001, polygon);
            if (result)
                this.status = TreeGrid.INTERIOR;
            else
                this.status = TreeGrid.EXTERIOR;
        }
        
    }

    pointInBounds(vertex){
        return this.lbot[0] < vertex[0] && vertex[0] < this.rtop[0] && this.lbot[1] < vertex[1] && vertex[1] < this.rtop[1];
    }

    windingNumberTest(x, y, polygon){
        const p = [x, y];
        var leftWinding = 0;
        var rightWinding = 0;
        for(var i = 0; i < polygon.length-1; i++){
            var v1 = polygon[i];
            var v2 = polygon[i+1];
            //check if y is between the two y coords for the verticies, if not dont check them
            if (v1[1] <= y && y <= v2[1] || v2[1] <= y && y <= v1[1]){
              //perform triangle test for inside/outside
              
              var answer = PGA2D.isInside(v1, v2, p);
              //check to see if this is to the right or to the left to adjust the correct winding number
              var xAvg = (v1[0] + v2[0])/2;
              if (x < xAvg){
                if (answer)
                  leftWinding++;
                else
                  leftWinding--;
              }
              else{
                if (answer)
                  rightWinding++;
                else
                  rightWinding--;
              } 
            }
    
          }
        return (leftWinding != 0 && rightWinding != 0)
    }

    getTestPoint(){
        return [this.lbot[0] + .000001, this.lbot[1] + .000001];
    }

    printBounds(){
        console.log("x[" + this.lbot[0] + ", " + this.rtop[0] + "] | y[" + + this.lbot[1] + ", " + this.rtop[1] + "] | status: " + this.status);
    }
}