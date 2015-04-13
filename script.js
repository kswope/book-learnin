"use strict";

// var us = require( 'underscore' );
// var Ember = require( 'ember' );

var log = function() {
  console.log.apply( null, arguments )
};

//~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*

var a = [1,2,3];
log( 2 in a ) //=> true
log( 3 in a ) //=> false

