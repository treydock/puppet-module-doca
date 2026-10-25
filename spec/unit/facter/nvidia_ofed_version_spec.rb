# frozen_string_literal: true

require 'spec_helper'

describe 'nvidia_ofed_version fact' do
  context 'when Linux' do
    before(:each) do
      Facter.clear
      allow(Facter.fact(:kernel)).to receive(:value).and_return('Linux')
    end

    it 'returns version' do
      allow(Facter::Core::Execution).to receive(:which).and_return('/usr/bin/ofed_info')
      allow(Facter::Core::Execution).to receive(:execute).with('ofed_info -n 2>/dev/null').and_return("25.10-3.1.8\n")
      expect(Facter.fact(:nvidia_ofed_version).value).to eq('25.10-3.1.8')
    end

    it 'does not return version if error' do
      allow(Facter::Core::Execution).to receive(:which).and_return('/usr/bin/ofed_info')
      allow(Facter::Core::Execution).to receive(:execute).with('ofed_info -n 2>/dev/null').and_raise(Facter::Core::Execution::ExecutionFailure)
      expect(Facter.fact(:nvidia_ofed_version).value).to be_nil
    end

    it 'does not return version if no ofed_info' do
      allow(Facter::Core::Execution).to receive(:which).and_return(nil)
      expect(Facter.fact(:nvidia_ofed_version).value).to be_nil
    end
  end

  context 'when Windows' do
    before(:each) do
      Facter.clear
      allow(Facter.fact(:kernel)).to receive(:value).and_return('windows')
    end

    it 'is nil' do
      expect(Facter::Core::Execution).not_to receive(:which)
      expect(Facter.fact(:nvidia_ofed_version).value).to be_nil
    end
  end
end
