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

import static org.junit.Assert.fail;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import java.util.Random;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.json.JSONException;
import org.json.JSONObject;

public class TestUtils {

	private static final long jobStatusPollIntervalMillis = 15000;
	private static Properties props;

	public static Properties getProperties() throws Exception {

		if (props == null) {
			props = new Properties();
			InputStream is = null;
			is = new FileInputStream("ecplugin.properties");
			props.load(is);
			is.close();
		}

		return props;
	}

	/**
	 * callRunProcedure
	 * 
	 * @param jo
	 * @return the jobId of the job launched by runProcedure
	 */
	public static String callRunProcedure(JSONObject jo) {
	
		HttpClient httpClient = new DefaultHttpClient();
		JSONObject result = null;

		try {
			props = getProperties();
			String encoding = new String(
					org.apache.commons.codec.binary.Base64
							.encodeBase64(org.apache.commons.codec.binary.StringUtils.getBytesUtf8(props
									.getProperty(StringConstants.COMMANDER_USER)
									+ ":"
									+ props.getProperty(StringConstants.COMMANDER_PASSWORD))));
			HttpPost httpPostRequest = new HttpPost("http://"
					+ StringConstants.COMMANDER_SERVER
					+ ":8000/rest/v1.0/jobs?request=runProcedure");
			StringEntity input = new StringEntity(jo.toString());
			input.setContentType("application/json");
			httpPostRequest.setEntity(input);
			httpPostRequest.setHeader("Authorization", "Basic " + encoding);
			HttpResponse httpResponse = httpClient.execute(httpPostRequest);
			result = new JSONObject(EntityUtils.toString(httpResponse
					.getEntity()));
			return result.getString("jobId");

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		} finally {
			httpClient.getConnectionManager().shutdown();
		}

	}

	/**
	 * waitForJob: Waits for job to be completed and reports outcome
	 * 
	 * @param jobId
	 * @return outcome of job
	 */
	static String waitForJob(String jobId, long jobTimeOutMillis)
			throws Exception {

		long timeTaken = 0;

		String url = "http://" + StringConstants.COMMANDER_SERVER
				+ ":8000/rest/v1.0/jobs/" + jobId + "?request=getJobStatus";
		JSONObject jsonObject = performHTTPGet(url);

		while (!jsonObject.getString("status").equalsIgnoreCase("completed")) {
			Thread.sleep(jobStatusPollIntervalMillis);
			jsonObject = performHTTPGet(url);
			timeTaken += jobStatusPollIntervalMillis;
			if (timeTaken > jobTimeOutMillis) {
				throw new Exception("Job did not completed within time.");
			}
		}
		return jsonObject.getString("outcome");
	}

	/**
	 * waitForJob: Waits for job to be completed and reports outcome
	 * 
	 * @param jobId
	 * @return outcome of job
	 */
	static String getJobStatus(String jobId) throws IOException, JSONException {

		HttpClient httpClient = new DefaultHttpClient();
		String output = "";
		String encoding = new String(
				org.apache.commons.codec.binary.Base64
						.encodeBase64(org.apache.commons.codec.binary.StringUtils.getBytesUtf8(props
								.getProperty(StringConstants.COMMANDER_USER)
								+ ":"
								+ props.getProperty(StringConstants.COMMANDER_PASSWORD))));
		HttpGet httpGetRequest = new HttpGet("http://"
				+ StringConstants.COMMANDER_SERVER + ":8000/rest/v1.0/jobs/"
				+ jobId + "?request=getJobDetails");
		httpGetRequest.setHeader("Authorization", "Basic " + encoding);

		try {

			HttpResponse httpResponse = httpClient.execute(httpGetRequest);
			if (httpResponse.getStatusLine().getStatusCode() >= 400) {
				throw new RuntimeException("HTTP GET failed with "
						+ httpResponse.getStatusLine().getStatusCode() + "-"
						+ httpResponse.getStatusLine().getReasonPhrase());
			}

			output = new JSONObject(EntityUtils.toString(httpResponse
					.getEntity())).getJSONObject("job").getJSONArray("jobStep")
					.getJSONObject(0).getJSONObject("propertySheet")
					.getJSONArray("property").getJSONObject(1)
					.getString("value");

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			httpClient.getConnectionManager().shutdown();
		}

		return output;
	}

