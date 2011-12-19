# encoding: utf-8
FactoryGirl.define do
  factory :translation, class: Gallifreyian::Translation::I18nKey do |t|
    t.datum                 { Faker::Lorem.sentence(1) }
    t.language              { [:en, :fr, :de, :ja].sample}
  end

  factory :i18n, class: Gallifreyian::I18nKey do |t|
    t.key                   { Faker::Lorem.sentence(1).split.join('.') }
    t.translations          { [Factory.build(:translation)]}
  end
end
