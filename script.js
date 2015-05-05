"use strict";

// var us = require( 'underscore' );
// var Ember = require( 'ember' );

var log = function() {
  console.log.apply( null, arguments );
};

//~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*


log( Array.prototype.join.call( [ 1, 2, 3 ], '-' ) ); //=> '1-2-3'
log( Array.prototype.join.call( '123', '-' ) ); //=> '1-2-3'

// doesn't work with strings because strings don't mutate in place
log( Array.prototype.reverse.call( [ 1, 2, 3 ], '-' ) ); //=> [ 3, 2, 1 ]
log( Array.prototype.reverse.call( '123', '-' ) ); //=> [String: '123']

log( [1,2,3].reverse() )
  'abc',reverse();
