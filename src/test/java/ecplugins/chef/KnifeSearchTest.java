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

import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;
import org.junit.BeforeClass;
import org.junit.Test;

public class KnifeSearchTest {

    @BeforeClass
    public static void setUpBeforeClass() throws Exception {
        // configurations is a HashMap having primary key as object type(client,
        // node, data bag)
        // and secondary key as property name
        ConfigurationsParser.configurationParser();
        System.out.println("Inside KnifeSearch Unit Test");
    }

    @Test
    public void test() throws Exception {
        JSONObject jsonObject = new JSONObject();

        jsonObject.put("projectName", "EC-Chef-"
                + StringConstants.PLUGIN_VERSION);
        if( !ConfigurationsParser.actions.containsKey("KnifeSearch") )
        {
            System.out.println("Configurations not present for the test");
            return;
        }
        jsonObject.put("procedureName", "KnifeSearch");

        // Every run will be new job
        JSONArray actualParameterArray = new JSONArray();
        String name = "";
        for (Map.Entry<String, HashMap<String, HashMap<String, String>>> objectCursor : ConfigurationsParser.actions
                .get("KnifeSearch").entrySet()) {

            for (Map.Entry<String, HashMap<String, String>> runCursor : objectCursor
                    .getValue().entrySet()) {

                for (Map.Entry<String, String> propertyCursor : runCursor
                        .getValue().entrySet()) {
                    // Get each Run's data and iterate over it to populate
                    // parameter array

                    if (propertyCursor != null
                            && !propertyCursor.getValue().isEmpty()) {
                        if (propertyCursor.getKey().equals(StringConstants.QUERY)) {
                            name = propertyCursor.getValue().replace("$$NAME$$", "ec-chef-plugin-test-node" + Integer.toString(TestUtils.randInt()));
                            actualParameterArray.put(new JSONObject().put(
                                        "value", name).put("actualParameterName",
                                            propertyCursor.getKey()));

                        }
                        else {
                            actualParameterArray.put(new JSONObject().put(
                                        "value", propertyCursor.getValue()).put("actualParameterName",
                                        propertyCursor.getKey()));

                        }
                            }
                        }
                    }
                }
        jsonObject.put("actualParameter", actualParameterArray);
        KnifeUtils.runCommand(StringConstants.KNIFE + " "
                + StringConstants.NODE.toLowerCase() + " "
                + StringConstants.CREATE.toLowerCase() + " " + name
                + " -d");

        String jobId = TestUtils.callRunProcedure(jsonObject);
        String response = TestUtils.waitForJob(jobId,
                StringConstants.jobTimeoutMillis);
        // Check job status
        assertEquals("Job completed with errors", "success",
                response);
        // This is for verification

        KnifeUtils.runCommand(StringConstants.KNIFE + " "
                + StringConstants.NODE.toLowerCase() + " "
                + StringConstants.DELETE.toLowerCase() + " " + name
                + " -y");

        // If delete job failed to delete, do it manually here
        System.out.println("JobId:" + jobId
                + ", Completed Knife Search Unit Test Successfully for "
                + name);

    }

}
