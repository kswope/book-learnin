"use strict";

var us = require( 'underscore' );

var log = function() {
  console.log.apply( null, arguments )
};

//~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*



function my_add( a, b ) {

  if(my_add.cache === undefined){
    my_add.cache = [];
  }

  var cache_key = JSON.stringify(Array.prototype.slice.apply(arguments));

  if ( my_add.cache[ cache_key ] ) {
    return my_add.cache[cache_key]
  }

  var result = a + b;
  my_add.cache[cache_key] = result;

  return result;

}


console.log( my_add( 1, 2 ) )
console.log( my_add( 1, 2 ) )
