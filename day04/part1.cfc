<cfinclude template="data.cfm">
<cfscript>

var_test_puzzle_1 = [
                    ['X','M','A','S'],
                    ['M','A','A','A'],
                    ['A','M','M','M'],
                    ['S','A','M','X']
                  ];

var_test_puzzle_2 = [
                    ['S','A','M','X'],
                    ['A','M','M','M'],
                    ['M','A','A','A'],
                    ['X','M','A','S']
                  ];

var_test_puzzle_3 = [
                    ['S','M','A','S'],
                    ['M','A','A','A'],
                    ['A','M','M','M'],
                    ['X','A','M','X']
                  ];

var_test_puzzle_4 = [
                    ['X','M','A','X'],
                    ['M','M','M','A'],
                    ['A','A','A','M'],
                    ['S','A','M','S']
                  ];

XMAS = "XMAS";
XMAS_LENGTH = 4;

NL = "<br>"

// TODO: duplication can be reduced
// NOTE: OFF BY ONE ERRORS LIKELY!!!
function isXmasRight(grid, row, col) {
    if(col + XMAS_LENGTH > ArrayLen(grid[1]) + 1) return 0;
    var c = col;
    var word = "";
    while(c < col + XMAS_LENGTH) {
        word &= grid[row][c];
        if(!#XMAS.startsWith(word)#) {
            return 0;
        }
        c++;
    }
    return 1;
}
function isXmasLeft(grid, row, col) {
    if(col - XMAS_LENGTH < 0) return 0;
    var c = col;
    var word = "";
    while(c > col - XMAS_LENGTH) {
        word &= grid[row][c];
        //writeOutput("[#row# ,#c#] - #word# #NL#");
        if(!#XMAS.startsWith(word)#) {
            return 0;
        }
        c--;
    }
    return 1;
}
function isXmasDown(grid, row, col) {
    if(row + XMAS_LENGTH > ArrayLen(grid) + 1) return 0;
    var r = row;
    var word = "";
    while(r < row + XMAS_LENGTH) {
        word &= grid[r][col];
        if(!#XMAS.startsWith(word)#) {
            return 0;
        }
        r++;
    }
    return 1;
}
function isXmasUp(grid, row, col) {
    if(row - XMAS_LENGTH < 0) return 0;
    var r = row;
    var word = "";
    while(r > row - XMAS_LENGTH) {
        word &= grid[r][col];
        if(!#XMAS.startsWith(word)#) {
            return 0;
        }
        r--;
    }
    return 1;
}

// definitly can consolidate these
function isXmasDiaLeftUp(grid, row, col) {
    if(col - XMAS_LENGTH < 0 || row - XMAS_LENGTH < 0) return 0;
    var c = col;
    var r = row;
    var word = "";
    while(c > col - XMAS_LENGTH) {
        word &= grid[r][c];
        if(!#XMAS.startsWith(word)#) {
            return 0;
        }
        c--;
        r--;
    }
    return 1;
}
function isXmasDiaRightUp(grid, row, col) {
    if(col + XMAS_LENGTH > ArrayLen(grid[1]) + 1 || row - XMAS_LENGTH < 0) return 0;
    var c = col;
    var r = row;
    var word = "";
    while(c < col + XMAS_LENGTH) {
        word &= grid[r][c];
        //writeOutput("[#row# ,#c#] - #word# #NL#");
        if(!#XMAS.startsWith(word)#) {
            return 0;
        }
        c++;
        r--;
    }
    return 1;
}
function isXmasDiaLeftDown(grid, row, col) {
    if(col - XMAS_LENGTH < 0 || row + XMAS_LENGTH > ArrayLen(grid) + 1) return 0;
    var c = col;
    var r = row;
    var word = "";
    while(c > col - XMAS_LENGTH) {
        word &= grid[r][c];
        if(!#XMAS.startsWith(word)#) {
            return 0;
        }
        c--;
        r++;
    }
    return 1;
}
function isXmasDiaRightDown(grid, row, col) {
    if(col + XMAS_LENGTH > ArrayLen(grid[1]) + 1 || row + XMAS_LENGTH > ArrayLen(grid) + 1) return 0;
    var c = col;
    var r = row;
    var word = "";
    while(c < col + XMAS_LENGTH) {
        word &= grid[r][c];
        if(!#XMAS.startsWith(word)#) {
            return 0;
        }
        c++;
        r++;
    }
    return 1;
}

function countXmas(grid) {
    result = 0;
    for(r=1;r<=ArrayLen(grid);r++) {
        for(c=1;c<=ArrayLen(grid[1]);c++) {
            count = isXmasPos(grid, r, c);
            // writeOutput("FOUND at [#r# ,#c#] - #count# #NL#");
            result += count
        }
    }
    return result;
}

// returns the number of  XMAS started here
function isXmasPos(grid, row, col) {
    return isXmasRight(grid, row, col)
        + isXmasLeft(grid, row, col)
        + isXmasDown(grid, row, col)
        + isXmasUp(grid, row, col)
        + isXmasDiaLeftUp(grid, row, col)
        + isXmasDiaRightUp(grid, row, col)
        + isXmasDiaLeftDown(grid, row, col)
        + isXmasDiaRightDown(grid, row, col);
}

function testPosition(grid, row, col, expected) {
    actual = isXmasPos(grid, row, col);
    if(actual == expected) {
        writeOutput("PASS #NL#");
    } else {
        writeOutput("FAIL [#row# ,#col#] - #actual#!=#expected# #NL#");
    }
}

testPosition(var_test_puzzle_1, 1, 1, 2);
testPosition(var_test_puzzle_1, 4, 4, 2);
testPosition(var_test_puzzle_1, 4, 1, 0)
testPosition(var_test_puzzle_1, 1, 4, 0);
testPosition(var_test_puzzle_1, 2, 4, 0);
testPosition(var_test_puzzle_1, 4, 2, 0);

testPosition(var_test_puzzle_2, 1, 4, 2);
testPosition(var_test_puzzle_2, 4, 1, 2);

testPosition(var_test_puzzle_3, 4, 4, 2);
testPosition(var_test_puzzle_3, 4, 1, 1);
testPosition(var_test_puzzle_4, 1, 1, 2);
testPosition(var_test_puzzle_4, 1, 4, 1);

testPosition(var_test_data, 2, 5, 1);


writeOutput(countXmas(var_test_data));
</cfscript>