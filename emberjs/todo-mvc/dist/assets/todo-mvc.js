/* jshint ignore:start */

/* jshint ignore:end */

define('todo-mvc/adapters/application', ['exports', 'ember-data'], function (exports, DS) {

	'use strict';

	exports['default'] = DS['default'].FixtureAdapter.extend({});

});
define('todo-mvc/app', ['exports', 'ember', 'ember/resolver', 'ember/load-initializers', 'todo-mvc/config/environment'], function (exports, Ember, Resolver, loadInitializers, config) {

  'use strict';

  Ember['default'].MODEL_FACTORY_INJECTIONS = true;
  Ember['default'].LOG_BINDINGS = true;

  var App = Ember['default'].Application.extend({
    modulePrefix: config['default'].modulePrefix,
    podModulePrefix: config['default'].podModulePrefix,
    Resolver: Resolver['default']
  });

  loadInitializers['default'](App, config['default'].modulePrefix);

  exports['default'] = App;

});
define('todo-mvc/controllers/todo', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].ObjectController.extend({
    actions: {
      editTodo: function editTodo() {
        this.set("isEditing", true);
      },
      acceptChanges: function acceptChanges() {
        // Remove is editing property
        this.set("isEditing", false);
        // If the todo is empty, delete it otherwise save it with the new title
        if (Ember['default'].isEmpty(this.get("model.title"))) {
          this.send("removeTodo");
        } else {
          this.get("model").save();
        }
      },
      removeTodo: function removeTodo() {
        var todo = this.get("model");
        todo.deleteRecord();
        todo.save();
      }
    } });

});
define('todo-mvc/controllers/todos', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].ArrayController.extend({
    actions: {
      createTodo: function createTodo(newTitle) {
        // Create the new Todo model
        var todo = this.store.createRecord("todo", {
          title: newTitle,
          isCompleted: false
        });

        // Clear the "New Todo" text field
        this.set("newTitle", "");

        // Save the new model
        todo.save();
      }
    }
  });

});
define('todo-mvc/initializers/app-version', ['exports', 'todo-mvc/config/environment', 'ember'], function (exports, config, Ember) {

  'use strict';

  var classify = Ember['default'].String.classify;

  exports['default'] = {
    name: "App Version",
    initialize: function initialize(container, application) {
      var appName = classify(application.toString());
      Ember['default'].libraries.register(appName, config['default'].APP.version);
    }
  };

});
define('todo-mvc/initializers/export-application-global', ['exports', 'ember', 'todo-mvc/config/environment'], function (exports, Ember, config) {

  'use strict';

  exports.initialize = initialize;

  function initialize(container, application) {
    var classifiedName = Ember['default'].String.classify(config['default'].modulePrefix);

    if (config['default'].exportApplicationGlobal && !window[classifiedName]) {
      window[classifiedName] = application;
    }
  }

  ;

  exports['default'] = {
    name: "export-application-global",

    initialize: initialize
  };

});
define('todo-mvc/models/todo', ['exports', 'ember-data'], function (exports, DS) {

  'use strict';

  exports['default'] = DS['default'].Model.extend({

    title: DS['default'].attr("string"),
    isCompleted: DS['default'].attr("boolean")

  }).reopenClass({

    FIXTURES: [{
      id: 1,
      title: "Complete Ember.js Tutorial",
      isCompleted: false
    }, {
      id: 2,
      title: "Checkout some more ember stuff",
      isCompleted: true
    }, {
      id: 3,
      title: "Solve world hunger (with Ember)",
      isCompleted: false
    }, {
      id: 4,
      title: "My Own Todo",
      isCompleted: false
    }]

  });

});
define('todo-mvc/router', ['exports', 'ember', 'todo-mvc/config/environment'], function (exports, Ember, config) {

  'use strict';

  var Router = Ember['default'].Router.extend({
    location: config['default'].locationType
  });

  Router.map(function () {
    this.resource("todos", {
      path: "/"
    });
  });

  exports['default'] = Router;

});
define('todo-mvc/routes/todos', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Route.extend({
    model: function model() {
      return this.store.find("todo");
    }
  });

});
define('todo-mvc/templates/application', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      isHTMLBars: true,
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("section");
        dom.setAttribute(el1,"id","todoapp");
        var el2 = dom.createTextNode("\n  ");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("header");
        dom.setAttribute(el2,"id","header");
        var el3 = dom.createTextNode("\n    ");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("h1");
        var el4 = dom.createTextNode("todos");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createTextNode("\n  ");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createTextNode("\n  ");
        dom.appendChild(el1, el2);
        var el2 = dom.createTextNode("\n");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createTextNode("\n");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("footer");
        dom.setAttribute(el1,"id","info");
        var el2 = dom.createTextNode("\n  ");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("p");
        var el3 = dom.createTextNode("Double-click to edit a todo");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createTextNode("\n");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createTextNode("\n");
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, content = hooks.content;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var morph0 = dom.createMorphAt(dom.childAt(fragment, [0]),2,3);
        content(env, morph0, context, "outlet");
        return fragment;
      }
    };
  }()));

});
define('todo-mvc/templates/todos', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      var child0 = (function() {
        return {
          isHTMLBars: true,
          blockParams: 0,
          cachedFragment: null,
          hasRendered: false,
          build: function build(dom) {
            var el0 = dom.createDocumentFragment();
            var el1 = dom.createTextNode("      ");
            dom.appendChild(el0, el1);
            var el1 = dom.createTextNode("\n");
            dom.appendChild(el0, el1);
            return el0;
          },
          render: function render(context, env, contextualElement) {
            var dom = env.dom;
            var hooks = env.hooks, get = hooks.get, inline = hooks.inline;
            dom.detectNamespace(contextualElement);
            var fragment;
            if (env.useFragmentCache && dom.canClone) {
              if (this.cachedFragment === null) {
                fragment = this.build(dom);
                if (this.hasRendered) {
                  this.cachedFragment = fragment;
                } else {
                  this.hasRendered = true;
                }
              }
              if (this.cachedFragment) {
                fragment = dom.cloneNode(this.cachedFragment, true);
              }
            } else {
              fragment = this.build(dom);
            }
            var morph0 = dom.createMorphAt(fragment,0,1,contextualElement);
            inline(env, morph0, context, "input", [], {"type": "text", "class": "edit", "value": get(env, context, "title"), "focus-out": "acceptChanges", "insert-newline": "acceptChanges"});
            return fragment;
          }
        };
      }());
      var child1 = (function() {
        return {
          isHTMLBars: true,
          blockParams: 0,
          cachedFragment: null,
          hasRendered: false,
          build: function build(dom) {
            var el0 = dom.createDocumentFragment();
            var el1 = dom.createTextNode("      ");
            dom.appendChild(el0, el1);
            var el1 = dom.createTextNode("\n      ");
            dom.appendChild(el0, el1);
            var el1 = dom.createElement("label");
            dom.appendChild(el0, el1);
            var el1 = dom.createTextNode("\n      ");
            dom.appendChild(el0, el1);
            var el1 = dom.createElement("button");
            dom.setAttribute(el1,"class","destroy");
            dom.appendChild(el0, el1);
            var el1 = dom.createTextNode("\n");
            dom.appendChild(el0, el1);
            return el0;
          },
          render: function render(context, env, contextualElement) {
            var dom = env.dom;
            var hooks = env.hooks, get = hooks.get, inline = hooks.inline, element = hooks.element, content = hooks.content;
            dom.detectNamespace(contextualElement);
            var fragment;
            if (env.useFragmentCache && dom.canClone) {
              if (this.cachedFragment === null) {
                fragment = this.build(dom);
                if (this.hasRendered) {
                  this.cachedFragment = fragment;
                } else {
                  this.hasRendered = true;
                }
              }
              if (this.cachedFragment) {
                fragment = dom.cloneNode(this.cachedFragment, true);
              }
            } else {
              fragment = this.build(dom);
            }
            var element0 = dom.childAt(fragment, [2]);
            var morph0 = dom.createMorphAt(fragment,0,1,contextualElement);
            var morph1 = dom.createMorphAt(element0,-1,-1);
            inline(env, morph0, context, "input", [], {"type": "checkbox", "checked": get(env, context, "isCompleted"), "class": "toggle"});
            element(env, element0, context, "action", ["editTodo"], {"on": "doubleClick"});
            content(env, morph1, context, "title");
            return fragment;
          }
        };
      }());
      return {
        isHTMLBars: true,
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createTextNode("    ");
          dom.appendChild(el0, el1);
          var el1 = dom.createElement("li");
          var el2 = dom.createTextNode("\n");
          dom.appendChild(el1, el2);
          var el2 = dom.createTextNode("    ");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          var el1 = dom.createTextNode("\n");
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, element = hooks.element, get = hooks.get, block = hooks.block;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var element1 = dom.childAt(fragment, [1]);
          var morph0 = dom.createMorphAt(element1,0,1);
          element(env, element1, context, "bind-attr", [], {"class": "isCompleted:completed isEditing:editing"});
          block(env, morph0, context, "if", [get(env, context, "isEditing")], {}, child0, child1);
          return fragment;
        }
      };
    }());
    return {
      isHTMLBars: true,
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createTextNode("\n\n");
        dom.appendChild(el0, el1);
        var el1 = dom.createTextNode("\n\n");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("section");
        dom.setAttribute(el1,"id","main");
        var el2 = dom.createTextNode("\n\n");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("ul");
        dom.setAttribute(el2,"id","todo-list");
        var el3 = dom.createTextNode("\n\n");
        dom.appendChild(el2, el3);
        var el3 = dom.createTextNode("\n");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createTextNode("\n\n  ");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("input");
        dom.setAttribute(el2,"type","checkbox");
        dom.setAttribute(el2,"id","toggle-all");
        dom.appendChild(el1, el2);
        var el2 = dom.createTextNode("\n");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createTextNode("\n");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("footer");
        dom.setAttribute(el1,"id","footer");
        var el2 = dom.createTextNode("\n  ");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("span");
        dom.setAttribute(el2,"id","todo-count");
        var el3 = dom.createTextNode("\n    ");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("strong");
        var el4 = dom.createTextNode("2");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createTextNode("\n    todos left\n  ");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createTextNode("\n  ");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("ul");
        dom.setAttribute(el2,"id","filters");
        var el3 = dom.createTextNode("\n    ");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("li");
        var el4 = dom.createTextNode("\n      ");
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("a");
        dom.setAttribute(el4,"href","all");
        dom.setAttribute(el4,"class","selected");
        var el5 = dom.createTextNode("All");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createTextNode("\n    ");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createTextNode("\n    ");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("li");
        var el4 = dom.createTextNode("\n      ");
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("a");
        dom.setAttribute(el4,"href","active");
        var el5 = dom.createTextNode("Active");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createTextNode("\n    ");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createTextNode("\n    ");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("li");
        var el4 = dom.createTextNode("\n      ");
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("a");
        dom.setAttribute(el4,"href","completed");
        var el5 = dom.createTextNode("Completed");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createTextNode("\n    ");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createTextNode("\n  ");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createTextNode("\n  ");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("button");
        dom.setAttribute(el2,"id","clear-completed");
        var el3 = dom.createTextNode("\n    Clear completed (1)\n  ");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createTextNode("\n");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createTextNode("\n");
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, get = hooks.get, inline = hooks.inline, block = hooks.block;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var morph0 = dom.createMorphAt(fragment,0,1,contextualElement);
        var morph1 = dom.createMorphAt(dom.childAt(fragment, [2, 1]),0,1);
        inline(env, morph0, context, "input", [], {"type": "text", "id": "new-todo", "placeholder": "What needs to be done?", "value": get(env, context, "newTitle"), "action": "createTodo"});
        block(env, morph1, context, "each", [], {"itemController": "todo"}, child0, null);
        return fragment;
      }
    };
  }()));

});
define('todo-mvc/tests/adapters/application.jshint', function () {

  'use strict';

  module('JSHint - adapters');
  test('adapters/application.js should pass jshint', function() { 
    ok(true, 'adapters/application.js should pass jshint.'); 
  });

});
define('todo-mvc/tests/app.jshint', function () {

  'use strict';

  module('JSHint - .');
  test('app.js should pass jshint', function() { 
    ok(true, 'app.js should pass jshint.'); 
  });

});
define('todo-mvc/tests/controllers/todo.jshint', function () {

  'use strict';

  module('JSHint - controllers');
  test('controllers/todo.js should pass jshint', function() { 
    ok(true, 'controllers/todo.js should pass jshint.'); 
  });

});
define('todo-mvc/tests/controllers/todos.jshint', function () {

  'use strict';

  module('JSHint - controllers');
  test('controllers/todos.js should pass jshint', function() { 
    ok(true, 'controllers/todos.js should pass jshint.'); 
  });

});
define('todo-mvc/tests/helpers/resolver', ['exports', 'ember/resolver', 'todo-mvc/config/environment'], function (exports, Resolver, config) {

  'use strict';

  var resolver = Resolver['default'].create();

  resolver.namespace = {
    modulePrefix: config['default'].modulePrefix,
    podModulePrefix: config['default'].podModulePrefix
  };

  exports['default'] = resolver;

});
define('todo-mvc/tests/helpers/resolver.jshint', function () {

  'use strict';

  module('JSHint - helpers');
  test('helpers/resolver.js should pass jshint', function() { 
    ok(true, 'helpers/resolver.js should pass jshint.'); 
  });

});
define('todo-mvc/tests/helpers/start-app', ['exports', 'ember', 'todo-mvc/app', 'todo-mvc/router', 'todo-mvc/config/environment'], function (exports, Ember, Application, Router, config) {

  'use strict';



  exports['default'] = startApp;
  function startApp(attrs) {
    var application;

    var attributes = Ember['default'].merge({}, config['default'].APP);
    attributes = Ember['default'].merge(attributes, attrs); // use defaults, but you can override;

    Ember['default'].run(function () {
      application = Application['default'].create(attributes);
      application.setupForTesting();
      application.injectTestHelpers();
    });

    return application;
  }

});
define('todo-mvc/tests/helpers/start-app.jshint', function () {

  'use strict';

  module('JSHint - helpers');
  test('helpers/start-app.js should pass jshint', function() { 
    ok(true, 'helpers/start-app.js should pass jshint.'); 
  });

});
define('todo-mvc/tests/models/todo.jshint', function () {

  'use strict';

  module('JSHint - models');
  test('models/todo.js should pass jshint', function() { 
    ok(true, 'models/todo.js should pass jshint.'); 
  });

});
define('todo-mvc/tests/router.jshint', function () {

  'use strict';

  module('JSHint - .');
  test('router.js should pass jshint', function() { 
    ok(true, 'router.js should pass jshint.'); 
  });

});
define('todo-mvc/tests/routes/todos.jshint', function () {

  'use strict';

  module('JSHint - routes');
  test('routes/todos.js should pass jshint', function() { 
    ok(true, 'routes/todos.js should pass jshint.'); 
  });

});
define('todo-mvc/tests/test-helper', ['todo-mvc/tests/helpers/resolver', 'ember-qunit'], function (resolver, ember_qunit) {

	'use strict';

	ember_qunit.setResolver(resolver['default']);

});
define('todo-mvc/tests/test-helper.jshint', function () {

  'use strict';

  module('JSHint - .');
  test('test-helper.js should pass jshint', function() { 
    ok(true, 'test-helper.js should pass jshint.'); 
  });

});
define('todo-mvc/tests/unit/adapters/application-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleFor("adapter:application", "ApplicationAdapter", {});

  // Replace this with your real tests.
  ember_qunit.test("it exists", function (assert) {
    var adapter = this.subject();
    assert.ok(adapter);
  });

  // Specify the other units that are required for this test.
  // needs: ['serializer:foo']

});
define('todo-mvc/tests/unit/adapters/application-test.jshint', function () {

  'use strict';

  module('JSHint - unit/adapters');
  test('unit/adapters/application-test.js should pass jshint', function() { 
    ok(true, 'unit/adapters/application-test.js should pass jshint.'); 
  });

});
define('todo-mvc/tests/unit/controllers/todo-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleFor("controller:todo", {});

  // Replace this with your real tests.
  ember_qunit.test("it exists", function (assert) {
    var controller = this.subject();
    assert.ok(controller);
  });

  // Specify the other units that are required for this test.
  // needs: ['controller:foo']

});
define('todo-mvc/tests/unit/controllers/todo-test.jshint', function () {

  'use strict';

  module('JSHint - unit/controllers');
  test('unit/controllers/todo-test.js should pass jshint', function() { 
    ok(true, 'unit/controllers/todo-test.js should pass jshint.'); 
  });

});
define('todo-mvc/tests/unit/controllers/todos-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleFor("controller:todos", {});

  // Replace this with your real tests.
  ember_qunit.test("it exists", function (assert) {
    var controller = this.subject();
    assert.ok(controller);
  });

  // Specify the other units that are required for this test.
  // needs: ['controller:foo']

});
define('todo-mvc/tests/unit/controllers/todos-test.jshint', function () {

  'use strict';

  module('JSHint - unit/controllers');
  test('unit/controllers/todos-test.js should pass jshint', function() { 
    ok(true, 'unit/controllers/todos-test.js should pass jshint.'); 
  });

});
define('todo-mvc/tests/unit/models/todo-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleForModel("todo", {
    // Specify the other units that are required for this test.
    needs: []
  });

  ember_qunit.test("it exists", function (assert) {
    var model = this.subject();
    // var store = this.store();
    assert.ok(!!model);
  });

});
define('todo-mvc/tests/unit/models/todo-test.jshint', function () {

  'use strict';

  module('JSHint - unit/models');
  test('unit/models/todo-test.js should pass jshint', function() { 
    ok(true, 'unit/models/todo-test.js should pass jshint.'); 
  });

});
define('todo-mvc/tests/unit/routes/todos-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleFor("route:todos", {});

  ember_qunit.test("it exists", function (assert) {
    var route = this.subject();
    assert.ok(route);
  });

  // Specify the other units that are required for this test.
  // needs: ['controller:foo']

});
define('todo-mvc/tests/unit/routes/todos-test.jshint', function () {

  'use strict';

  module('JSHint - unit/routes');
  test('unit/routes/todos-test.js should pass jshint', function() { 
    ok(true, 'unit/routes/todos-test.js should pass jshint.'); 
  });

});
/* jshint ignore:start */

/* jshint ignore:end */

/* jshint ignore:start */

define('todo-mvc/config/environment', ['ember'], function(Ember) {
  var prefix = 'todo-mvc';
/* jshint ignore:start */

try {
  var metaName = prefix + '/config/environment';
  var rawConfig = Ember['default'].$('meta[name="' + metaName + '"]').attr('content');
  var config = JSON.parse(unescape(rawConfig));

  return { 'default': config };
}
catch(err) {
  throw new Error('Could not read config from meta tag with name "' + metaName + '".');
}

/* jshint ignore:end */

});

if (runningTests) {
  require("todo-mvc/tests/test-helper");
} else {
  require("todo-mvc/app")["default"].create({"name":"todo-mvc","version":"0.0.0.60be4f93"});
}

/* jshint ignore:end */
//# sourceMappingURL=todo-mvc.map