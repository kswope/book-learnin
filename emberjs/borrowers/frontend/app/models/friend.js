import DS from 'ember-data';

export default DS.Model.extend({
  firstName: DS.attr('string'),
  lastName: DS.attr('string'),
  email: DS.attr('string'),
  twitter: DS.attr('string'),
  totalArticles: DS.attr('number'),

  fullName: function(){
    return [this.get('firstName'), this.get('lastName')].join(' ')
  }.property('firstName', 'lastName')

});
