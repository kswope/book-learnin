"use strict";

// var us = require( 'underscore' );
// var Ember = require( 'ember' );

var log = function() {
  console.log.apply( null, arguments );
};

//~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*


var a = 'abcdef';

a = a
  .split( '' )
  .reverse()
  .map( function( x ) {
    return x.toUpperCase()
  } )

log( a );
