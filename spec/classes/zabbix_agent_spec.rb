# frozen_string_literal: true

require 'spec_helper'

describe 'zabbix_agent' do
  let(:node) { 'zabbix_agent.example.com' }
  let(:params) { {} }

  # add these two lines in a single test block to enable puppet and hiera debug mode
  # Puppet::Util::Log.level = :debug
  # Puppet::Util::Log.newdestination(:console)
  # it { pp catalogue.resources }
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      case facts[:operatingsystem]
      when 'FreeBSD'
        let(:package) { 'zabbix34-agent' }
        let(:service) { 'zabbix_agentd' }
        let(:config_file) { '/usr/local/etc/zabbix34/zabbix_agentd.conf' }
        let(:group) { 'wheel' }
        let(:pid_file) { '/tmp/zabbix_agentd.pid' }
        let(:log_file) { '/tmp/zabbix_agentd.log' }
        let(:include_dir) { '/usr/local/etc/zabbix34/zabbix_agentd.conf.d/' }
      else
        let(:package) { 'zabbix-agent' }
        let(:service) { 'zabbix-agent' }
        let(:config_file) { '/etc/zabbix/zabbix_agentd.conf' }
        let(:group) { 'root' }
        let(:pid_file) { '/var/run/zabbix/zabbix_agentd.pid' }
        let(:log_file) { '/var/log/zabbix/zabbix_agentd.log' }
        let(:include_dir) { '/etc/zabbix/zabbix_agentd.d/' }
      end
      describe 'check default config' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_package(package) }
        it do
          is_expected.to contain_service(service).with(
            ensure: 'running',
            enable: true
          )
        end
        it do
          is_expected.to contain_file(config_file).with(
            ensure: 'file',
            mode: '0644',
            owner: 'root',
            group: group
          ).with_content(
            %r{^Server=127.0.0.1$}
          ).with_content(
            %r{^Hostname=zabbix_agent.example.com$}
          ).with_content(
            %r{^StartAgents=5$}
          ).with_content(
            %r{^DebugLevel=3$}
          ).with_content(
            %r{^PidFile=#{pid_file}$}
          ).with_content(
            %r{^LogFile=#{log_file}$}
          ).with_content(
            %r{^Timeout=3$}
          ).with_content(
            %r{^Include=#{include_dir}$}
          )
        end
        it do
          is_expected.to contain_file(include_dir).with(
            ensure: 'directory',
            owner: 'root',
            group: group
          )
        end
      end
      describe 'Change Defaults' do
        context 'servers' do
          before { params.merge!(servers: ['192.0.2.1', '192.0.2.3']) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(config_file).with_content(
              %r{^Server=192.0.2.1, 192.0.2.3$}
            )
          end
        end
        context 'start_agents' do
          before { params.merge!(start_agents: 42) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(config_file).with_content(
              %r{^StartAgents=42$}
            )
          end
        end
        context 'agent_debug_level' do
          before { params.merge!(agent_debug_level: 5) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(config_file).with_content(
              %r{^DebugLevel=5$}
            )
          end
        end
        context 'agent_timeout' do
          before { params.merge!(agent_timeout: 30) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(config_file).with_content(
              %r{^Timeout=30$}
            )
          end
        end
        context 'package' do
          before { params.merge!(package: 'foobar') }
          it { is_expected.to compile }
          it { is_expected.to contain_package('foobar') }
        end
        context 'service' do
          before { params.merge!(service: 'foobar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_service('foobar').with(
              ensure: 'running',
              enable: true
            )
          end
        end
        context 'config_file' do
          before { params.merge!(config_file: '/foo/bar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file('/foo/bar').with_group(group).with_content(
              %r{^Server=127.0.0.1$}
            ).with_content(
              %r{^Hostname=zabbix_agent.example.com$}
            ).with_content(
              %r{^ListenPort=10050$}
            ).with_content(
              %r{^StartAgents=5$}
            ).with_content(
              %r{^DebugLevel=3$}
            ).with_content(
              %r{^PidFile=#{pid_file}$}
            ).with_content(
              %r{^LogFile=#{log_file}$}
            ).with_content(
              %r{^Timeout=3$}
            ).with_content(
              %r{^Include=#{include_dir}$}
            )
          end
        end
        context 'mode' do
          before { params.merge!(mode: '0600') }
          it { is_expected.to compile }
          it { is_expected.to contain_file(config_file).with_mode('0600') }
        end
        context 'owner' do
          before { params.merge!(owner: 'foobar') }
          it { is_expected.to compile }
          it { is_expected.to contain_file(config_file).with_owner('foobar') }
        end
        context 'group' do
          before { params.merge!(group: 'foobar') }
          it { is_expected.to compile }
          it { is_expected.to contain_file(config_file).with_group('foobar') }
        end
        context 'pid_file' do
          before { params.merge!(pid_file: '/foo/bar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(config_file).with_content(
              %r{^PidFile=/foo/bar$}
            )
          end
        end
        context 'log_file' do
          before { params.merge!(log_file: '/foo/bar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(config_file).with_content(
              %r{^LogFile=/foo/bar$}
            )
          end
        end
        context 'port' do
          before { params.merge!(port: 42) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(config_file).with_content(
              %r{^ListenPort=42$}
            )
          end
        end
        context 'include_dir' do
          before { params.merge!(include_dir: '/foo/bar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(config_file).with_content(
              %r{^Include=/foo/bar$}
            )
          end
        end
      end
      describe 'check bad type' do
        context 'servers' do
          before { params.merge!(servers: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'start_agents' do
          before { params.merge!(start_agents: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'agent_debug_level' do
          before { params.merge!(agent_debug_level: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'agent_timeout' do
          before { params.merge!(agent_timeout: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'package' do
          before { params.merge!(package: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'service' do
          before { params.merge!(service: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'template' do
          before { params.merge!(template: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'config_file' do
          before { params.merge!(config_file: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'mode' do
          before { params.merge!(mode: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'owner' do
          before { params.merge!(owner: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'group' do
          before { params.merge!(group: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'pid_file' do
          before { params.merge!(pid_file: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'log_file' do
          before { params.merge!(log_file: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'port' do
          before { params.merge!(port: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'include_dir' do
          before { params.merge!(include_dir: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
      end
    end
  end
end
