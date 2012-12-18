class ClassSet
  constructor: (@jquery_selector) ->

  add_class: (class_name) ->
    @jquery_selector.addClass(class_name)

class TreeList
  constructor: (@jquery_selector) ->

  list_item_parents: ->
    @jquery_selector.parents('li') if @jquery_selector

$(document).ready ->

  parser = document.createElement 'a'
  parser.href = document.URL
  path = parser.pathname

  tree_list = new TreeList($('a[href$="' + path + '"]'))
  tree_list_items = tree_list.list_item_parents()
  class_set = new ClassSet($(tree_list_items))
  class_set.add_class('active')

  $('li.active').children('a').addClass('active')

