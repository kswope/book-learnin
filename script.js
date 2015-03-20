"use strict";

var us = require( 'underscore' );

var log = function() {
  console.log.apply( null, arguments )
};

//~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*~~~*

var accum = [];

var pusher = Array.prototype.push.bind(accum);
pusher(1);
pusher(2);

log(accum);

