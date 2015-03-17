"use strict";

var _ = require( 'underscore' );

var log = function() {
  console.log.apply( null, arguments )
}


var a = [1,2,3,4,5,6,7,8,9];
var length = a.length;

while(length--){
  log(a[length])
}
