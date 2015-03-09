"use strict";


function MyConstructor() {}

MyConstructor.prototype = {
  hello: function() {
    console.log( 'hello' )
  }
}

var obj = new MyConstructor;
obj.hello() //=> hello

console.log(Object.getPrototypeOf(obj)) //=> { hello: [Function] }
console.log(obj instanceof MyConstructor) //=> true
