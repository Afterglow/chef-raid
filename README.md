Description
===========
Configures a RAID controller, currently the only provider is for megaraid
Requirements
============
Requires MegaCli to be installed
Attributes
==========
      "raid": {
        "provider": "raid_megaraid",
        "logicaldrives": [
          { "controller": 0, "raidlevel": 10, "drives": [["6:0","6:1"],["6:2","6:3"]] }
        ]
      }
Usage
=====
There are some examples in `recipes/default.rb` of what can be done to clear controllers or create/delete logical drives and spans. Either use those examples to make your own or use the provided recipes such as `raid::clear` in conjunction with correctly set node attributes to configure the controller.
