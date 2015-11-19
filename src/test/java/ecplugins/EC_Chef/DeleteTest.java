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
import static org.junit.Assert.fail;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;
import org.junit.BeforeClass;
import org.junit.Test;

public class DeleteTest {
    @BeforeClass
    public static void setUpBeforeClass() throws Exception {
        ConfigurationsParser.configurationParser();
        System.out.println("Inside DeleteTest");
    }

    @Test
    public void test() throws Exception {
        long jobTimeoutMillis = 5 * 60 * 1000;
        JSONObject jsonObject = new JSONObject();
        String output = " ";
        String object_name = " ";
        jsonObject.put("projectName", "EC-Chef-"
                + StringConstants.PLUGIN_VERSION);

        for (Map.Entry<String, HashMap<String, HashMap<String, String>>> objectCursor : ConfigurationsParser.actions
                .get("Delete").entrySet()) {
            if (objectCursor.getKey().equals(StringConstants.NODE)) {
                jsonObject.put("procedureName", StringConstants.DELETE
                        + StringConstants.SINGLE
                        + objectCursor.getKey().replaceAll("\\s+", ""));
            } else {
                jsonObject.put("procedureName", StringConstants.DELETE
                        + objectCursor.getKey().replaceAll("\\s+", ""));
            }
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

                        // Create the object since we want to test its delete
                        // procedure
                        KnifeUtils.runCommand(StringConstants.KNIFE + " "
                                + objectCursor.getKey().toLowerCase() + " "
                                + StringConstants.CREATE.toLowerCase() + " "
                                + object_name + " -d");
                        System.out.println("Created Dummy object: "
                                + object_name);
                    } else if (propertyCursor != null
                            && !propertyCursor.getValue().isEmpty()) {
                        actualParameterArray
                            .put(new JSONObject().put("value",
                                        propertyCursor.getValue()).put(
                                        "actualParameterName",
                                        propertyCursor.getKey()));
                            }
                        }
                jsonObject.put("actualParameter", actualParameterArray);
                String jobId = TestUtils.callRunProcedure(jsonObject);
                String response = TestUtils.waitForJob(jobId, jobTimeoutMillis);
                // Check job status
                assertEquals("Job completed with errors", "success", response);
                // This is for verification
                ;
                output = KnifeUtils.runCommand(StringConstants.KNIFE + " "
                        + objectCursor.getKey().toLowerCase() + " "
                        + StringConstants.LIST.toLowerCase());
                String result = TestUtils.getSubstring(output, ".*("
                        + object_name + ").*");
                System.out.println("Verification Command Output:" + result);
                if (result != null && (result.equals(object_name))) {
                    System.out.println("JobId:" + jobId
                            + ", Test Failed. After delete also object "
                            + "is present(Validated using list command): "
                            + object_name);
                    fail("Test Failed. After delete also object is present(Validated using list command).");
                }
                // If delete job failed to delete, do it manually here
                System.out.println("JobId:" + jobId
                        + ", Completed Delete Unit Test Successfully for "
                        + object_name);
                    }
                }
    }
}
