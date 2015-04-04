import Ember from 'ember';

export default Ember.Controller.extend({
  actions:{
    saveChanges: function(){
      alert('here');
      this.get('model').save();
    }
  }
});
