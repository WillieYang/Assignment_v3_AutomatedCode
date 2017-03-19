package q3.sy3g16;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Set;

import org.aspectj.lang.Signature;

public aspect Aspect_part_three_3 {
	
	public double sum = 0d; // Sum of runtime in each method.
	public double average = 0d; // Average of runtime in each method.
	public double temp = 0d; // A temporary number.
	public double strd_devi = 0d; // Standard Deviation.
	public String sig_runtime; // Signature of current join point--type is string.
	public String runtimefile = "./runtimes.csv";
	// CSV file to store average runtime and standard 
	//deviation of each method across all the invocations.
	HashMap<String, ArrayList<Double>> runtimemap = new HashMap<>();
	// A HashMap in which the key is the method signature as a form of string and the  
	// value is an array list to store the runtime of each method across all the invocations.  
	pointcut callnodes(): call(public int q3..*(int));
	// A point-cut to call the method of interest.
	int around(): callnodes(){
		
		double start_time = System.nanoTime(); // Accurate time of this second.
		int result = proceed();
		double execution_time = System.nanoTime() - start_time;
		// Execution time of method being executed. 
		Signature sig = thisJoinPointStaticPart.getSignature();
		// The signature of current join point.
		sig_runtime = sig.toString();
		// Convert the type of signature into string. 
		
		if(runtimemap.get(sig_runtime) == null){ // Test whether the signature of current method is existed in HashMap.
			runtimemap.put(sig_runtime, new ArrayList<Double>());
			// If not, put the method signature as a key into the HashMap and initialize the value.
		}
		
		runtimemap.get(sig_runtime).add(execution_time);
		// Add the current runtime into the array list of corresponding method signature.   
		
		System.out.println("excution time is£º" + execution_time);
		System.out.println("signiture is :"+sig_runtime);
		System.out.println("method size is: "+runtimemap.get(sig_runtime).size());
		return result;
	}
	
	after(): execution(public static * main(..)){
		
		Set<String> runtimekeys = runtimemap.keySet(); // Put the key of HashMap into a set. 
		try(FileWriter fw_run = new FileWriter(runtimefile, true);
				BufferedWriter bw_run = new BufferedWriter(fw_run);
				PrintWriter out_run = new PrintWriter(bw_run))
		{
			for(String r : runtimekeys){ // Loop to get the method signature.
				
				for(Double r_t : runtimemap.get(r)){ // Loop to calculate the sum of runtime about current method signature.  
					sum += r_t;} 
				
				System.out.println("size is: " + runtimemap.get(r).size());
				average = sum / runtimemap.get(r).size(); // Calculate the average runtime of current method signature.
				
				for(Double r_t : runtimemap.get(r)){
					temp += (r_t - average)*(r_t - average);}
				
				strd_devi = Math.sqrt(temp); // Calculate the standard deviation.
				
				System.out.println("The average runtime is :" + average);
				System.out.println("The standard deviation is :" + strd_devi);
				out_run.println("Method:" + r + "  " + " Average Excution Time:" + average + "  " + "Standard Deviation:" + strd_devi);
			} // Write the average runtime and standard deviation of each method across all the invocations into a .csv file.
		}catch(IOException e){
			System.out.println("Error Message.");
		}
		
	}
}
