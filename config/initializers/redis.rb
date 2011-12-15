# encoding: utf-8
require 'redis-namespace'

$gallifreyian_store = Redis::Namespace.new("gallifreyian_#{Rails.env}", :redis => Redis.new)
