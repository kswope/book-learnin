"use strict";



var highlighter = function(pointer, value){
  console.log(pointer + value);
};


// pass wrapper to map
[1,2,3,4,5].map(function(x){
  highlighter('*** ', x);
});

// use bind to convert highlighter into one argument method
[1,2,3,4,5].map(highlighter.bind(null, '--> '));
