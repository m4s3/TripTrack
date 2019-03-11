require 'test_helper'

class PlaceTest < ActiveSupport::TestCase
  def setup
    @place = Place.new(user_id: users(:michael).id,
                                     lat: 15.555, lng:92.555, name: "Roma")
    
  end

  test "should be valid" do
    assert @place.valid?
  end

  test "should require a user_id" do
    @place.user_id = nil
    assert_not @place.valid?
  end

  test "should require a lat" do
    @place.lat = nil
    assert_not @place.valid? 
  end
  
  test "should require a lng" do
    @place.lng = nil
    assert_not @place.valid?
  end
end
