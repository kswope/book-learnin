"use strict";



var obj = {};

obj.toString = function() {
  return 'toString()';
}

obj.valueOf = function(){
  return 'valueOf()';
}

console.log("----> " + obj); //=> here <----
