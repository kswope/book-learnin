"use strict";


var obj = {};

Object.defineProperties( obj, {

  _name: {
    value: 'kevin',
    enumerable: true,
  },

  name: {
    get: function() {
      return this._name
    },
    enumerable: true
  }

} );

