import * as data from './data.js'

var GUARD = ['^', '>', 'v', '<'];

// convert the string to a matrix and return it along with an empty shadow and the starting position.
function convertToMatrix(str) {
    var matrix = []
    var shadow = []
    var here = [];
    var rows = str.split(/\r?\n/);
    for(var i=0;i<rows.length; i++) {
        var row = [];
        for(var j=0;j<rows[i].length;j++) {
            row.push(rows[i][j]);
            if(GUARD.includes(rows[i][j])) here = [i,j];
        }
        matrix.push(row);
        shadow.push(row.slice());
    }
    return [matrix, shadow, here];
}

function hasLeft(r, c, here, height, width) {
    if(c === 0 && here === '<') return true;
    if(c === width-1 && here === '>') return true;
    if(r === 0 && here === '^') return true;
    if(r === height-1 && here === 'v') return true;
    return false;
}

function test_hasLeft(matrix, r,c,expected) {
    return hasLeft(r,c,matrix[r][c],matrix.length,matrix[0].length) === expected ? "PASS" : "FAIL"
}

function travel(matrix, shadow, start) {
    var r = start[0];
    var c = start[1];
    var here = matrix[r][c];
    var hitObstacles = [];
    while(!hasLeft(r,c,here,matrix.length, matrix[0].length)) {
        shadow[r][c] = 'X';
        var obsPos = null;
        if(here === '>') c++; if(matrix[r][c]==='#') { here = 'v'; c--; obsPos = r+","+c+","+here; }
        else if (here === '<') c--; if(matrix[r][c]==='#') { here = '^'; c++; obsPos = r+","+c+","+here; }
        else if (here === 'v') r++; if(matrix[r][c]==='#') { here = '<'; r--; obsPos = r+","+c+","+here; }
        else if (here === '^') r--; if(matrix[r][c]==='#') { here = '>'; r++; obsPos = r+","+c+","+here; }

        if(obsPos) {
            if(hitObstacles.includes(obsPos)) return null;
            hitObstacles.push(obsPos);
        }
    }
    shadow[r][c] = 'X';
    return shadow;
}

function countPlaces(matrix) {
    var count = 0;
    for(var i=0;i<matrix.length;i++) {
        for(var j=0;j<matrix[0].length;j++) {
            if(matrix[i][j] === 'X') count++;
        }
    }
    return count;
}

function printMatrix(matrix) {
    var count = 0;
    for(var i=0;i<matrix.length;i++) {
        var row = "";
        for(var j=0;j<matrix[0].length;j++) {
            row += matrix[i][j];
        }
        console.log(row);
    }
}

function placeAndCountObstacles(matrix, start) {
    var count = 0;
    for(var i=0;i<matrix.length;i++) {
        for(var j=0;j<matrix[0].length;j++) {
            if(matrix[i][j] === '.') {
                // clone the matrix before changing
                var newMatrix = structuredClone(matrix);
                newMatrix[i][j] = '#';
                var newShadowMatrix = structuredClone(newMatrix);
                if(null == travel(newMatrix, newShadowMatrix, start)) count++;
            }
        }
    }
    return count;
}

var test_matrix = convertToMatrix(data.test_grid);
var test_travelled = travel(test_matrix[0],test_matrix[1],test_matrix[2]);
printMatrix(test_travelled);
console.log(countPlaces(test_travelled));

var test_matrix2 = convertToMatrix(data.test_grid2);
var test_travelled2 = travel(test_matrix2[0],test_matrix2[1],test_matrix2[2]);
if(null == test_travelled2) {
    console.log("INFINITE LOOP");
} else {
    console.log(countPlaces(test_travelled2));
    printMatrix(test_travelled2);
}

var count = placeAndCountObstacles(test_matrix[0],test_matrix[2]);
console.log(count);

var matrix = convertToMatrix(data.grid);
var travelled = travel(matrix[0],matrix[1],matrix[2]);
printMatrix(travelled);
console.log(countPlaces(travelled));
var countAll = placeAndCountObstacles(matrix[0],matrix[2]);
console.log(countAll);
