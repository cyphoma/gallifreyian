# encoding: utf-8
def mock_classified_translation(options = {}, stubs = {})
  mock = Array.new
  mock.stub!(:title).and_return(Faker::Lorem.sentence(1))
  mock.stub!(:content).and_return(Faker::Lorem.paragraphs(2).join(' ')[0..450])
  mock.stub!(:language).and_return([:fr, :en].sample)
  mock.stub!(:build).and_return(mock)
  mock
end

def mock_i18n_key(options = {}, stubs={})
  mock = mock_model(Gallifreyian::I18nKey, stubs)
  mock.stub!(:language).and_return([:en, :fr, :de, :ja].sample)
  mock.stub!(:key).and_return(Faker::Lorem.sentence(1).split.join('.'))
  mock.stub!(:datum).and_return(Faker::Lorem.sentence(1))
  mock.stub!(:id).and_return(BSON::ObjectId.new.to_s)
  mock.stub!(:translations).and_return(mock_classified_translation)
  mock.stub!(:available_translations).and_return(mock_classified_translation)
  Gallifreyian::I18nKey.stub!(:find).with(mock.id).and_return(mock)
  mock
end
