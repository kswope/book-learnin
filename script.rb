"use strict";



var myobj = {

  _data: null,

  get data() {
    return this._data;
  },

  set data( data ) {
    this._data = data;
  }

};

myobj.data = [ 'a', 'b', 'c' ];
console.log( myobj.data ) //=> [ 'a', 'b', 'c' ]
