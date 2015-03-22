import Ember from 'ember';



// export default Ember.Route.extend({
//   setupController: function( controller ) {
//     controller.set( 'title', 'ToDo/About' );
//   },
// });



export default Ember.Route.extend( {
  model: function() {
    return [ {
      title: "Tomster",
      url: "http://emberjs.com/images/about/ember-productivity-sm.png"
      }, {
      title: "Eiffel Tower",
      url: "http://emberjs.com/images/about/ember-structure-sm.png"
      } ];
  }
} );
