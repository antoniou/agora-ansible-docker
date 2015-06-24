/*
 * ConfigService is a function that returns the configuration that exists
 * in this same file, which you might want to edit and tune if needed.
 */

var avConfigData = {
  // the base url path for ajax requests, for example for sending ballots or
  // getting info about an election. This url is usually in the form of
  // 'https://foo/api/v3/' and always ends in '/'.
  theme: "default",
  baseUrl: "http://AGORAENV_baseUrl/elections/api/",
  freeAuthId: 1,

  // AuthApi base url
  authAPI: "http://AGORAENV_authAPI/authapi/api/",
  dnieUrl: "https://AGORAENV_dnieUrl/authapi/api/authmethod/dnie/auth/",
  // Agora Elections base url
  electionsAPI: "http://{{ agora_elections_domain }}/elections/api/",

  authorities: [ "local-auth2" ],
  director: "local-auth1",

  // default language of the application
  language: "en",

  timeoutSeconds: 3600,

  publicURL: "http://AGORAENV_publicURL/elections/public/",

  // if we are in debug mode or not
  debug: true,

  // contact data where users can reach to a human when they need it
  contact: {
    email: "contact@example.com",
    twitter: "twitter",
    tlf: "-no tlf-"
  },

  help: {
    info:""
  },

  success: {
    text: ""
  },

  tos: {
    text:"",
    tile: ""
  }
};

angular.module('avConfig', [])
  .factory('ConfigService', function() {
      return avConfigData;
  });
