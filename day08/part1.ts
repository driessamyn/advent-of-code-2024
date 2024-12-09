import {test_data, data} from "./data";

class Grid {
    get antennas(): Map<string, string[]> {
        return this._antennas;
    }
    get grid(): string[][] {
        return this._grid;
    }
    private _antennas: Map<string, string[]>;
    private _grid: string[][];
    private _gridMaxRow : number;
    private _gridMaxCol: number;

    constructor(grid: string[][], antennas: Map<string, string[]>) {
        this._grid = grid;
        this._gridMaxRow = grid.length - 1;
        this._gridMaxCol = grid[0].length -1;
        this._antennas = antennas;
    }
    static parse(gridString: string): Grid {
        let antennas = new Map<string, string[]>();
        let r = 0;
        let c = 0;
        let grid = gridString.trim()
            .split(/\r?\n/)
            .map(function (line) {
                let row = [];
                for(let i=0; i<line.length;i++) {
                    row.push(line[i]);
                    if(line[i] != '.') {
                        let cords = [r, i].join(',');
                        antennas.has(line[i]) ?
                            antennas.get(line[i]).push(cords) :
                            antennas.set(line[i], [cords]);
                        c++;
                    }
                }
                r++;
                return row;
            });
        return new Grid(grid, antennas);
    }

    public toString = () : string => {
        let g = this.grid.map(function (row) {
            return row.join('');
        }).join("\n");
        let a = JSON.stringify(Object.fromEntries(this.antennas));
        return g + "\n" + a;
    }

    public findAntinodes(keepSearching) : Set<string> {
        let antinodes = new Set<string>();
        let a = this.antennas;
        let gridMaxRow = this._gridMaxRow;
        let gridMaxCol = this._gridMaxCol;
        for (let [key, value] of a) {
            createCombos(value, 2).forEach(function (pair) {

                let [startRow, startCol] = pair[0].split(',').map(Number);
                let [endRow, endCol] = pair[1].split(',').map(Number);
                let [dRow, dCol] = Grid.prototype.distance([startRow, startCol] , [endRow, endCol]);

                let currentStartRow = startRow;
                let currentStartCol = startCol;

                //damn forgot about this and that wasted a lot of time
                if(keepSearching) {
                    // add the antennas themselves
                    antinodes.add(pair[0]);
                    antinodes.add(pair[1]);
                }

                while ((currentStartRow += dRow) >= 0 && currentStartRow <= gridMaxRow && (currentStartCol += dCol) >= 0 && currentStartCol <= gridMaxCol) {
                    antinodes.add([currentStartRow, currentStartCol].join(','));
                    if(!keepSearching) break;
                }

                let currentEndRow= endRow;
                let currentEndCol = endCol;
                while ((currentEndRow -= dRow) >= 0 && currentEndRow <= gridMaxRow && (currentEndCol -= dCol) >= 0 && currentEndCol <= gridMaxCol) {
                    antinodes.add([currentEndRow, currentEndCol].join(','));
                    if(!keepSearching) break;
                }

            });
        }
        return antinodes;
    }


    distance(start, end): number[] {
        return [start[0] - end[0], start[1] - end[1]];
    }
}

// this is not optimal, but pinching this from day07 is saving me some time.
function createCombos(a, repeat) {
    let copies = Array.from({ length: repeat }, (x, i) => {
        return a.slice();
    });
    let combos = [[]]
    copies.forEach(function (v) {
        combos.forEach(function (av) {
            v.forEach(function (aav) {
                let n = av.concat(aav);
                combos.push(n);
            });
        });
    });
    let seen = [];
    return combos.filter(function (it) {
        let isUnique = it.length == 2 && it[0] != it[1] && seen.indexOf(it.sort().join()) === -1;
        if(!isUnique) return false;
        seen.push(it.sort().join());
        return true;
    });
}

var test_antennas = [
    "1,2", "3,4","5,6"
];

console.log(createCombos(test_antennas, 2));

console.log("TEST GRID");
let test_grid = Grid.parse(test_data)
console.log(test_grid.toString());

let t_n = test_grid.findAntinodes();
// console.log(t_n);
console.log(t_n.size);

console.log("REAL GRID");
let grid = Grid.parse(data);
console.log(grid.toString());
let n = grid.findAntinodes();
console.log(n.size);

let n2 = grid.findAntinodes(true);
console.log(n2.size);