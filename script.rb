"use strict";



function MyConstructor(){}

MyConstructor.prototype = {
  hello: function() {
    console.log( 'Goodbye' )
  }
};

var obj = new MyConstructor();
obj.hello(); //=> goodbye

