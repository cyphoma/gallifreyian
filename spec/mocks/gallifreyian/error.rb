# encoding: utf-8
def mock_error
  error = mock
  error.stub!(:empty?).and_return(false)
  error.stub!(:any?).and_return(false)
  error.stub!(:count).and_return(1)
  error.stub!(:compact).and_return(['Error!'])
  error.stub!(:[]).and_return(error)
  error.stub!(:+).and_return(error)
  error.stub!(:full_messages).and_return(['fail !'])
  error.stub!(:as_json).and_return({})
  error.stub!(:to_json).and_return({})
  error
end
