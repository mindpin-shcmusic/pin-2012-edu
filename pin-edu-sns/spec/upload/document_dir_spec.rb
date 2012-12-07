# -*- coding: utf-8 -*-
require 'spec_helper'


describe Admin::UploadDocumentDirsController do
  describe '.create_folder action' do
    it 'should assign top videos' do
      params = { :dir_id => 0, :name => 'video' }
      @upload_document_dir = mock_model(UploadDocumentDir)
      UploadDocumentDir.should_receive(:new).and_return(@upload_document_dir)
      @video.should_receive(:update_attributes).with(params).and_return(true)
      get :index, :video => params
      assigns[:video].should be(@video)
    end
  end
end