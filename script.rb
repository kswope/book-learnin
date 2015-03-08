"use strict";



var myobj = {};

Object.defineProperty( myobj, 'hello', {
  value: 'there',
  writable: true
} )

console.log(myobj.hello) //=> there

myobj.hello = 'goodbye';
console.log(myobj.hello) //=> goodbye


Object.defineProperty( myobj, 'hello', {
  value: 'there',
  writable: false
} )

myobj.hello = 'adios'; //=> TypeError: Cannot assign to read only property 'hello' of #<Object>
