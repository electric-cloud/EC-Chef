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

import java.io.File;
import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.Path;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;
import org.junit.BeforeClass;
import org.junit.Test;

public class CookbookLintingTest {

	private JSONObject jsonObject = new JSONObject();
	private long jobTimeoutMillis = 5 * 60 * 1000;
	private String testCookbookName = " ";
	private String testCookbookDir = " ";
	private String testCookbook = " ";
	private static String METADATA_UPDATE_RULE = "FC008";
	private static String CHECKED_TAG_PARAM = "checked_tags";

	// configurations;
	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
		// configurations is a HashMap having primary key as object type(client,
		// node, data bag)
		// and secondary key as property name
		ConfigurationsParser.configurationParser();
		System.out.println("Inside CookBookLinting Unit Test");
	}

	@Test
	public void validCookbookTest() throws Exception {
		addParameters(true);
		// Create a new cookbook for test
		KnifeUtils.runCommand(StringConstants.KNIFE + " cookbook create "
				+ testCookbookName + " --cookbook-path " + testCookbookDir);

		String jobId = TestUtils.callRunProcedure(jsonObject);
		String response = TestUtils.waitForJob(jobId, jobTimeoutMillis);

		// Check job status
		// Job should return success we add the tag to suppress metadata warning
		// test.
		assertEquals("Job completed with errors", "success", response);

		// delete cookbook as we donot want to leave any residue behind
		deleteCookbook();

		System.out
				.println("JobId:"
						+ jobId
						+ ", Completed List Unit Test Successfully for valid cookbook test");

	}

	@Test
	public void invalidCookbookTest() throws Exception {
		addParameters(false);
		// Create a new cookbook for test
		KnifeUtils.runCommand(StringConstants.KNIFE + " cookbook create "
				+ testCookbookName + " --cookbook-path " + testCookbookDir);

		String jobId = TestUtils.callRunProcedure(jsonObject);
		String response = TestUtils.waitForJob(jobId, jobTimeoutMillis);

		// Check job status
		// Job should return warning as new a cookbook does not pass the linting
		// test.

		assertEquals("Job completed with errors", "warning", response);

		// delete cookbook as we do not want to leave any residue behind
		deleteCookbook();

		System.out
				.println("JobId:"
						+ jobId
						+ ", Completed List Unit Test Successfully for invalid cookbook test");

	}

	public void addParameters(Boolean invalidCookbookTest) throws Exception {

		jsonObject.put("projectName", "EC-Chef-"
				+ StringConstants.PLUGIN_VERSION);
		for (Map.Entry<String, HashMap<String, HashMap<String, String>>> objectCursor : ConfigurationsParser.actions
				.get("CookbookLinting").entrySet()) {

			jsonObject.put("procedureName",
					objectCursor.getKey().replaceAll("\\s+", ""));

			for (Map.Entry<String, HashMap<String, String>> runCursor : objectCursor
					.getValue().entrySet()) {
				// Every run will be a new job
				JSONArray actualParameterArray = new JSONArray();
				for (Map.Entry<String, String> propertyCursor : runCursor
						.getValue().entrySet()) {
					// Get each Run's data and iterate over it to populate
					// parameter array

					if (propertyCursor != null
							&& !propertyCursor.getValue().isEmpty()) {
						actualParameterArray
								.put(new JSONObject().put("value",
										propertyCursor.getValue()).put(
										"actualParameterName",
										propertyCursor.getKey()));
						if (propertyCursor.getKey().equals("cookbook_path")) {
							Path cookbookPath = FileSystems.getDefault()
									.getPath(propertyCursor.getValue());
							// get cookbook name and directory from the path
							testCookbook = propertyCursor.getValue();
							testCookbookName = cookbookPath.getFileName()
									.toString();
							testCookbookDir = TestUtils.getSubstring(
									propertyCursor.getValue(), "(.*)"
											+ testCookbookName + "$");

						}
					}
					if (invalidCookbookTest) {
						actualParameterArray.put(new JSONObject().put("value",
								METADATA_UPDATE_RULE).put(
								"actualParameterName", CHECKED_TAG_PARAM));
					}
					jsonObject.put("actualParameter", actualParameterArray);

				}
			}
		}
	}

	private void deleteCookbook() {
		File directory = new File(testCookbook);
		// make sure directory exists
		if (!directory.exists()) {

			System.out.println("Directory does not exist.");
			System.exit(0);

		} else {
			try {
				TestUtils.deleteDirectory(directory);
			} catch (IOException e) {
				e.printStackTrace();
				System.exit(0);
			}
		}
	}

}
