
moderator = null
presenter = null
viewer =
  # raising/lowering hand
  raiseOwnHand : true
  lowerOwnHand : true

  # muting
  muteSelf : true
  unmuteSelf : true

  logoutSelf : true

  #subscribing
  subscribeUsers: true
  subscribeChat: true

  #chat
  chatPublic: true #should make this dynamically modifiable later on
  chatPrivate: true #should make this dynamically modifiable later on

@isAllowedTo = (action, meetingId, userId, authToken) ->
  validated = Meteor.Users.findOne({meetingId:meetingId, userId: userId})?.validated
  Meteor.log.info "in isAllowedTo: action-#{action}, userId=#{userId}, authToken=#{authToken} validated:#{validated}"

  user = Meteor.Users.findOne({meetingId:meetingId, userId: userId})
  if user? and user.validated and user.clientType is "HTML5"
    # we check if the user is who he claims to be
    if authToken is user.authToken
      if user.user?.role is 'VIEWER' or user.user?.role is undefined
        return viewer[action] or false
    Meteor.log.error "in meetingId=#{meetingId} userId=#{userId} tried to perform #{action} without permission" +
     "\n..while the authToken was #{user.authToken}    and the user's object is #{JSON.stringify user}"

    # the current version of the HTML5 client represents only VIEWER users
  else
    Meteor.log.warn "UNSUCCESSFULL ATTEMPT FROM userid=#{userId} to perform:#{action}"
  return false
