
"use strict";



var found = new Boolean(false);

if (found) {
  console.log("Found"); //=> Found
}

var found = false;
if (found) {
  console.log("Found");
}else{
  console.log("Not Found"); //=> Not Found
}
