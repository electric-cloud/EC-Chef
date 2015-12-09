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

import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;
import org.junit.BeforeClass;
import org.junit.Test;

public class CreateTest {

	// configurations;
	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
		// configurations is a HashMap having primary key as object type(client,
		// node, data bag)
		// and secondary key as property name
		ConfigurationsParser.configurationParser();
		System.out.println("Inside CreateObjects Unit Test");
	}

	@Test
	public void test() throws Exception {
		// Only for testing
		// This HashMap will be populated by reading configurations.json file

		JSONObject jsonObject = new JSONObject();

		jsonObject.put("projectName", "EC-Chef-"
				+ StringConstants.PLUGIN_VERSION);
        if( !ConfigurationsParser.actions.containsKey("Create") )
        {
            System.out.println("Configurations not present for the test");
            return;
        }
		for (Map.Entry<String, HashMap<String, HashMap<String, String>>> objectCursor : ConfigurationsParser.actions
				.get("Create").entrySet()) {
			String objectName = "";
			String testClientName = "";
			String testCookbookPath = "";
			String testCookbook = "";

			jsonObject.put("procedureName", StringConstants.CREATE
					+ objectCursor.getKey().replaceAll("\\s+", ""));

			if (objectCursor.getKey().equals(StringConstants.CLIENT_KEY)) {
				testClientName = "client"
						+ Integer.toString(TestUtils.randInt());
			}

			for (Map.Entry<String, HashMap<String, String>> runCursor : objectCursor
					.getValue().entrySet()) {

				// Every run will be a new job
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
										StringConstants.CLIENT.toLowerCase())) {

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

						}
						actualParameterArray
								.put(new JSONObject().put("value",
										propertyCursor.getValue()).put(
										"actualParameterName",
										propertyCursor.getKey()));
					}
				}

				jsonObject.put("actualParameter", actualParameterArray);

				TestUtils.createTemporaryObjects(testClientName,
						testCookbookPath, objectName, objectCursor.getKey(),
						true);
				String jobId = TestUtils.callRunProcedure(jsonObject);
				String response = TestUtils.waitForJob(jobId,
						StringConstants.jobTimeoutMillis);

				// Check job status
				assertEquals("Job completed with errors", "success", response);

				// verification of output
				TestUtils.validation(objectCursor.getKey().toLowerCase(),
						testClientName, objectName, jobId,
						StringConstants.CREATE);

				if (objectCursor.getKey().equals(StringConstants.COOKBOOK))
					testCookbook = Paths.get(testCookbookPath, objectName)
							.toString();

				TestUtils.deleteTemporaryObjects(testClientName, objectName,
						objectCursor.getKey().toLowerCase(), testCookbook);

				System.out.println("JobId:" + jobId
						+ ", Completed Create Unit Test Successfully for "
						+ objectName);
			}
		}
	}
}
