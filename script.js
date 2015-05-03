"use strict";

// var us = require( 'underscore' );
// var Ember = require( 'ember' );

var log = function() {
  console.log.apply( null, arguments );
};

//~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*


const fs = require('fs');
const spawn = require('child_process').spawn;
const filename = process.argv[2];


if( !filename ) {
  throw Error('A file to watch must be specified!');
}

fs.watch( filename, function() {
  throw Error( "A file to watch must be specified!" )
} )
