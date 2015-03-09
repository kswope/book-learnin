"use strict";



function MyConstructor() {}

MyConstructor.prototype.sayHello = function() {
  console.log( 'hello' )
}

var obj = new MyConstructor;

console.log( obj.constructor )
console.log( obj instanceof MyConstructor )
