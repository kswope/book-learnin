"use strict";

// var us = require( 'underscore' );
// var Ember = require( 'ember' );

var log = function() {
  console.log.apply( null, arguments )
};

//~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*

var a = [1,2,3];
log( a ) //=> [1,2,3]
  a.delete(0);
log( a ) //=> false

