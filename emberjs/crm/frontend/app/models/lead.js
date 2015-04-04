import DS from 'ember-data';

export
default DS.Model.extend( {

  firstName: DS.attr( 'string' ),
  lastName: DS.attr( 'string' ),
  email: DS.attr( 'string' ),
  phone: DS.attr( 'string' ),
  notes: DS.attr( 'string' ),
  status: DS.attr( 'string', {
    defaultValue: 'new'
  } ),

  fullName: function() {
    return [ this.get( 'firstName' ), this.get( 'lastName' ) ].join( ' ' );
  }.property( 'firstName', 'lastName' ),

  STATUSES: [ 'new', 'in progress', 'closed', 'bad' ],

} );
