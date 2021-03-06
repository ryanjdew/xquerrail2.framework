'use strict';

var _ = require('lodash');
var fs = require('fs');
var assert = require('chai').assert;
var expect = require('chai').expect;
var request = require('request').defaults({jar: true});
var xml2js = require('xml2js');

var parser = new xml2js.Parser({explicitArray: false});

var xquerrail = {};

function login(callback) {
  var options = {
    method: 'POST',
    url: xquerrail.url + '/login',
    form: {
      username: xquerrail.username,
      password: xquerrail.password
    },
    followRedirect: true
  };

  request(options, callback);
};

function initialize(callback) {
  var options = {
    method: 'GET',
    url: xquerrail.url + '/initialize',
    followRedirect: true
  };

  // request(options, callback);
  request(options, function(error, response, body) {setTimeout(function(){callback(error, response, body)}, 100)});
};

describe('Authentication features', function() {

  before(function(done) {
    this.timeout(5000);
    var ml;
    try {
      ml = require('../../../../gulpfile.js').ml;
      if(ml === undefined) {
        throw new Error();
      }
    } catch(e) {
      console.log('Could find global ml try different location ./ml.json');
      ml = require('./ml.json');
    }
    xquerrail.url = 'http://' + ml.host + ":" + ml.port;
    xquerrail.username = ml.user;
    xquerrail.password = ml.password;
    console.log('Using XQuerrail: %j', xquerrail)
    initialize(function(error, response, body) {
      expect(response.statusCode).to.equal(200);
      done();
    });
  });

  describe('login', function() {
    it('should be successful', function(done) {
      login(function(error, response, body) {
        expect(response.statusCode).to.equal(302);
        expect(response.headers).to.include.keys('set-cookie');
        done();
      });
    });
  });

  describe('logout', function() {
    it('should be successful', function(done) {
      login(function(error, response, body) {
        expect(response.headers).to.include.keys('set-cookie');
        request.get( xquerrail.url + '/logout', function(error, response, body) {
          expect(response.url).to.be.empty;
          done();
        });
      });
    });
  })

});
