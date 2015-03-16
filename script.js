"use strict";



function MyArray(data){
  this._data = data
}

MyArray.prototype.forEach = function(f){
  this._data.forEach(f);
}

var a = new MyArray([1,2,3]);

a.forEach(function(x){
  console.log(x);
})
