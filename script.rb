"use strict";



var MyPrototype = {
  hello: function() {
    console.log( 'Goodbye' )
  }
};

var obj = new Object;
obj.__proto__ = MyPrototype;

obj.hello();
