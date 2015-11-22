EC-Chef
============

The ElectricFlow Chef integration

## Compile ##

Run gradlew to compile the plugin

`./gradlew`

## Tests ##
[TBD]
Prerequisite installation:
1.chefdk
2.jdk > 1.6

Required files:
ecplugin.properties
Configurations.json

set "commanderServer" environment variable to the commander server url.

Making configurations.json:
1.Refer to the sample configurations.json file.
2.Outermost json object represents actions which can be {Create,Delete,Edit,List,Show}
3.The the json object inside the outermost layer can be the following set  {Node,Role,Client,Client Key,Data Bag} 
4.For Bootstrap test both the objects should be named "Bootstrap".
 

## Licensing ##
EC-Chef is licensed under the Apache License, Version 2.0. See [LICENSE](https://github.com/electric-cloud/EC-Chef/blob/master/LICENSE) for the full license text.
