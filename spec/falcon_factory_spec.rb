require 'spec_helper'

describe FalconFactory do

  describe '#proccess' do
    let(:model_input) { '\mymodelpath.yml' }
    let(:target_input) { '\mytargetpath' }
    let(:output) { subject.process_factory(model_input,target_input) }

    it 'plus' do
      expect(output).to eq "#{model_input}+#{target_input}"
    end


  end

end
