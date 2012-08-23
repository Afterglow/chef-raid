#
# Cookbook Name:: raid
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
raid_logicaldrive "sometest" do
  controller "0"
  action :clear
  provider "raid_megaraid"
end

#raid_raid "deletetest" do
#  controller "0"
#  ld "0"
#  action :delete
#  provider "raid_megaraid"
#end

#raid_raid "createtest" do
#  controller "0"
#  level "0"
#  pds ["6:0","6:1"]
#  action :createld
#  provider "raid_megaraid"
#end

raid_logicaldrive "raid10" do
  controller "0"
  level "10"
  pds [["6:0","6:1"],["6:2","6:3"]]
  action :createspan
  provider "raid_megaraid"
end
