"use strict";


var str = 'a';
str += 'b';
str += 'c';

<<<<<<< HEAD
console.log(str)
=======
var a;
console.log(a) //=> undefined
console.log(typeof a) //=> undefined (might be 'undefined' depending on how console.log works
console.log(a === undefined) //=> true
console.log(typeof a === undefined) //=> false
console.log(typeof a === 'undefined') //=> true
>>>>>>> 85ab77b3f41a7dd8fc5d5b328c477556bd5da56e
