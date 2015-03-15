"use strict";



function Data( data, splitter ) {
  this._data = data;
  this._splitter = splitter;
}

Data.prototype.split = function() {
  return this._data.map( function( x ) {
    return x.split( this._splitter ) //<-- that
  }.bind(this) )
}

var data = new Data( ['abc','def'], new RegExp( '' ) )
console.log( data.split() );
