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
import java.util.Properties;
import org.junit.AfterClass;
import org.json.JSONArray;
import org.json.JSONObject;
import org.junit.BeforeClass;
import org.junit.Test;

public class DeleteTest {

	// private static HashMap<String, HashMap<String, HashMap<String, String>>>
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
		System.out.println("Inside DeleteObjects Unit Test");
	}

	@Test
	public void test() throws Exception {
		// Only for testing
		// This HashMap will be populated by reading configurations.json file
		// ConfigurationsParser.configurationParser();

		JSONObject jsonObject = new JSONObject();

		jsonObject.put("projectName", "EC-Chef-"
				+ StringConstants.PLUGIN_VERSION);
        if( !ConfigurationsParser.actions.containsKey("Delete") )
        {
            System.out.println("Configurations not present for the test");
            return;
        }
		for (Map.Entry<String, HashMap<String, HashMap<String, String>>> objectCursor : ConfigurationsParser.actions
				.get("Delete").entrySet()) {
			String objectName = "";
			String testClientName = "";
			String testCookbookPath = "";
			String testCookbook = "";

			if (objectCursor.getKey().equals(StringConstants.NODE)) {
				jsonObject.put("procedureName", StringConstants.DELETE
						+ StringConstants.SINGLE
						+ objectCursor.getKey().replaceAll("\\s+", ""));
			} else {

				jsonObject.put("procedureName", StringConstants.DELETE
						+ objectCursor.getKey().replaceAll("\\s+", ""));

				if (objectCursor.getKey().equals(StringConstants.CLIENT_KEY)) {
					testClientName = "client"
							+ Integer.toString(TestUtils.randInt());
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
								&& propertyCursor.getKey().endsWith("_name")) {
							if (objectCursor.getKey().equalsIgnoreCase(
									StringConstants.CLIENT_KEY)
									&& propertyCursor.getKey().contains(
											StringConstants.CLIENT
													.toLowerCase())) {

								actualParameterArray.put(new JSONObject().put(
										"value", testClientName).put(
										"actualParameterName",
										propertyCursor.getKey()));

							} else {
								objectName = propertyCursor.getValue()
										+ Integer.toString(TestUtils.randInt());
								System.out.println("ObjectName:" + objectName);
								actualParameterArray.put(new JSONObject().put(
										"value", objectName).put(
										"actualParameterName",
										propertyCursor.getKey()));

							}
						} else if (propertyCursor != null
								&& !propertyCursor.getValue().isEmpty()) {
							if (propertyCursor.getKey().equals(
									StringConstants.COOKBOOK_PATH)
									&& objectCursor.getKey().equals(
											StringConstants.COOKBOOK)) {
								testCookbookPath = propertyCursor.getValue();
							} else {
								actualParameterArray.put(new JSONObject().put(
										"value", propertyCursor.getValue())
										.put("actualParameterName",
												propertyCursor.getKey()));
							}
						}
					}
         
					jsonObject.put("actualParameter", actualParameterArray);

					TestUtils.createTemporaryObjects(testClientName,
							testCookbookPath, objectName, objectCursor.getKey());
					String jobId = TestUtils.callRunProcedure(jsonObject);
					String response = TestUtils.waitForJob(jobId,
							StringConstants.jobTimeoutMillis);
					// Check job status
					assertEquals("Job completed with errors", "success",
							response);
					// This is for verification

					TestUtils.validation(objectCursor.getKey().toLowerCase(),
							testClientName, objectName, jobId,
							StringConstants.DELETE);
					
					if(objectCursor.getKey().equals(StringConstants.COOKBOOK))
	                	testCookbook = Paths.get(testCookbookPath,
								objectName).toString();
					
					TestUtils.deleteTemporaryObjects(testClientName,testCookbook);
				

					// If delete job failed to delete, do it manually here
					System.out.println("JobId:" + jobId
							+ ", Completed Delete Unit Test Successfully for "
							+ objectName);
					

				}
			}
		}
	}

}
