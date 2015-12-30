EC-Chef
============

The ElectricFlow Chef integration

####Prerequisite installation:####
    1.jdk
    2.chefdk
    3.knife-spec
    4.knife/workstation setup

Example(Tested on Ubuntu 14.04):
0. sudo apt-get update && sudo apt-get upgrade
1. sudo apt-get install openjdk-7-jdk
2. https://www.linode.com/docs/applications/chef/setting-up-chef-ubuntu-14-04
   (a) wget https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.5.1-1_amd64.deb
   (b) sudo dpkg -i chefdk_*.deb
   (c) rm chefdk_*.deb
4. Install ruby (version > 2.0.0)
   sudo apt-get -y install build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev
   cd /tmp
   wget http://cache.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p481.tar.gz
   tar -xvzf ruby-2.0.0-p481.tar.gz
   cd ruby-2.0.0-p481/
   ./configure --prefix=/usr/local
   make
   sudo make install
5. https://github.com/sethvargo/knife-spec
   sudo apt-get install ruby-dev
   sudo gem install knife-spec
6. http://zanshin.net/2014/03/04/how-i-setup-my-chef-workstation/
   A knife.rb file is used to specify the chef-repo-specific configuration details for knife.
   Put knife.rb,validator.pem,client.pem in etc/chef directory.

## Compile ##

Run gradlew to compile the plugin without running test

`./gradlew build -x test`

Upload the plugin to EC server
####Required files:####
    ecplugin.properties
    Configurations.json

####Contents of Configurations.json:####
    1. Configurations.json is a configurable file.
    2. Refer to the sample Configurations.json file. It has to be updated with the user environment specific arguments.
    3. In this nested JSON file, outer two tags make procedure name and innermost  tags are the arguments for the procedures.
    4. Outermost json object represents actions which can be **{Create,Delete,Edit,List,Show}.**
    5. The json object inside the outermost layer can be the set to following **{Node,Role,Client,Client Key,Data Bag}.** 
    6. For Bootstrap test both, inner and the outer objects should be named **"Bootstrap".**


####Contents of ecplugin.properties:####

    COMMANDER_USER=<COMMANDER_USER>
    COMMANDER_PASSWORD=<COMMANDER_PASSWORD>


####Environment variable:####
    $commanderServer=<COMMANDER_SERVER>
    Example:
    export $commanderServer=<COMMANDER_SERVER>

####Run the tests:#####
`./gradlew test`

## Licensing ##
EC-Chef is licensed under the Apache License, Version 2.0. See [LICENSE](https://github.com/electric-cloud/EC-Chef/blob/master/LICENSE) for the full license text.
