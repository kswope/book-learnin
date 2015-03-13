"use strict";


var func2 = function() {

  var var1 = 'hello';

  return function() {
    console.log( var1 )
  };

};

func2()();
