# encoding: utf-8
FactoryGirl.define do
  factory :translation, class: Gallifreyian::Translation do |t|
    t.language              { [:en, :fr, :de, :ja].sample}
    t.key                   { Faker::Lorem.sentence(1).split.join('.') }
    t.datum                 { Faker::Lorem.sentence(1) }
  end
end
