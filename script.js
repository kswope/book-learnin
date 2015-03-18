"use strict";

var us = require( 'underscore' );

var log = function() {
  console.log.apply( null, arguments )
}



var obj = {
  hello: function() {
    log( 'hello' )
  }
}

obj.hello();

var obj2 = Object.create(obj);

obj2.hello();
