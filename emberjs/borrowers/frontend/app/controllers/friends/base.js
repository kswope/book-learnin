import Ember from 'ember';

export default Ember.Controller.extend( {
  isValid: Ember.computed(
    'model.email',
    'model.firstName',
    'model.lastName',
    'twitter',
    function() {
      return !Ember.isEmpty( this.get( 'model.email' ) ) && !Ember.isEmpty( this.get( 'model.firstName' ) ) && !Ember.isEmpty( this.get(
        'model.lastName' ) ) && !Ember.isEmpty( this.get( 'model.twitter' ) );
    }
  ),
  actions: {
    save: function() {
      console.log('in save');
      if ( this.get( 'isValid' ) ) {
        var _this = this;
        console.log('is valid');
        this.get( 'model' ).save().then( function( friend ) {
          _this.transitionToRoute( 'friends.show', friend );
        } );
      } else {
        console.log('is not valid');
        this.set( 'errorMessage', 'You have to fill all the fields' );
      }
      return false;
    },
    cancel: function() {
      return true;
    }
  }

} );
