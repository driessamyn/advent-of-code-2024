<cfinclude template="data.cfm">
<cfscript>
var_test_puzzle2_1 = [
                    ['M','M','M'],
                    ['M','A','A'],
                    ['S','M','S']
                  ];
var_test_puzzle2_2 = [
                    ['S','M','M'],
                    ['M','A','A'],
                    ['S','M','M']
                  ];
var_test_puzzle2_3 = [
                    ['S','M','S'],
                    ['M','A','A'],
                    ['M','M','M']
                  ];

function isXmasLeftCross(grid, row, col) {
    if(row - 1 < 1 || row + 1 > ArrayLen(grid) ) return false;
    if(col - 1 < 1 || col + 1 > ArrayLen(grid[1])) return false;
    var word = grid[row-1][col-1] & "A" & grid[row+1][col+1];
    return word == "MAS" || word == "SAM";
}

function isXmasRightCross(grid, row, col) {
    if(row - 1 < 1 || row + 1 > ArrayLen(grid)) return false;
    if(col - 1 < 1 || col + 1 > ArrayLen(grid[1])) return false;
    var word = grid[row-1][col+1] & "A" & grid[row+1][col-1];
    return word == "MAS" || word == "SAM";
}

function isXmasPos2(grid, row, col) {
    return isXmasLeftCross(grid, row, col) && isXmasRightCross(grid, row, col);
}

function countXmas2(grid) {
    result = 0;
    for(r=1;r<=ArrayLen(grid);r++) {
        for(c=1;c<=ArrayLen(grid[1]);c++) {
            if(grid[r][c] != 'A') continue;
            if(isXmasPos2(grid, r, c)) result++;
            // writeOutput("FOUND at [#r# ,#c#] - #count# #NL#");
        }
    }
    return result;
}

function testPosition2(grid, row, col, expected) {
    actual = isXmasPos2(grid, row, col);
    if(actual == expected) {
        writeOutput("PASS #NL#");
    } else {
        writeOutput("FAIL [#row# ,#col#] - #actual#!=#expected# #NL#");
    }
}

testPosition2(var_test_puzzle2_1, 2, 2, true);
testPosition2(var_test_puzzle2_1, 2, 3, false);
testPosition2(var_test_puzzle2_1, 3, 2, false);
testPosition2(var_test_puzzle2_2, 2, 2, true);
testPosition2(var_test_puzzle2_3, 2, 2, true);

writeOutput(countXmas2(var_test_puzzle2_1));

</cfscript>