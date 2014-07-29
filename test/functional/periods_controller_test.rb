require 'test_helper'

class PeriodsControllerTest < ActionController::TestCase
  setup do
    @period = periods(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:periods)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create period" do
    assert_difference('Period.count') do
      post :create, period: { hidate: @period.hidate, lodate: @period.lodate, name: @period.name, type: @period.type, voter_reg_hidate: @period.voter_reg_hidate, voter_reg_lodate: @period.voter_reg_lodate }
    end

    assert_redirected_to period_path(assigns(:period))
  end

  test "should show period" do
    get :show, id: @period
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @period
    assert_response :success
  end

  test "should update period" do
    put :update, id: @period, period: { hidate: @period.hidate, lodate: @period.lodate, name: @period.name, type: @period.type, voter_reg_hidate: @period.voter_reg_hidate, voter_reg_lodate: @period.voter_reg_lodate }
    assert_redirected_to period_path(assigns(:period))
  end

  test "should destroy period" do
    assert_difference('Period.count', -1) do
      delete :destroy, id: @period
    end

    assert_redirected_to periods_path
  end
end
