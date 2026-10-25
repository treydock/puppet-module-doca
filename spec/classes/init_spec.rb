# frozen_string_literal: true

require 'spec_helper'

describe 'doca' do
  on_supported_os.each do |os, facts|
    context "when #{os}" do
      let(:facts) do
        facts.merge(concat_basedir: '/dne')
      end

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to create_class('doca') }

      it { is_expected.to contain_class('doca::repo').that_comes_before('Class[doca::install]') }
      it { is_expected.to contain_class('doca::install').that_comes_before('Class[doca::config]') }
      it { is_expected.to contain_class('doca::config').that_comes_before('Class[doca::service]') }
      it { is_expected.to contain_class('doca::service') }

      describe 'doca::install' do
        it do
          is_expected.to contain_package('doca-ofed').only_with(
            ensure: 'present',
          )
        end
      end

      describe 'doca::service' do
        it do
          is_expected.to contain_service('openibd').only_with(
            ensure: 'running',
            enable: 'true',
            name: 'openibd',
          )
        end
      end
    end
  end
end
