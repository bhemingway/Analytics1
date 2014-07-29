require 'test_helper'

class RprocsControllerTest < ActionController::TestCase
  setup do
    @rproc = rprocs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rprocs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rproc" do
    assert_difference('Rproc.count') do
      post :create, rproc: { description: @rproc.description, name: @rproc.name }
    end

    assert_redirected_to rproc_path(assigns(:rproc))
  end

  test "should show rproc" do
    get :show, id: @rproc
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rproc
    assert_response :success
  end

  test "should update rproc" do
    put :update, id: @rproc, rproc: { description: @rproc.description, name: @rproc.name }
    assert_redirected_to rproc_path(assigns(:rproc))
  end

  test "should destroy rproc" do
    assert_difference('Rproc.count', -1) do
      delete :destroy, id: @rproc
    end

    assert_redirected_to rprocs_path
  end
end
