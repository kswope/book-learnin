"use strict";

var us = require( 'underscore' );

var log = function() {
  console.log.apply( null, arguments )
};

//~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*

var MyConstructor = function(){}
MyConstructor.static = function(){ log("I'm static") }
MyConstructor.static()
