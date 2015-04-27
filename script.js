"use strict";

// var us = require( 'underscore' );
// var Ember = require( 'ember' );

var log = function() {
  console.log.apply( null, arguments )
};

//~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*

var map = new Map([[1,'one'],[2,'two']]);
log(map.get(1));
