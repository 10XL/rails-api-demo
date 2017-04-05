(function() {
  'use strict';

  angular
    .module('spa-demo.foos')
    .controller('spa-demo.foos.FoosController', FoosController);

  FoosController.$inject = ['spa-demo.foos.Foo'];

  function FoosController(Foo) {
    var vm = this;
    vm.foos;
    vm.foo;
    vm.edit = edit;
    vm.create = create;
    vm.update = update;
    vm.remove = remove;

    activate();
    return;
    ////////////////
    function activate() {
      newFoo();
      vm.foos = Foo.query();
    }

    function newFoo() {
      vm.foo = new Foo();
    }

    function handleError(res) {
      console.log(res);
    }

    function edit(object, index) {

    }

    function create() {
      //console.log("creating foo", vm.foo);
      vm.foo.$save()
        .then(function(res) {
          console.log(res);
          vm.foos.push(vm.foo);
          newFoo();
        }).catch(handleError);
    }

    function update() {

    }

    function remove() {

    }

    function removeElement(elements, element) {

    }

  }
})();