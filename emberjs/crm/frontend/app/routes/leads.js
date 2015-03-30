import Ember from 'ember';

export
default Ember.Route.extend( {
  model: function() {
    var data = this.store.find( 'lead' );
    return data;
  }
} );
