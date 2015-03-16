"use strict";


var str = 'this is a string';

[].forEach.call(str, function(x){
  console.log(x)
})
