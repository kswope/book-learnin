'use strict';

function* foo( x ) {
  yield x + 1;

  var y = yield null;

  return x + y;
}


var gen = foo( 5 );
console.log(gen);
console.log( gen.next() ); // { value: 6, done: false }
console.log( gen.next() ); // { value: null, done: false }

gen.send( 8 ); // { value: 13, done: true }



function __scopeX(){

}; 
__scopeX();
