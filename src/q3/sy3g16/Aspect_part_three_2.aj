package q3.sy3g16;

import java.util.HashMap;
import org.aspectj.lang.Signature;

public aspect Aspect_part_three_2 {
	
	public int excep_times = 0;
	public int normal_times = 0;
	public String sig_failure;
	HashMap<String, int[]> failuremap = new HashMap<>();

	pointcut callnodes(): call(public int q3..*(int) throws Exception);
	
	int around() throws Exception: callnodes(){
		
//		Signature sig = thisJoinPointStaticPart.getSignature();
//		sig_failure = sig.toString();
//		
//		if(failuremap.get(sig_failure) == null){
//			failuremap.put(sig_failure, new int[2]);
//			
//			failuremap.get(sig_failure)[0] = 0;
//			failuremap.get(sig_failure)[1] = 0;
//		}
		
		
		
		
		try {
			++normal_times;
			proceed();
			
			//++
			return 0;}
		catch(Exception e){
			System.out.println("Exception:" + e);
			++excep_times;
			return 0;
			}
		}		
	after(): execution(public static * main(..)){
		System.out.println("Normal_times:" + normal_times);
		System.out.println("Exception_times:" + excep_times);
	}
}
