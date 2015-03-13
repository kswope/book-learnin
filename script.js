"use strict";




function swap( a, i, j ) {
  temp = a[ i ]; // global
  a[ i ] = a[ j ];
  a[ j ] = temp;
}

swap(1,2,3)
