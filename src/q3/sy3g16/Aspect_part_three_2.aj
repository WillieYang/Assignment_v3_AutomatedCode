package q3.sy3g16;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Set;

import org.aspectj.lang.Signature;

public aspect Aspect_part_three_2 {
	
	public int exception_times = 0; // Times of all method that throwing an exception.
	public int total_times = 0; // Times of all method that is called. 
	public String sig_failure; // The signature of current join point -- type is string.
	public String failurefile = "./failures.csv"; // CSV file to store the failure frequency of each method. 
	HashMap<String, int[]> failuremap = new HashMap<>();
	// A HashMap in which the key is the method signature as a form of string and the value is an array to 
	// store times of each method being called and times that each method throwing exception.
	pointcut callnodes(): call(public int q3..*(int) throws Exception);
	// A point-cut to call the method of interest.
	int around() throws Exception: callnodes(){
		
		Signature sig = thisJoinPointStaticPart.getSignature();
		// The signature of current join point.
		sig_failure = sig.toString();
		// Convert the type of signature into string.
		
		if(failuremap.get(sig_failure) == null){ // Test whether the signature of current method is existed in HashMap.
			failuremap.put(sig_failure, new int[2]);
			// If not, put the method signature as a key into the HashMap and initialize the value.
			failuremap.get(sig_failure)[0] = 0;
			// Use the value of array in index 0 as times when current method is called and assign integer 0 to it.
			failuremap.get(sig_failure)[1] = 0;
			// Use the value of array in index 1 as times when current method is throwing exception and assign integer 0 to it.
		}
		try {
			++ total_times; // Count times in all method that is called successfully.
			++ failuremap.get(sig_failure)[0]; // Count times that current method is called. 
			proceed();
			
			//++
			return 0;}
		catch(Exception e){
			System.out.println("Exception:" + e);
			++exception_times; // Count times in all method that throwing an exception.
			++ failuremap.get(sig_failure)[1]; // Count times that the current method throwing an exception.
			return 0;
			}
		}		
	after(): execution(public static * main(..)){
		System.out.println("Total_times:" + total_times); // Overall times of method being called.
		System.out.println("Exception_times:" + exception_times); // Overall times of method that throwing an exception.
		
		Set<String> failurekeys = failuremap.keySet(); // Put the key of HashMap into a set.
		try(FileWriter fw_fail = new FileWriter(failurefile, true);
				BufferedWriter bw_fail = new BufferedWriter(fw_fail);
				PrintWriter out_fail = new PrintWriter(bw_fail))
		{
			for(String f: failurekeys){
				int total_ts = failuremap.get(f)[0]; // Get times that the current method is called.
				int fail_ts = failuremap.get(f)[1]; // Get times that the current method throwing an exception.
				float failure_fr = ((float)fail_ts) / total_ts; // Calculate the failure frequency of current method. 
				System.out.println("Method:" + f);
				System.out.println("Failure fr:" + failure_fr);
				System.out.println("tatal_times:" + total_ts);
				System.out.println("fail_times:" + fail_ts);
				out_fail.println("Method:" + f + "  " + "Failure Frequency:" + failure_fr);
				} // Write the failure frequency of method into a .csv file.
			}catch(IOException e){
				System.out.println("Error Message.");}		
	}
}
