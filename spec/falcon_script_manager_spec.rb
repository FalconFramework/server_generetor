# require 'spec_helper'
#
# describe FalconScriptManager do
#   let(:file_name) { 'falcon.sh' }
#   let(:script_manager) { FalconScriptManager.new(file_name) }
#   let(:file_var) { script_manager.instance_variable_get(:@file) }
#
#   context '#initialize' do
#     it 'script manager not nil' do
#       expect(script_manager).not_to eq nil
#     end
#
#     it 'file created' do
#       expect(File.exists?(file_name)).to be true
#     end
#
#     it 'file is writable' do
#       expect(File.writable?(file_name)).to be true
#     end
#
#   end
#
#   context '#write_to_file' do
#       before :each do
#         script_manager.write_to_file("ok")
#         script_manager.write_to_file("ok")
#       end
#       it 'number of lines ' do
#         script_manager.close_file
#         file = File.open file_name
#       expect(file.readlines.size).to eq 2
#       end
#   end
#
#   context '#close_file' do
#     it 'file closed' do
#       script_manager.close_file
#       expect(file_var.closed?).to eq true
#     end
#   end
#
# end
