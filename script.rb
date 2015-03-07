"use strict";



var obj = {
  name: 'kevin'
}

var func = function( greeting ) {
  console.log( greeting + " " + this.name )
}


// bind first argument. like call(), its first argument is 'this'
var boundFunc = func.bind(obj)
boundFunc('goodbye') //=> goodbye kevin

// bind two arguments
var boundFunc = func.bind(obj, 'adios')
boundFunc() //=> adios kevin
