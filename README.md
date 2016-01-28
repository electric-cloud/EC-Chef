EC-Chef
============

The ElectricFlow Chef integration

####Prerequisite installation:####
    0.Install Electric Flow Agent
      --Failure /lib/ld-linux.so.2: bad ELF interpreter: No such file or directory
        sudo apt-get install lib32bz2-1.0
    1.jdk
    2.chefdk
    3.knife-spec
    4.knife/workstation setup

#####Example(Tested on Ubuntu 14.04):####
0. sudo apt-get update && sudo apt-get upgrade
1. sudo apt-get install openjdk-7-jdk
2. https://www.linode.com/docs/applications/chef/setting-up-chef-ubuntu-14-04
   (a) wget https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.5.1-1_amd64.deb
   (b) sudo dpkg -i chefdk_0.5.1-1_amd64.deb
   (c) rm chefdk_0.5.1-1_amd64.deb
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
   sudo gem install knife-spec[This will take time]
6. http://zanshin.net/2014/03/04/how-i-setup-my-chef-workstation/
   A knife.rb file is used to specify the chef-repo-specific configuration details for knife.
   knife searches for .chef in:
   (a) ./.chef (current directory contains .chef)
   (b) ~/.chef (homedir contains .chef)
   (c) parent directories (e.g. ./.. then ./../.. all the way back to /)

   Put knife.rb,validator.pem,client.pem in one of the above directories.
   In hosted chef:
   https://docs.chef.io/server_manage_clients.html
   Download starter kit and it has .chef directory which should be copied to the desired location.

## Compile And Upload ##
0. Install git
   sudo apt-get install git
1. Get this plugin
   git clone https://github.com/electric-cloud/EC-Chef.git
2. Run gradlew to compile the plugin
   ./gradlew jar (in EC-Chef directory)
3. Upload the plugin to EC server

####Required files:####
    1. Create a file called ecplugin.properties inside EC-Chef directory with the below mentioned contents.
       EC_AGENT_IP is the machine on which we have installed chef libraries and Electric Flow Agent above.
    2. Edit Configurations.json file.

####Contents of ecplugin.properties:####
    COMMANDER_SERVER=<COMMANDER_SERVER>
    COMMANDER_USER=<COMMANDER_USER>
    COMMANDER_PASSWORD=<COMMANDER_PASSWORD>
    EC_AGENT_IP=<EC_AGENT_IP>

####Contents of Configurations.json:####
    1. Configurations.json is a configurable file.
    2. Refer to the sample Configurations.json file. It has to be updated with the user environment specific arguments.
    3. In this nested JSON file, outer two tags make procedure name and innermost  tags are the arguments for the procedures.
    4. Outermost json object represents actions which can be **{Create,Delete,Edit,List,Show}.**
    5. The json object inside the outermost layer can be the set to following **{Node,Role,Client,Client Key,Data Bag}.** 
    6. For Bootstrap test both, inner and the outer objects should be named **"Bootstrap".**

####Run the tests:#####
`./gradlew test`

## Licensing ##
EC-Chef is licensed under the Apache License, Version 2.0. See [LICENSE](https://github.com/electric-cloud/EC-Chef/blob/master/LICENSE) for the full license text.
