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
	
	public double sum = 0d;
	public double average = 0d;
	public double temp = 0d;
	public double strd_devi = 0d;
	public String sig_runtime;
	public String runtimefile = "./runtimes.csv";
	HashMap<String, ArrayList<Double>> runtimemap = new HashMap<>();

	pointcut callnodes(): call(public int q3..*(int));
	
	int around(): callnodes(){
		
		double start_time = System.nanoTime();
		int result = proceed();
		double execution_time = System.nanoTime() - start_time;
		
		Signature sig = thisJoinPointStaticPart.getSignature();
		sig_runtime = sig.toString();
		
		if(runtimemap.get(sig_runtime) == null){
			runtimemap.put(sig_runtime, new ArrayList<Double>());
		}
		
		runtimemap.get(sig_runtime).add(execution_time);
		
		System.out.println("excution time is£º" + execution_time);
		System.out.println("signiture is :"+sig_runtime);
		System.out.println("method size is: "+runtimemap.get(sig_runtime).size());
		return result;
	}
	
	after(): execution(public static * main(..)){
		
		Set<String> runtimekeys = runtimemap.keySet();
		try(FileWriter fw_run = new FileWriter(runtimefile, true);
				BufferedWriter bw_run = new BufferedWriter(fw_run);
				PrintWriter out_run = new PrintWriter(bw_run))
		{
			for(String r : runtimekeys){
				
				for(Double r_t : runtimemap.get(r)){
					sum += r_t;}
				
				System.out.println("size is: " + runtimemap.get(r).size());
				average = sum / runtimemap.get(r).size();
				
				for(Double r_t : runtimemap.get(r)){
					temp += (r_t - average)*(r_t - average);}
				
				strd_devi = Math.sqrt(temp); 
				
				System.out.println("The average runtime is :" + average);
				System.out.println("The standard deviation is :" + strd_devi);
				out_run.println("Method:" + r + "  " + " Average Excution Time:" + average + "  " + "Standard Deviation:" + strd_devi);
			}
		}catch(IOException e){
			System.out.println("Error Message.");
		}
		
	}
}
