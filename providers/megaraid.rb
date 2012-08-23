#     "volumes": {
#        "0": {
#          "physical_disks": {
#            "0": {
#              "Enclosure Device ID": "6",
#              "Slot Number": "0",
#              "Drive's postion": "DiskGroup",
#              "Enclosure position": "1",
#              "Device Id": "0",

def pdsavailable(pdlist)
  pdlist.each do |pd|
    parts = pd.split(':')
    if node.has_key? "raid_controllers"
      if node["raid_controllers"].has_key? new_resource.controller
        if node["raid_controllers"][new_resource.controller].has_key? "physical_disks"
          unless defined? node["raid_controllers"][new_resource.controller]['physical_disks'][parts[0]][parts[1]]
            Chef::Log::debug("Disk on controller #{new_resource.controller} address #{parts[0]}:#{parts[1]} did not exist")
            return false
          end
        else
          Chef::Log::debug('physical disks NOT exists')
        end
        if node["raid_controllers"][new_resource.controller].has_key? "volumes"
          node["raid_controllers"][new_resource.controller]["volumes"].each_pair do |id,volume|
            volume['physical_disks'].each_pair do |diskid,disk|
              if disk['Enclosure Device ID'] == parts[0] && disk['Slot Number'] == parts[1]
                Chef::Log::debug("disk #{parts[0]}:#{parts[1]} already in use by Volume#{id}")
                return false
              end
            end
          end
        end
      end
    end
  end
  return true
end

action :createld do
  pds = new_resource.pds.join(',')
  if pdsavailable(new_resource.pds)
    execute "create ld" do
      command "/opt/MegaRAID/MegaCli/MegaCli64 CfgLDAdd R#{new_resource.level} \\[#{pds}\\] -a#{new_resource.controller}"
    end
  else
    Chef::Log::warn("Skipped creation of RAID as disks not available (already configured?)")
  end
end

#-CfgSpanAdd -R10 -Array0 \[6:0,6:1,6:2\] -Array1 \[6:3,6:4,6:5\] WB RA -strpsz64 -a0
action :createspan do
  avoilable = true
  new_resource.pds.each_pair do |id, pds|
    unless pdsavailable(pds)
      Chef::Log::warn("Skipping creation of span due to physical disk already in use (already configured?)")
      available = false
    end
  end

  if available
    arraystring = ""
    new_resource.pds.each_pair do |id, pds|
      pdlist = pds
      arraystring = "#{arraystring} -Array#{id} \\[#{pds}\\] "
    end
    command "/opt/MegaRAID/MegaCLI/MegaCli64 -R#{new_resource.level} #{arraystring}WB RA -strpsz64 -a#{new_resource.controller}"
  end
end

action :delete do
  execute "delete ld" do
    not_if "/opt/MegaRAID/MegaCli/MegaCli64 LDInfo L#{new_resource.ld} a#{new_resource.controller} | grep -q 'Does not Exist'"
    command "/opt/MegaRAID/MegaCli/MegaCli64 CfgLDDel L#{new_resource.ld} a#{new_resource.controller}"
  end
end

action :clear do
  execute "clear controller" do
    command "/opt/MegaRAID/MegaCli/MegaCli64 CfgClr a#{new_resource.controller}"
  end
end
