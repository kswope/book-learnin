"use strict";

var us = require( 'underscore' );

var log = function() {
  console.log.apply( null, arguments )
};

//~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*

var parent = {
  prop1:'here',
}


var obj = Object.create( parent, {
  v1: {
    value: 'one',
    enumerable: true
  },
  v2: {
    value: 'two'
  },
} );

log( obj );

for ( var p in obj ) {
  if ( obj.hasOwnProperty( p ) ) {
    log( p )
  }
}
