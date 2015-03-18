"use strict";

var us = require( 'underscore' );

var log = function() {
  console.log.apply( null, arguments )
};

//~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*

var MYAPP = {};
MYAPP.utilities = {};

MYAPP.utilities.Array = ( function() {

  function Constructor() {};

  Constructor.prototype = {
    inArray: function( needle, haystack ) {},
    isArray: function( a ) {},
  }

  return Constructor;

}() );


var obj = new MYAPP.utilities.Array

