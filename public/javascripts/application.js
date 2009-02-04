var Tasks = {
  init: function() {
    Tasks.makeSortable();
    
    this.refresh();
    
    // Show javascript specific links
    $$('.require_js').each(function(item) {
      item.show();
      item.disabled = false;
    });
  },
  
  refresh: function() {
    this.interval = setInterval(Tasks.cleanEmptySections.bind(this), 40);
    
    $('new_task_name').focus()
  },
  
  makeSortable: function(element) {
    tasks = $$('.tasks').collect(function(element) { return element.id });
    
    tasks.each(function(element) {
      Sortable.create(element, {
        tag: 'div',
        containment: tasks,
        constraint: '',
        handle: 'handle',
        dropOnEmpty: true,
        onUpdate: function() {
          new Ajax.Request(Tasks.sortUrl, {
            parameters: Sortable.serialize(element)
          });
          Tasks.refresh();
        }
      });
    });
  },
  
  cleanEmptySections: function() {
    // Well, we must wait for the effect queue to emptied, must be a better way...
    if (Effect.Queue.size() > 0) return;
    
    $$('.dynamic').each(function(element) {
      if (element.select('.task').find(function(child) { return child.visible() }) == null) {
        new Effect.Fade(element.id + '_title');
        element.hide();
      }
    });
    clearInterval(this.interval);
  },
  
  insertNewSection: function(section_id, html) {
    if ($(section_id) != null) {
      new Effect.Appear(section_id + '_title');
      $(section_id).show();
    } else {
      var date = parseInt(section_id.match(/tasks_(\d+)/)[1]);
      var section = null;
      // Finds in which section to insert the new one.
      $$('.tasks.dynamic').reverse().each(function(element) {
        if (date < parseInt(element.id.match(/tasks_(\d+)/)[1])) {
          section = element;
        }
      });
      if (section != null) {
        new Insertion.Before(section.id + '_title', html);
      } else {
        new Insertion.Bottom('dated_side', html);
      }
    }
  },
  
  highlightCategories: function(category) {
    $$('.task').each(function(task) {
      categoryElement = task.getElementsByClassName('category')[0];
      if (categoryElement != null && categoryElement.innerHTML == category) {
        new Effect.Highlight(task);
      }
    });
  }
  
};

var EffectWatcher = {
  whenComplete: function(callback) {
    this.interval = setInterval(function() {
      if (Effect.Queue.size() > 0) return;
      callback.call();
      this.stop();
    }.bind(this), 40);
  },
  
  stop: function() {
    clearInterval(this.interval);
  }
};
