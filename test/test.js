var PEG = require("../dist/python");
var fs = require("fs");

var program = fs.readFileSync("./test/test.py", "utf8");

console.log("# source -----");
console.log(program);

var result = PEG.parse(program);

console.log("\n# result -----");

function print(array) {
  var result = [];
  function _print(array) {
    result.push("[");
    array.forEach(element => {
      if (Array.isArray(element)) {
        _print(element);
      } else {
        if (element !== "\n") {
          result.push(element);
        }
      }
    })
    result.push("]");
  }
  _print(array);
  console.log(result.join(" "));
}

print(result);
