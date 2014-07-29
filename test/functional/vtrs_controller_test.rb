require 'test_helper'

class VtrsControllerTest < ActionController::TestCase
  setup do
    @vtr = vtrs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vtrs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vtr" do
    assert_difference('Vtr.count') do
      post :create, vtr: { action: @vtr.action, comment: @vtr.comment, date: @vtr.date, election: @vtr.election, form: @vtr.form, formNote: @vtr.formNote, jurisdiction: @vtr.jurisdiction, leo: @vtr.leo, notes: @vtr.notes, voterid: @vtr.voterid }
    end

    assert_redirected_to vtr_path(assigns(:vtr))
  end

  test "should show vtr" do
    get :show, id: @vtr
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @vtr
    assert_response :success
  end

  test "should update vtr" do
    put :update, id: @vtr, vtr: { action: @vtr.action, comment: @vtr.comment, date: @vtr.date, election: @vtr.election, form: @vtr.form, formNote: @vtr.formNote, jurisdiction: @vtr.jurisdiction, leo: @vtr.leo, notes: @vtr.notes, voterid: @vtr.voterid }
    assert_redirected_to vtr_path(assigns(:vtr))
  end

  test "should destroy vtr" do
    assert_difference('Vtr.count', -1) do
      delete :destroy, id: @vtr
    end

    assert_redirected_to vtrs_path
  end
end
