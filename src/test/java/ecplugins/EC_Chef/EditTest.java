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

package ecplugins.EC_Chef;
import static org.junit.Assert.assertEquals;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;
import org.junit.BeforeClass;
import org.junit.Test;


public class EditTest {
    @BeforeClass
    public static void setUpBeforeClass() throws Exception {
        ConfigurationsParser.configurationParser();
        System.out.println("Inside EditTest");
    }

    @Test
    public void test() throws Exception {
        long jobTimeoutMillis = 5 * 60 * 1000;
        JSONObject jsonObject = new JSONObject();
        String object_name = " ";
        String object_data_key = "";
        String object_data_value = "";
        jsonObject.put("projectName", "EC-Chef-"
                + StringConstants.PLUGIN_VERSION);

        for (Map.Entry<String, HashMap<String, HashMap<String, String>>> objectCursor : ConfigurationsParser.actions
                .get("Edit").entrySet()) {
            jsonObject.put("procedureName", StringConstants.EDIT
                    + objectCursor.getKey().replaceAll("\\s+", ""));
            for (Map.Entry<String, HashMap<String, String>> runCursor : objectCursor
                    .getValue().entrySet()) {
                // Every run will be new job
                JSONArray actualParameterArray = new JSONArray();
                for (Map.Entry<String, String> propertyCursor : runCursor
                        .getValue().entrySet()) {
                    // Get each Run's data and iterate over it to populate
                    // parameter array
                    if (propertyCursor != null
                            && propertyCursor.getKey().equals(
                                objectCursor.getKey()
                                .replaceAll("\\s+", "")
                                .toLowerCase()
                                + "_name")) {
                        object_name = propertyCursor.getValue()
                            + Integer.toString(TestUtils.randInt());
                        actualParameterArray.put(new JSONObject().put("value",
                                    object_name).put("actualParameterName",
                                        propertyCursor.getKey()));

                        // Create the object since we want to test its edit
                        // procedure
                        KnifeUtils.runCommand(StringConstants.KNIFE + " "
                                + objectCursor.getKey().toLowerCase() + " "
                                + StringConstants.CREATE.toLowerCase() + " "
                                + object_name + " -d");
                        System.out.println("Created Dummy object: "
                                + object_name);
                    } else if (propertyCursor != null
                            && !propertyCursor.getValue().isEmpty()) {
                        if (propertyCursor.getValue().contains("$$OBJECT-NAME$$"))
                        {
                            object_data_key = propertyCursor.getKey();
                            object_data_value = propertyCursor.getValue();
                            continue;
                        }
                        actualParameterArray
                            .put(new JSONObject().put("value",
                                        propertyCursor.getValue()).put(
                                        "actualParameterName",
                                        propertyCursor.getKey()));
                            }
                        }
                if (!object_data_key.isEmpty())
                {
                    actualParameterArray
                        .put(new JSONObject().put("value",
                                    object_data_value.replace("$$OBJECT-NAME$$", object_name)).put(
                                    "actualParameterName",
                                    object_data_key));
                }
                jsonObject.put("actualParameter", actualParameterArray);
                String jobId = TestUtils.callRunProcedure(jsonObject);
                String response = TestUtils.waitForJob(jobId, jobTimeoutMillis);
                // Check job status
                assertEquals("Job completed with errors", "success", response);

                // Delete the object since we do not want to leave any residue
                KnifeUtils.runCommand(StringConstants.KNIFE + " "
                        + objectCursor.getKey().toLowerCase() + " "
                        + StringConstants.DELETE.toLowerCase() + " "
                        + object_name + " -y");

                System.out.println("JobId:" + jobId
                        + ", Completed Edit Unit Test Successfully for "
                        + objectCursor.getKey());
                    }
                }
    }
}
