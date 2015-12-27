require 'test_helper'

class PurchaseControllerTest < ActionController::TestCase
  test "should get strawberry" do
    get :strawberry
    assert_response :success
  end

end
