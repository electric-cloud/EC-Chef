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

public class BerksTest {
	String objectName = "";
	String testCookbook = "";
	JSONObject jsonObject;

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

		jsonObject = new JSONObject();
		jsonObject.put("projectName", "EC-Chef-"
				+ StringConstants.PLUGIN_VERSION);

                if( !ConfigurationsParser.actions.containsKey("Berks") ){
                     System.out.println("Configurations not present for the test");
                     return;
                }
                 
                //Create a berks cookbook .
		if (callBerksCookbookProcedure(jsonObject).equals("success")) {

			System.out.println("Completed Berks cookbook test");
                        //Use the created Berksfile to install the cookbooks
			if (callBerksInstallProcedure(jsonObject).equalsIgnoreCase(
					"success")) {

				System.out.println("Completed Berks install test");
				//Use the same Berksfile to upload the cookbook.
				if (callBerksUploadProcedure(jsonObject).equals("success")) {
					System.out.println("Passed all berks test");
                                        //Delete the cookbook created for this unit test.
					TestUtils.deleteTemporaryObjects("", objectName, StringConstants.COOKBOOK.toLowerCase() , testCookbook);
					
				}
			}
		}

	}

	public String callBerksCookbookProcedure(JSONObject jsonObject)
			throws Exception {
		for (Map.Entry<String, HashMap<String, HashMap<String, String>>> objectCursor : ConfigurationsParser.actions
				.get("Berks").entrySet()) {
			if (objectCursor.getKey().equals("Cookbook")) {

				jsonObject.put("procedureName", "Berks"
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
								&& !propertyCursor.getValue().isEmpty()) {

							if (propertyCursor != null
									&& propertyCursor.getKey()
											.endsWith("_name")) {

								objectName = propertyCursor.getValue()
										.toString();

							}

							else if (propertyCursor != null
									&& propertyCursor.getKey().equals(
											"cookbook_path")) {

								testCookbook = propertyCursor.getValue()
										.toString();

							}

							actualParameterArray.put(new JSONObject().put(
									"value", propertyCursor.getValue()).put(
									"actualParameterName",
									propertyCursor.getKey()));
						}
					}
					jsonObject.put("actualParameter", actualParameterArray);
					return procedureResult(objectCursor.getKey());
				}
			}
		}
		return null;
	}

	public String callBerksInstallProcedure(JSONObject jsonObject)
			throws Exception {
		for (Map.Entry<String, HashMap<String, HashMap<String, String>>> objectCursor : ConfigurationsParser.actions
				.get("Berks").entrySet()) {
			if (objectCursor.getKey().equals("Install")) {

				jsonObject.put("procedureName", "Berks"
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
								&& !propertyCursor.getValue().isEmpty()) {

							if (propertyCursor.getKey()
									.equals("berksfile_path")) {

								actualParameterArray.put(new JSONObject().put(
										"value",
										Paths.get(testCookbook,"Berksfile")
												.toString()).put(
										"actualParameterName",
										propertyCursor.getKey()));

							} else {
								actualParameterArray.put(new JSONObject().put(
										"value", propertyCursor.getValue())
										.put("actualParameterName",
												propertyCursor.getKey()));
							}
						}
					}
					jsonObject.put("actualParameter", actualParameterArray);
					return procedureResult(objectCursor.getKey());
				}
			}
		}
		return null;
	}

	public String callBerksUploadProcedure(JSONObject jsonObject)
			throws Exception {
		for (Map.Entry<String, HashMap<String, HashMap<String, String>>> objectCursor : ConfigurationsParser.actions
				.get("Berks").entrySet()) {
			if (objectCursor.getKey().equals("Upload")) {

				jsonObject.put("procedureName", "Berks"
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
								&& !propertyCursor.getValue().isEmpty()) {

							if (propertyCursor.getKey()
									.equals("berksfile_path")) {

								actualParameterArray.put(new JSONObject().put(
										"value",
										Paths.get(testCookbook,"Berksfile")
												.toString()).put(
										"actualParameterName",
										propertyCursor.getKey()));

							} else {
								actualParameterArray.put(new JSONObject().put(
										"value", propertyCursor.getValue())
										.put("actualParameterName",
												propertyCursor.getKey()));
							}
						}
					}
					jsonObject.put("actualParameter", actualParameterArray);
					return procedureResult(objectCursor.getKey());
				}
			}
		}
		return null;
	}

	private String procedureResult(String objectCursor) throws Exception {
		String jobId = TestUtils.callRunProcedure(jsonObject);
		String response = TestUtils.waitForJob(jobId,
				StringConstants.jobTimeoutMillis);
		// Check job status
		assertEquals("Job completed with errors", "success", response);
		return response;

	}
}
