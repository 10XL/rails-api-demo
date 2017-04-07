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

    function edit(object) {
      console.log("selected", object);
      vm.foo = object;
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
      vm.foo.$update()
        .then(function(res){
          // console.log(res);
        })
        .catch(handleError);
    }

    function remove() {
      // console.log("remove", vm.foo);
      vm.foo.$delete()
        .then(function(res){
          // console.log(res);
          // remove the element from local array
          removeElement(vm.foos, vm.foo);
          // vm.foos = Foo.query();
          // replace edit area with prototype instance
          newFoo(); 
        })
        .catch(handleError);
    }

    function removeElement(elements, element) {
      for (var i=0; elements[i].id === element.id; i++)
        if (elements[i].id === element.id) elements.splice(i, 1);
    }

  }
})();