"use strict";





var person1 = {
  name: "Nicholas",
  sayName: function() {
    console.log( this.name );
  }
};

console.log("toString" in person1); //=> true
console.log(person1.hasOwnProperty("toString")); //=> false
