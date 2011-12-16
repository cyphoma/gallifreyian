# encoding: utf-8
require 'spec_helper'

describe Gallifreyian::TranslationsController do
  let(:translation)  { mock_translation }
  let(:translations) { mock_paginate(translation)}
  let(:error)        { mock_error }

  describe 'GET index' do
    pending 'bad routes in spec context from views'

    before do
      Gallifreyian::Translation.should_receive(:all).and_return(translations)
      translations.should_receive(:page).and_return(translations)
      get :index, use_route: :gallifreyian
    end

    pending 'assigns translations as @translations' do
      assigns(:translations).should eq translations
    end

    pending 'should be success' do
      response.should be_success
    end
  end

  describe 'GET new' do
    before do
      Gallifreyian::Translation.should_receive(:new).and_return(translation)
      get :new, use_route: :gallifreyian
    end

    it 'should assign translation as @translation' do
      assigns(:translation).should eq translation
    end

    it 'should be success' do
      response.should be_success
    end
  end

  describe 'GET edit' do
    before do
      get :edit, id: translation.id.to_s, use_route: :gallifreyian
    end

    it 'should assign translation as @translation' do
      assigns(:translation).should eq translation
    end

    it 'should be success' do
      response.should be_success
    end
  end

  describe 'POST create' do
    context 'with a valid request' do
      before do
        Gallifreyian::Translation.should_receive(:create).with({'these' => 'params'}).and_return(translation)
        post :create, translation: {'these' => 'params'}, use_route: :gallifreyian
      end

      it 'should assign translation as @translation' do
        assigns(:translation).should eq translation
      end

      it "should be redirected" do
        response.should redirect_to "/gallifreyian/translations"
      end
    end

    context 'with an invalid request' do
      before do
        Gallifreyian::Translation.should_receive(:create).with({'these' => 'params'}).and_return(translation)
        translation.should_receive(:errors).any_number_of_times.and_return(error)
        post :create, translation: {'these' => 'params'}, use_route: :gallifreyian
      end

      it 'should assign translation as @translation' do
        assigns(:translation).should eq translation
      end

      it "should render template" do
        response.should render_template(:new)
      end
    end
  end

  describe 'PUT update' do
    context 'with a valid request' do
      before do
        translation.should_receive(:update_attributes).with({'these' => 'params'}).and_return(translation)
        put :update, id: translation.id.to_s, translation: {'these' => 'params'}, use_route: :gallifreyian
      end

      it 'should assign translation as @translation' do
        assigns(:translation).should eq translation
      end

      it "should be redirected" do
        response.should redirect_to "/gallifreyian/translations"
      end
    end

    context 'with an invalid request' do
      before do
        translation.should_receive(:update_attributes).with({'these' => 'params'}).and_return(translation)
        translation.should_receive(:errors).any_number_of_times.and_return(error)
        put :update, id: translation.id.to_s, translation: {'these' => 'params'}, use_route: :gallifreyian
      end

      it 'should assign translation as @translation' do
        assigns(:translation).should eq translation
      end

      it "should render template" do
        response.should render_template(:edit)
      end
    end
  end

  describe 'DELETE destroy' do
    before do
      translation.should_receive(:destroy).and_return(true)
      delete :destroy, id: translation.id.to_s, use_route: :gallifreyian
    end

    it 'should assign translation as @translation' do
      assigns(:translation).should eq translation
    end

    it "should be redirected" do
      response.should redirect_to '/gallifreyian/translations'
    end
  end
end
