package q3.sy3g16;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Set;

import org.aspectj.lang.Signature;

public aspect Aspect_part_three_2 {
	
	public int exception_times = 0;
	public int total_times = 0;
	public String sig_failure;
	public String failurefile = "./failures.csv";
	HashMap<String, int[]> failuremap = new HashMap<>();

	pointcut callnodes(): call(public int q3..*(int) throws Exception);
	
	int around() throws Exception: callnodes(){
		
		Signature sig = thisJoinPointStaticPart.getSignature();
		sig_failure = sig.toString();
		
		if(failuremap.get(sig_failure) == null){
			failuremap.put(sig_failure, new int[2]);
			
			failuremap.get(sig_failure)[0] = 0;
			failuremap.get(sig_failure)[1] = 0;
		}
		try {
			++ total_times;
			++ failuremap.get(sig_failure)[0];
			proceed();
			
			//++
			return 0;}
		catch(Exception e){
			System.out.println("Exception:" + e);
			++exception_times;
			++ failuremap.get(sig_failure)[1];
			return 0;
			}
		}		
	after(): execution(public static * main(..)){
		System.out.println("Total_times:" + total_times);
		System.out.println("Exception_times:" + exception_times);
		
		Set<String> failurekeys = failuremap.keySet();
		try(FileWriter fw_fail = new FileWriter(failurefile, true);
				BufferedWriter bw_fail = new BufferedWriter(fw_fail);
				PrintWriter out_fail = new PrintWriter(bw_fail))
		{
			for(String f: failurekeys){
				int total_ts = failuremap.get(f)[0];
				int fail_ts = failuremap.get(f)[1];
				float failure_fr = ((float)fail_ts) / total_ts;
				System.out.println("Method:" + f);
				System.out.println("Failure fr:" + failure_fr);
				System.out.println("tatal_times:" + total_ts);
				System.out.println("fail_times:" + fail_ts);
				out_fail.println("Method:" + f + "  " + "Failure Frequency:" + failure_fr);
				}
			}catch(IOException e){
				System.out.println("Error Message.");}		
	}
}
