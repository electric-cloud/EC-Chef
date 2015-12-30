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
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.nio.file.Path;
import java.nio.file.FileSystems;
import org.json.JSONArray;
import org.json.JSONObject;
import org.junit.BeforeClass;
import org.junit.Test;

public class CookbookUnitTestingTest {
    // configurations;
    @BeforeClass
    public static void setUpBeforeClass() throws Exception {
        // configurations is a HashMap having primary key as object type(client,
        // node, data bag)
        // and secondary key as property name
        ConfigurationsParser.configurationParser();
        System.out.println("Inside CookbookUnitTesting");
    }

    @Test
    public void test() throws Exception {
        String testCookbookName = " ";
        String testCookbookDir = " ";
        String testCookbook = " ";
        JSONObject jsonObject = new JSONObject();
        //Temporary recipe for creating a file and also its spec
        String recipeContent = "file \"test.txt\" do\nowner \"root\"\ngroup \"root\"\nmode \"0755\"\naction :create\nend\n";
        String specContent = "require 'chefspec'\ndescribe 'createFileCookbook::default' do\nlet(:chef_run) {\nChefSpec::SoloRunner.new.converge(described_recipe)\n}\nit 'creates a file' do\nexpect(chef_run).to create_file('test.txt')\nend\nend";
        jsonObject.put("projectName", "EC-Chef-"
                + StringConstants.PLUGIN_VERSION);
        if( !ConfigurationsParser.actions.containsKey("CookbookUnitTesting") )
        {
            System.out.println("Configurations not present for the test");
            return;
        }
        for (Map.Entry<String, HashMap<String, HashMap<String, String>>> objectCursor : ConfigurationsParser.actions
                .get("CookbookUnitTesting").entrySet()) {
            jsonObject.put("procedureName", "CookbookUnitTesting");
            // Every run will be new job
            JSONArray actualParameterArray = new JSONArray();
            for (Map.Entry<String, HashMap<String, String>> runCursor : objectCursor
                    .getValue().entrySet()) {
                for (Map.Entry<String, String> propertyCursor : runCursor
                        .getValue().entrySet()) {
                    // Get each Run's data and iterate over it to populate
                    // parameter array

                    if (propertyCursor != null
                            && !propertyCursor.getValue().isEmpty()) {
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
                            // Create a new cookbook for test
                            KnifeUtils.runCommand(StringConstants.KNIFE + " cookbook create "
                                    + testCookbookName + " --cookbook-path " + testCookbookDir);
                            // Put a recipe to create a file
                            KnifeUtils.populateFile(cookbookPath + "/recipes/default.rb", recipeContent);
                            //Put spec file to validate recipe
                            KnifeUtils.populateFile(cookbookPath + "/spec/recipes/default_spec.rb", specContent);
                        }
                        else
                        {
                            actualParameterArray.put(new JSONObject().put(
                                        "value", propertyCursor.getValue()).put(
                                        "actualParameterName",
                                        propertyCursor.getKey()));
                        }
                            } 
                        }
                    }
            jsonObject.put("actualParameter", actualParameterArray);
            String jobId = TestUtils.callRunProcedure(jsonObject);
            String response = TestUtils.waitForJob(jobId, StringConstants.jobTimeoutMillis);
            // Check job status
            assertEquals("Job completed with errors", "success", response);
            System.out.println(StringConstants.KNIFE + " cookbook delete " + testCookbookName + " --yes");
            KnifeUtils.runCommand(StringConstants.KNIFE + " cookbook delete " + testCookbookName + " --yes");

            System.out.println("JobId:" + jobId
                    + ", Completed CookbookUnitTesting Test Successfully for "
                    + objectCursor.getKey());
                }
    }
}
