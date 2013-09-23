BaseController = require './base'
FeedParser = require 'feedparser'
request = require 'request'

module.exports = class FeedController extends BaseController

	index: (req, res) ->
		res.redirect 301, '/'

	create: (req, res) ->
		request('http://www.rodaine.com/feed.xml').pipe(res)




