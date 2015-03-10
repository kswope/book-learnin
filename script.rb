"use strict";


function Person( name ) {
  if ( this instanceof Person ) {
    this.name = name;
  } else {
    return new Person( name );
  }
}