	static String getSubstring(String string, String regex) {

		String substring = null;

		Pattern pattern = Pattern.compile(regex);
		Matcher matcher = pattern.matcher(string);
		if (matcher.find()) {
			substring = matcher.group(1);
		}
		return substring;
	}

	/**
	 * Wrapper around a HTTP GET to a REST service
	 * 
	 * @param url
	 * @return JSONObject
	 */
	static JSONObject performHTTPGet(String url) throws IOException,
			JSONException {

		HttpClient httpClient = new DefaultHttpClient();
		String encoding = new String(
				org.apache.commons.codec.binary.Base64
						.encodeBase64(org.apache.commons.codec.binary.StringUtils.getBytesUtf8(props
								.getProperty(StringConstants.COMMANDER_USER)
								+ ":"
								+ props.getProperty(StringConstants.COMMANDER_PASSWORD))));
		try {
			HttpGet httpGetRequest = new HttpGet(url);
			httpGetRequest.setHeader("Authorization", "Basic " + encoding);
			HttpResponse httpResponse = httpClient.execute(httpGetRequest);
			if (httpResponse.getStatusLine().getStatusCode() >= 400) {
				throw new RuntimeException("HTTP GET failed with "
						+ httpResponse.getStatusLine().getStatusCode() + "-"
						+ httpResponse.getStatusLine().getReasonPhrase());
			}
			return new JSONObject(
					EntityUtils.toString(httpResponse.getEntity()));

		} finally {
			httpClient.getConnectionManager().shutdown();
		}

	}

	public static int randInt() {
		int min = 100;
		int max = 10000;

		// NOTE: Usually this should be a field rather than a method
		// variable so that it is not re-seeded every call.
		Random rand = new Random();

		// nextInt is normally exclusive of the top value,
		// so add 1 to make it inclusive
		int randomNum = rand.nextInt((max - min) + 1) + min;

		return randomNum;
	}

	public static void createTemporaryObjects(String clientName,
			String cookbookPath, String objectName, String objectCursor) {
		// Create the object since we want to test its
		// delete
		// procedure
		if (objectCursor.equals(StringConstants.CLIENT_KEY)) {

			KnifeUtils.runCommand(StringConstants.KNIFE + " "
					+ StringConstants.CLIENT.toLowerCase() + " "
					+ StringConstants.CREATE.toLowerCase() + " " + clientName
					+ " -d");

			KnifeUtils.runCommand(StringConstants.KNIFE + " "
					+ objectCursor.toLowerCase() + " "
					+ StringConstants.CREATE.toLowerCase() + " " + clientName
					+ " --key-name " + objectName + " -d");

		} else if (objectCursor.equals("Cookbook")) {

			KnifeUtils.runCommand(StringConstants.KNIFE + " "
					+ objectCursor.toLowerCase() + " "
					+ StringConstants.CREATE.toLowerCase() + " " + objectName
					+ " --cookbook-path " + cookbookPath + " -d");

			KnifeUtils.runCommand(StringConstants.KNIFE + " "
					+ objectCursor.toLowerCase() + " " + "upload" + " "
					+ objectName + " --cookbook-path " + cookbookPath + " -d");

		} else {
			KnifeUtils.runCommand(StringConstants.KNIFE + " "
					+ objectCursor.toLowerCase() + " "
					+ StringConstants.CREATE.toLowerCase() + " " + objectName
					+ " -d");
		}
		System.out.println("Created Dummy object: " + objectName);

	}

	public static void createTemporaryObjects(String clientName,
			String objectName, String cookbookPath, String objectCursor,
			Boolean create) {
		if (objectCursor.equals(StringConstants.CLIENT_KEY)) {

			KnifeUtils.runCommand(StringConstants.KNIFE + " "
					+ StringConstants.CLIENT.toLowerCase() + " "
					+ StringConstants.CREATE.toLowerCase() + " " + clientName
					+ " -d");
		} else if (objectCursor.equals("Cookbook")) {
			KnifeUtils.runCommand(StringConstants.KNIFE + " "
					+ objectCursor.toLowerCase() + " " + "upload" + " "
					+ objectName + " --cookbook-path " + cookbookPath + " -d");

		}

	}

