# encoding: utf-8

def mock_translation(options = {}, stubs={})
  mock = mock_model(Gallifreyian::I18nKey, stubs)
  mock.stub!(:language).and_return([:en, :fr, :de, :ja].sample)
  mock.stub!(:key).and_return(Faker::Lorem.sentence(1).split.join('.'))
  mock.stub!(:datum).and_return(Faker::Lorem.sentence(1))
  mock.stub!(:id).and_return(BSON::ObjectId.new.to_s)
  Gallifreyian::I18nKey.stub!(:find).with(mock.id).and_return(mock)
  mock
end
