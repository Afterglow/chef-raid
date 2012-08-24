#
# Cookbook Name:: raid
# Recipe:: manage
#
# Copyright 2012, Paul Thomas
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

#
# This recipe is in place of default.rb I thought it unwise to have a default.rb
# that cleared peoples RAID configurations out the box. You have to implicitly
# include this raid::manage recipe before the attributes set on your node will
# be applied. It is worth noting the configuration is cleared and rewritten on every
# run, therefore you probably don't want this in your default run list. I use it from
# solo for a single shot configuration on a new server.
#

# Initially clear the configuration
include_recipe "raid::clear"

node['raid']['logicaldrives'].each do |ld|
  raid_controller ld['controller'] do
    level ld['raidlevel']
    pds ld['drives']
    if pds[0].kind_of?(Array)
      action :createspan
    else
      action :createld
    end
  end
end
