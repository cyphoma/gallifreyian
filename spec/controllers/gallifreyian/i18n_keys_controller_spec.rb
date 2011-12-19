# encoding: utf-8
require 'spec_helper'

describe Gallifreyian::I18nKeysController do
  let(:i18n_key)  { mock_i18n_key }
  let(:i18n_keys) { mock_paginate(i18n_key)}
  let(:error)        { mock_error }

  describe 'GET index' do
    pending 'bad routes in spec context from views'

    before do
      Gallifreyian::I18nKey.should_receive(:all).and_return(i18n_keys)
      i18n_keys.should_receive(:page).and_return(i18n_keys)
      get :index, use_route: :gallifreyian
    end

    pending 'assigns i18n_keys as @i18n_keys' do
      assigns(:i18n_keys).should eq i18n_keys
    end

    pending 'should be success' do
      response.should be_success
    end
  end

  describe 'GET new' do
    before do
      Gallifreyian::I18nKey.should_receive(:new).and_return(i18n_key)
      get :new, use_route: :gallifreyian
    end

    it 'should assign i18n_key as @i18n_key' do
      assigns(:i18n_key).should eq i18n_key
    end

    it 'should be success' do
      response.should be_success
    end
  end

  describe 'GET edit' do
    before do
      get :edit, id: i18n_key.id.to_s, use_route: :gallifreyian
    end

    it 'should assign i18n_key as @i18n_key' do
      assigns(:i18n_key).should eq i18n_key
    end

    it 'should be success' do
      response.should be_success
    end
  end

  describe 'POST create' do
    context 'with a valid request' do
      before do
        Gallifreyian::I18nKey.should_receive(:create).with({'these' => 'params'}).and_return(i18n_key)
        post :create, i18n_key: {'these' => 'params'}, use_route: :gallifreyian
      end

      it 'should assign i18n_key as @i18n_key' do
        assigns(:i18n_key).should eq i18n_key
      end

      it "should be redirected" do
        response.should redirect_to "/gallifreyian/i18n_keys"
      end
    end

    context 'with an invalid request' do
      before do
        Gallifreyian::I18nKey.should_receive(:create).with({'these' => 'params'}).and_return(i18n_key)
        i18n_key.should_receive(:errors).any_number_of_times.and_return(error)
        post :create, i18n_key: {'these' => 'params'}, use_route: :gallifreyian
      end

      it 'should assign i18n_key as @i18n_key' do
        assigns(:i18n_key).should eq i18n_key
      end

      it "should render template" do
        response.should render_template(:new)
      end
    end
  end

  describe 'PUT update' do
    context 'with a valid request' do
      before do
        i18n_key.should_receive(:update_attributes).with({'these' => 'params'}).and_return(i18n_key)
        put :update, id: i18n_key.id.to_s, i18n_key: {'these' => 'params'}, use_route: :gallifreyian
      end

      it 'should assign i18n_key as @i18n_key' do
        assigns(:i18n_key).should eq i18n_key
      end

      it "should be redirected" do
        response.should redirect_to "/gallifreyian/i18n_keys"
      end
    end

    context 'with an invalid request' do
      before do
        i18n_key.should_receive(:update_attributes).with({'these' => 'params'}).and_return(i18n_key)
        i18n_key.should_receive(:errors).any_number_of_times.and_return(error)
        put :update, id: i18n_key.id.to_s, i18n_key: {'these' => 'params'}, use_route: :gallifreyian
      end

      it 'should assign i18n_key as @i18n_key' do
        assigns(:i18n_key).should eq i18n_key
      end

      it "should render template" do
        response.should render_template(:edit)
      end
    end
  end

  describe 'DELETE destroy' do
    before do
      i18n_key.should_receive(:destroy).and_return(true)
      delete :destroy, id: i18n_key.id.to_s, use_route: :gallifreyian
    end

    it 'should assign i18n_key as @i18n_key' do
      assigns(:i18n_key).should eq i18n_key
    end

    it "should be redirected" do
      response.should redirect_to '/gallifreyian/i18n_keys'
    end
  end
end
