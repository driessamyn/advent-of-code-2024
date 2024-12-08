import {test_data, data} from "./data.js";

// I cannot think of a way to optimise this to avoid brute force.
// The best I can think of is exiting early :(

function tryCombos(a, repeat, comboCondition, comboFun, exitWhenMatched = false) {
    let copies = Array.from({ length: repeat }, (x, i) => {
        return a.slice();
    });
    let combos = [[]]
    copies.forEach(function (v) {
        combos.forEach(function (av) {
            v.every(function (aav) {
                let n = av.concat(aav);
                if(n.length === repeat && comboCondition(n)) {
                    comboFun(n);
                    if(exitWhenMatched) return false;
                }
                combos.push(n);

                return true;
            });
        });
    });
}

let plus = function(a,b) { return a+b};
let times = function(a,b) { return a*b};
let concat = function (a,b) { return Number(String(a) + String(b)) }
let operators = [plus, times];
let part2_operators = [plus, times, concat];

function calculate(numbers, operators) {
    let running = numbers[0];
    for(let i=0;i<operators.length;i++) {
        running = operators[i](running, numbers[i+1]);
    }
    return running;
}

class Equation {
    constructor(result, parts) {
        this.result = result;
        this.parts = parts;
    }
    static parse(line) {
        let first = line.split(':');
        let second = first[1].trim().split(' ');
        return new Equation(Number(first[0]), second.map(Number));
    }

    calculate(operators) {
        let match = false;
        let numbers = this.parts;
        let expectedRestult = this.result;
        tryCombos(
            operators,
            this.parts.length-1,
            function (combo) { if(calculate(numbers, combo) === expectedRestult) return true; },
            function (combo) { match = true; },
            true
        );
        return match ? expectedRestult : 0;
    }
}

let o = ['*','+'];
tryCombos(o, 4, function () {return true},  console.log);

let ns = [2,3,4];

console.log("TEST process arrays:")
console.log(calculate(ns, operators));

console.log("TEST simple combo:")
tryCombos(
    operators,
    ns.length-1,
    function (combo) { if(calculate(ns, combo) === 20) return true; },
    function (combo) { console.log("Matched 20: " + combo); },
    true
);

let test_result =
    test_data
        .split(/\r?\n/).map(Equation.parse)
        .map(function(e) { return e.calculate(operators)} )
        .reduce(plus, 0);

console.log(test_result);

// let result =
//     data
//         .split(/\r?\n/).map(Equation.parse)
//         .map(function(e) { return e.calculate(operators)} )
//         .reduce(plus, 0);
//
// console.log(result);

console.log("CONCAT test:")
console.log(concat(123,4) + 1);

console.log("PART 2")
let p2_test_result =
    test_data
        .split(/\r?\n/).map(Equation.parse)
        .map(function(e) { return e.calculate(part2_operators)} )
        .reduce(plus, 0);

console.log(p2_test_result);

let p2_result =
    data
        .split(/\r?\n/).map(Equation.parse)
        .map(function(e) { return e.calculate(part2_operators)} )
        .reduce(plus, 0);

console.log(p2_result);

console.log("DONE");