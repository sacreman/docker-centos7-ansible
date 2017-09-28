#Operating System Check
describe os[:family] do
  it { should eq 'redhat' }
end
describe service('dbus') do
  it { should be_enabled }
  it { should be_running }
end
describe service('systemd-journald') do
  it { should be_enabled }
  it { should be_running }
end
describe service('systemd-logind') do
  it { should be_enabled }
end
describe service('systemd-udevd') do
  it { should be_enabled }
end
describe mount('/') do
  it { should be_mounted }
end
describe file('/etc/ansible/ansible.cfg') do
  it { should exist }
end