	public static void deleteTemporaryObjects(String clientName,
			String objectName, String objectCursor, String cookbookPath) {

		System.out.println("Cleaning temorary items");
		System.out.println(cookbookPath);
		// Delete the test objects since we do not want to leave any
		// residue

		if (clientName != null && !clientName.isEmpty()) {
			KnifeUtils.runCommand(StringConstants.KNIFE + " " + objectCursor
					+ " " + StringConstants.DELETE.toLowerCase() + " "
					+ clientName + " " + objectCursor + " -y");

			KnifeUtils.runCommand(StringConstants.KNIFE + " "
					+ StringConstants.CLIENT.toLowerCase() + " "
					+ StringConstants.DELETE.toLowerCase() + " " + clientName
					+ " " + " -y");
		} else if (!objectCursor.equals(StringConstants.DELETE)) {
			String output = KnifeUtils.runCommand(StringConstants.KNIFE + " "
					+ objectCursor + " " + StringConstants.DELETE.toLowerCase()
					+ " " + objectName + " -y");
			System.out.println(output);
		}
		if (!cookbookPath.isEmpty() && cookbookPath != null)
			deleteCookbook(cookbookPath);

	}

	public static void deleteTemporaryObjects(String clientName,
			String cookbookPath) {
		if (clientName != null && !clientName.isEmpty()) {

			KnifeUtils.runCommand(StringConstants.KNIFE + " "
					+ StringConstants.CLIENT.toLowerCase() + " "
					+ StringConstants.DELETE.toLowerCase() + " " + clientName
					+ " " + " -y");
		} else if (!cookbookPath.isEmpty() && cookbookPath != null)
			deleteCookbook(cookbookPath);
	}

	public static void deleteCookbook(String cookbookPath) {
		File directory = new File(cookbookPath);
		// make sure directory exists
		if (!directory.exists()) {

			System.out.println("Directory does not exist.");
			return;

		} else {
			try {
				TestUtils.deleteDirectory(directory);
			} catch (IOException e) {
				e.printStackTrace();
				return;
			}
		}

	}

	public static void deleteDirectory(File file) throws IOException {

		if (file.isDirectory()) {
			// directory is empty, then delete it
			if (file.list().length == 0) {
				file.delete();
			} else {
				// list all the directory contents
				String files[] = file.list();
				for (String temp : files) {
					// construct the file structure
					File fileDelete = new File(file, temp);
					// recursive delete
					deleteDirectory(fileDelete);
				}
				// check the directory again, if empty then delete it
				if (file.list().length == 0) {
					file.delete();
				}
			}

		} else {
			// if file, then delete it
			file.delete();
		}
	}

	public static void validation(String objectCursor, String clientName,
			String objectName, String jobId, String action) {
		String output = " ";
		if (clientName != null && !clientName.isEmpty()) {
			output = KnifeUtils.runCommand(StringConstants.KNIFE + " "
					+ objectCursor + " " + StringConstants.LIST.toLowerCase()
					+ " " + clientName);
		} else {
			output = KnifeUtils.runCommand(StringConstants.KNIFE + " "
					+ objectCursor + " " + StringConstants.LIST.toLowerCase());
		}

		String result = TestUtils.getSubstring(output, ".*(" + objectName
				+ ").*");
		System.out.println("Verification Command Output:" + result);
		if (action.equals(StringConstants.DELETE)) {

			if (result != null && (result.equals(objectName))) {
				System.out.println("JobId:" + jobId
						+ ", Test Failed. After delete also object "
						+ "is present(Validated using list command): "
						+ objectName);
				fail("Test Failed. After delete also object is present(Validated using list command).");
			}
		} else {
			if (result != null && (!result.equals(objectName))) {
				System.out
						.println("JobId:"
								+ jobId
								+ ",Test Failed. After "
								+ action.toLowerCase()
								+ " also object is not present(Validated using list command): "
								+ objectName);
				fail("Test Failed. After create also object is not present(Validated using list command).");
			}
		}
	}
}
