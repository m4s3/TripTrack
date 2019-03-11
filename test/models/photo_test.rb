require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  def setup
    @photo = Photo.new(picture: "string.iuu",
                      place_id: places(:one).id)
  end
  test "should be valid" do
    assert @photo.valid?
    #assert @photo.valid?
  end

  test "should require a place_id" do
    @photo.place_id = nil
    assert_not @photo.valid?
  end

  test "should require a picture " do
    @photo.picture = nil
    assert_not @photo.valid?
  end
end
