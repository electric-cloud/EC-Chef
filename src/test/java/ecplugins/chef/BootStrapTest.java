/*
   Copyright 2015 Electric Cloud, Inc.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package ecplugins.chef;

import static org.junit.Assert.assertEquals;
import java.util.Properties;
import org.junit.AfterClass;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;
import org.junit.BeforeClass;
import org.junit.Test;

public class BootStrapTest {

    // configurations;
    @BeforeClass
    public static void setUpBeforeClass() throws Exception {
        // configurations is a HashMap having primary key as object type(client,
        // node, data bag)
        // and secondary key as property name
        ConfigurationsParser.configurationParser();
        Properties props = TestUtils.getProperties();
        TestUtils.createCommanderWorkspace(StringConstants.WORKSPACE_NAME);
        TestUtils.createCommanderResource(StringConstants.RESOURCE_NAME,
                StringConstants.WORKSPACE_NAME, props.getProperty(StringConstants.EC_AGENT_IP));
        TestUtils.setResourceAndWorkspace(StringConstants.RESOURCE_NAME,
                StringConstants.WORKSPACE_NAME);
        System.out.println("Inside Bootstrap Unit Test");
    }

    @Test
    public void test() throws Exception {
        JSONObject jsonObject = new JSONObject();
        String objectName = "", userName = "", password = "";
        jsonObject.put("projectName", "EC-Chef-"
                + StringConstants.PLUGIN_VERSION);
        if( !ConfigurationsParser.actions.containsKey("Bootstrap") )
        {
            System.out.println("Configurations not present for the test");
            return;
        }
        for (Map.Entry<String, HashMap<String, HashMap<String, String>>> objectCursor : ConfigurationsParser.actions
                .get("Bootstrap").entrySet()) {
            jsonObject.put("procedureName", StringConstants.BOOTSTRAP);
            for (Map.Entry<String, HashMap<String, String>> runCursor : objectCursor
                    .getValue().entrySet()) {
                // Every run will be new job
                JSONArray actualParameterArray = new JSONArray();
                for (Map.Entry<String, String> propertyCursor : runCursor
                        .getValue().entrySet()) {
                    // Get each Run's data and iterate over it to populate
                    // parameter array
                    if (propertyCursor != null
                            && !propertyCursor.getValue().isEmpty()) {

                        if (propertyCursor.getKey().equals("node_name"))
                        {
                            objectName = propertyCursor.getValue();
                        }
                        else if (propertyCursor.getKey().equals("username"))
                        {
                            userName = propertyCursor.getValue();
                            continue;
                        }
                        else if (propertyCursor.getKey().equals("password"))
                        {
                            password = propertyCursor.getValue();
                            continue;
                        }

                        actualParameterArray
                            .put(new JSONObject().put("value",
                                        propertyCursor.getValue()).put(
                                        "actualParameterName",
                                        propertyCursor.getKey()));
                            }
                        }
                actualParameterArray.put(new JSONObject()
                        .put("actualParameterName", "ssh_credential")
                        .put("value","ssh_credential"));

                JSONArray credentialArray = new JSONArray();
                credentialArray.put(new JSONObject()
                        .put("credentialName", "ssh_credential")
                        .put("userName", userName)
                        .put("password", password));

                jsonObject.put("actualParameter", actualParameterArray);
                jsonObject.put("credential", credentialArray);
                String jobId = TestUtils.callRunProcedure(jsonObject);
                String response = TestUtils.waitForJob(jobId, StringConstants.jobTimeoutMillis);
                // Check job status
                assertEquals("Job completed with errors", "success", response);
                // This is for verification
                TestUtils.validation(StringConstants.NODE.toLowerCase(), "", objectName, jobId, StringConstants.BOOTSTRAP);

                System.out.println("Cleaning temorary items");
                // Delete the object since we do not want to leave any residue
                // Bootstrap procedure creates a client and a node.Delete both.
                KnifeUtils.runCommand(StringConstants.KNIFE + " " + "node"
                        + " " + StringConstants.DELETE.toLowerCase() + " "
                        + objectName + " -y");
                KnifeUtils.runCommand(StringConstants.KNIFE + " " + "client"
                        + " " + StringConstants.DELETE.toLowerCase() + " "
                        + objectName + " -y");
                System.out.println("JobId:" + jobId
                        + ", Completed Bootstrap Unit Test Successfully");
                    }
                }
    }
}
