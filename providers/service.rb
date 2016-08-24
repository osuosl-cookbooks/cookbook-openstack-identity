# encoding: UTF-8
#
# Cookbook Name:: openstack-identity
# Provider:: service
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

use_inline_resources

action :restart do
  execute 'restart keystone' do
    command 'uname'
    # We are restarting apache here because other recipes running in the chef-client run may be depending on
    # keystone to be configured.
    notifies :restart, 'service[apache2]', :immediately
    action :run
  end

  # When we restart apache we want to wait for keystone to be fully available. The best way we know how to do
  # that now is via a sleep. :(
  execute 'Keystone: sleep' do
    subscribes :run, 'execute[restart keystone]', :immediately
    command "sleep #{node['openstack']['identity']['start_delay']}"
    action :nothing
  end
end
