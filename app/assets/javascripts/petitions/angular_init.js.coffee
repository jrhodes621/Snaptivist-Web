@app = angular.module('petition', ['ui.bootstrap'])
	.value('$anchorScroll', angular.noop)

@app.config ['$routeProvider', ($routeProvider) ->
  base_page_url = '/sign'
  $routeProvider.when('/sign',
    templateUrl: '/client_views/sign'
    controller: SignatureController 
  ).when('/deliver',
    templateUrl: '/client_views/deliver'
    controller: DeliveryController 
  ).when('/complete',
    templateUrl: '/client_views/more'
    controller: MoreActionController 
    resolve: MoreActionController.resolve
  ).otherwise redirectTo: base_page_url
]

@app.config ['$locationProvider', ($locationProvider) ->
  $locationProvider.html5mode = true
]
@app.filter "fromNow", ->
  (dateString) ->
    moment(new Date(dateString)).fromNow()

@app.directive "facebook", ($http, Util, $q, $location, PetitionServices) ->
  restrict: "A"
  scope: true
  controller: ($scope, $attrs) ->
    
    # Load the SDK Asynchronously
    login = ->
      FB.login ((response) ->
        if response.authResponse
          console.log "FB.login connected"
          Util.push_ga_event("Petition", "Facebook Login", "Connected")
   
          $scope.sign_with_facebook(response.authResponse)
        else
          console.log "FB.login cancelled"

          Util.push_ga_event("Petition", "Facebook Login", "Cancelled")

          $scope.sign_with_facebook_cancelled()
   
      ),
        scope: "email,publish_stream"

    fetch = ->

      console.log "Signing with Facebook"

      scope.$broadcast('handleFacebookAuth')


    ((d) ->
      js = undefined
      id = "facebook-jssdk"
      ref = d.getElementsByTagName("script")[0]
      return  if d.getElementById(id)
      js = d.createElement("script")
      js.id = id
      js.async = true
      js.src = "//connect.facebook.net/en_US/all.js"
      ref.parentNode.insertBefore js, ref
    ) document
    $scope.fetch = ->
      $scope.loading.show_spinner = true
      if $scope.login_status is "connected"
        console.log "fetch"
        fetch()
      else
        login()

  link: (scope, element, attrs, controller) ->
    
    Util.push_ga_event("Petition", "Sign With Facebook", "Clicked")
   
    # Additional JS functions here
    window.fbAsyncInit = ->
      FB.init
        appId: attrs.facebook # App ID
        channelUrl: "//localhost:3000/channel.html" # Channel File
        status: true # check login status
        cookie: true # enable cookies to allow the server to access the session
        xfbml: true # parse XFBML

      
      # Additional init code here
      FB.getLoginStatus (response) ->
        if response.status is "connected"
          
          Util.push_ga_event("Petition", "Facebook Status", "Connected")
   
          # connected
          scope.auth = response.authResponse
        else if response.status is "not_authorized"
          Util.push_ga_event("Petition", "Facebook Status", "Not Authorized")
        
        # not_authorized
        else
          Util.push_ga_event("Petition", "Facebook Status", "Not Logged In")
        
          # not_logged_in
          scope.login_status = response.status
          scope.$apply()


# end of fbAsyncInit