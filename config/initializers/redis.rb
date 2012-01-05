# encoding: utf-8
require 'redis-namespace'

$gallifreyian_store = Redis::Namespace.new(
  "#{Rails.application.class.to_s.split("::").first.downcase}_gallifreyian_#{Rails.env}",
  :redis => Redis.new
)
