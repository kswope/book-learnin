"use strict";

var _ = require( 'underscore' );

var log = function() {
  console.log.apply( null, arguments )
}


var obj = {};
obj.one = 1;
log(obj); // { one: 1 }
delete obj.one;
log(obj); // {}


var myglobal = 'hello';
log(myglobal); //=> hello
delete myglobal;
log(this.myglobal); //=> hello

