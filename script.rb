"use strict";




var obj = {
  _myData: null,

  get: function() {
    return this._myData;
  },

  set: function( val ) {
    this._myData = val;
  },

};

obj.myData = '123';

console.log('myData' in obj) //=> true
console.log(obj.propertyIsEnumerable('myData')) //=> true



var obj2 = {_myData:null};

Object.defineProperty( obj2, 'myData', {

  get: function() {
    return this._myData;
  },

  set: function( val ) {
    this._myData = val;
  },

} );

obj2.myData = '123';
console.log( obj2.myData );

console.log('myData' in obj2) //=> true
console.log(obj2.propertyIsEnumerable('myData')) //=> false
