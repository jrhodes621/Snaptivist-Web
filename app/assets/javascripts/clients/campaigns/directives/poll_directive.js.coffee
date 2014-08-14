@app.directive 'ngPoll', ['$timeout', '$window', ($timeout, $window) ->
  restrict: "A"
  replace: true
  scope: {
    segment: '=segment'
    action: '='
    isAdmin: '='
  }
  templateUrl: '/clients/campaigns/partials/poll_template'
  link: (scope, element, attrs) ->

    if !scope.action
      scope.action = {
        type: 'poll_action'
        poll_choices: []
      }

    if !scope.action.poll_choices
      scope.action.poll_choices = []

    poll_choices = scope.action.poll_choices.length
    while poll_choices < 3
      poll_choice = {
        position: scope.action.poll_choices.length + 1
      }
      scope.action.poll_choices.push poll_choice
      poll_choices += 1

    scope.add_poll_choice_clicked = ->
      poll_choice = {
        position: scope.action.poll_choices.length + 1
      }
      scope.action.poll_choices.push poll_choice
      
    scope.remove_poll_choice_clicked = (poll_choice) ->
      console.log "number of options " + scope.action.poll_choices.length

      poll_choice._destroy = true

  controller: ($scope, $attrs) ->

    console.log($scope.action)

    $scope.poll_choice_clicked = (poll_choice) ->
      console.log "poll choice clicked"

      $scope.action.selected_poll_choice = poll_choice

    $scope.set_poll_choice_icon = (poll_choice) ->
      if(poll_choice == $scope.action.selected_poll_choice)
        return "fa-circle"
      else
        return "fa-circle-o"

    window.poll_scope = $scope

]
