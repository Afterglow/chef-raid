#
# Cookbook Name:: raid
# Recipe:: default
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
# This recipe only contains examples. I thought it unwise to have a default.rb
# that cleared peoples RAID configurations out the box. You have to implicitly
# include the raid::manage recipe before the attributes set on your node will
# be applied. It is worth noting the configuration is cleared and rewritten on every
# run, therefore you probably don't want this in your default run list. I use it from
# solo for a single shot configuration on a new server.
#

#
## Some examples
#
## Clear the configuration
#raid_controller "0" do
#  action :clear
#  provider "raid_megaraid"
#end

## Delete a logical drive
#raid_controller "0" do
#  ld "0"
#  action :delete
#  provider "raid_megaraid"
#end

## Create a logical drive
#raid_controller "0" do
#  level "0"
#  pds ["6:0","6:1"]
#  action :createld
#  provider "raid_megaraid"
#end

## Create a logical span
#raid_controller "0" do
#  level "10"
#  pds [["6:0","6:1"],["6:2","6:3"]]
#  action :createspan
#  provider "raid_megaraid"
#end
