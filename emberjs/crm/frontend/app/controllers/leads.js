import Ember from 'ember';

export default Ember.ArrayController.extend({
  sortProperties: ['firstName', 'lastName'],
  actions:{
    saveChanges: function(){
      alert('here in leads');
      this.get('model').save();
    }
  }
});
