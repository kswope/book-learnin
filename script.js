"use strict";

var us = require( 'underscore' );

var log = function() {
  console.log.apply( null, arguments )
};

//~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*


var n1 = ( function() {

  var counter = 0;
  var data = [ 1, 2, 3, 4, 5 ];

  return {

    getIndex: function() {
      return counter;
    },
    next: function() {
      return data[ counter++ ]
    },

  }

} )()


var n2 = ( function() {

  var counter = 0;
  var data = [ 1, 2, 3, 4, 5 ];

  return {

    getIndex: function() {
      return counter;
    },
    next: function() {
      return data[ counter++ ]
    },

  }

} )()


log( n1.getIndex() );
log( n2.getIndex() );
log( n1.next() );
log( n2.next() );
log( n1.next() );
log( n2.next() );
log( n1.next() );
log( n2.next() );
