# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'doca class' do
  context 'with default parameters' do
    it 'runs successfully' do
      pp = <<-PP
        class { 'doca':
          openibd_service_ensure => 'stopped',
          openibd_service_enable => false,
        }
      PP

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe package('doca-ofed') do
      it { is_expected.to be_installed }
    end

    describe service('openibd') do
      it { is_expected.not_to be_enabled }
      it { is_expected.not_to be_running }
    end
  end
end
