package q3.sy3g16;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Set;

import org.aspectj.lang.Signature;

public aspect Aspect_part_three_1 {
	
	public String sig_hist; // The signature of current join point--type is string. 
	HashMap<String, HashMap<Integer, int[]>> histmap = new HashMap<>();
	// A HashMap in which the key is the method signature as a form of string,
	//the value is a form of nested HashMap in which the key is the input or return value 
	//and the value in nested HashMap is the times that the key is used as input or return.     
	public String histfile; // CSV file as a histogram to store the value and how many times
							//it is used as input and return.
	
	pointcut callhist(int input_value): call(public int q3..*(int))
											&& args(input_value);
	// A point-cut to call the method of interest and get the input value.
	
	after(int input_value) returning(Object o): callhist(input_value){
		
		Signature sig = thisJoinPointStaticPart.getSignature();
		// The signature of current join point.
		sig_hist = sig.toString();
		// Covert the type of signature into string.
		int return_value = (Integer) o;
		// Convert the type of return value into string.
		System.out.println(sig_hist + input_value + "---" + return_value);
		
		if(histmap.get(sig_hist) == null){ // Test whether the signature of current method is existed in HashMap.
			histmap.put(sig_hist, new HashMap<Integer, int[]>());}
			// If not, put the method signature as a key into the HashMap and initialize the value.
			if(histmap.get(sig_hist).get(input_value) == null){
			// Test whether input value is existed in the nested HashMap.
				histmap.get(sig_hist).put(input_value, new int[2]);
				// If not, put the input value as a key into the HashMap and initialize the value.
				histmap.get(sig_hist).get(input_value)[0] = 1;
				// Use the value of array in index 0 as times when it is used as input value and assign integer 1 to it.  
				histmap.get(sig_hist).get(input_value)[1] = 0;
				// Use the value of array in index 1 as times when it is used as return value and assign integer 0 to it.  
			}
		else{
				++ histmap.get(sig_hist).get(input_value)[0];
				// if the input value and method signature is existed in current invoked method, the times that current 
				// value is used as input value would auto increase 1.
			}
		
			if(histmap.get(sig_hist).get(return_value) == null){
				histmap.get(sig_hist).put(return_value, new int[2]);
				
				histmap.get(sig_hist).get(return_value)[0] = 0;
				histmap.get(sig_hist).get(return_value)[1] = 1;
			}
			else{
				++ histmap.get(sig_hist).get(return_value)[1];
			} // Same pattern as input value.
	}
	
	after(): execution(public static * main(..)){
		
		Set<String> histkeys = histmap.keySet(); // Put the key of HashMap into a set.
		for(String f: histkeys){ // Loop to get the method signature.
			System.out.println(histmap.get(f));
			histfile = "./" + f + ".csv"; // Create the csv file of current method signature.
			try(FileWriter fw_hist = new FileWriter(histfile, true);
					BufferedWriter bw_hist = new BufferedWriter(fw_hist);
					PrintWriter out_hist = new PrintWriter(bw_hist))
			{
				Set<Integer> values = histmap.get(f).keySet(); // Put the key of HashMap into a set. 
					for(Integer v : values){ // Loop to get the value.
						int it_fr = histmap.get(f).get(v)[0]; // Get times of value as input.
						int rt_fr = histmap.get(f).get(v)[1]; // Get times of value as return.
						
						out_hist.println("Value:" + v);
						out_hist.println("Input Times:" + it_fr);
						out_hist.println("Return Times:" + rt_fr);
						out_hist.println("-----------------"); // Write all the values and times as input or return into csv file.
						System.out.println("Method:" + f);
						System.out.println("Value:" + v);
						System.out.println("Input Frequency:" + it_fr);
						System.out.println("Return Frequency:" + rt_fr);
				}
			}catch(IOException e){
				System.out.println("Error Message.");
			} // Catch Exception.
		}
	}
}
