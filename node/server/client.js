#!/usr/local/bin/node --harmony

'use strict';

const net = require( 'net' );
const ldj = require( './ldj.js' );

const netClient = net.connect( { port: 5432 } );
const ldjClient = ldj.connect( netClient );

ldjClient.on( 'data', function( data ) {

  let message = JSON.parse( data );

  if ( message.type === 'watching' ) {
    console.log( 'now watching: ' + message.file )
  } else if ( message.type === 'changed' ) {
    let date = new Date( message.timestamp );
    console.log( "file '" + message.file + "' changed at " + date );
  } else {
    throw Error('Unreconized message type: ' + message.type);
  }

} );

