"use strict";

// var us = require( 'underscore' );
// var Ember = require( 'ember' );

var log = function() {
  console.log.apply( null, arguments )
};

//~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*


var a = 1;

function pa(){

  function ca(){
    return a+1;  
  }

  a = ca();
  console.log(a);


}

ca();
pa();
