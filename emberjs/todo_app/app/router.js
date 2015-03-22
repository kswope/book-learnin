import Ember from 'ember';
import config from './config/environment';

var Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.resource('about', {path: '/about'});
  this.resource('favs', {path: '/favs'});
});

export default Router;
