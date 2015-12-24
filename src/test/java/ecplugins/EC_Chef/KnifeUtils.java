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
import java.io.PrintWriter;
import java.io.BufferedReader;
import java.io.InputStreamReader;

public class KnifeUtils {

    private static String OS = System.getProperty("os.name").toLowerCase();

    public static String runCommand(String command)
    {
        StringBuffer output = new StringBuffer();
        Process process;
        String line = "";
        try{
            if (isWindows()) {
               process = Runtime.getRuntime().exec("cmd /c "+command);
            } else {
               process = Runtime.getRuntime().exec(command);       
            } 
            process.waitFor();
            BufferedReader readOutput = new BufferedReader(new InputStreamReader(process.getInputStream()));
            while((line = readOutput.readLine())!= null)
            {
                output = output.append(line + "\n");
            }
            BufferedReader readError = new BufferedReader(new InputStreamReader(process.getErrorStream()));
            while((line = readError.readLine())!= null)
            {
                output = output.append(line + "\n");
            }
        }
        catch(Exception e){
            System.out.println("Error while executing knife command:");
            e.printStackTrace();
        }
        return output.toString();

    }

    private static boolean isWindows() {

       return (OS.indexOf("win") >= 0);
    }

    public static void populateFile(String filePath, String fileContent)
    {
        try{
            PrintWriter file = new PrintWriter(filePath);
            file.println(fileContent);
            file.close();
        }
        catch(Exception e){
            System.out.println("Error while populating File");
            e.printStackTrace();
        }
    }
}
