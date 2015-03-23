import Ember from 'ember';

// export default Ember.Controller.extend({
// });
// 
// 


export default Ember.ObjectController.extend({
  actions: {
    editTodo: function() {
      this.set('isEditing', true);
    }
  }
});
