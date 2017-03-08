package q3.sy3g16;

import java.util.HashMap;
import java.util.Set;

import org.aspectj.lang.Signature;

public aspect Aspect_part_threee_1 {
	
	public String sig_hist;
	HashMap<String, HashMap<Integer, int[]>> histmap = new HashMap<>(); 
	
	pointcut callhist(int input_value): call(public int q3..*(int))
	&& args(input_value);
	
	after(int input_value) returning(Object o): callhist(input_value){
		
		Signature sig = thisJoinPointStaticPart.getSignature();
		sig_hist = sig.toString();
		
		int return_value = (Integer) o;
		
		System.out.println(sig_hist + input_value + return_value);
		
		if(histmap.get(sig_hist).get(input_value) == null){
			histmap.put(sig_hist, new HashMap<Integer, int[]>());
			histmap.get(sig_hist).put(input_value, new int[2]);
			
			histmap.get(sig_hist).get(input_value)[0] = 1;
			histmap.get(sig_hist).get(input_value)[1] = 0;
		}else{
			++histmap.get(sig_hist).get(input_value)[0];
		}
		
		if(histmap.get(sig_hist).get(return_value) == null){
			histmap.put(sig_hist, new HashMap<Integer, int[]>());
			histmap.get(sig_hist).put(return_value, new int[2]);
			
			histmap.get(sig_hist).get(return_value)[0] = 0;
			histmap.get(sig_hist).get(return_value)[1] = 1;
		}else{
			++histmap.get(sig_hist).get(return_value)[1];
		}
		
		
//		Set<String> histkeys = histmap.keySet();
//		for(String h : histkeys){
//			
//			String hist = histmap.get(h);
//			
			
			
			
//			if(h == sig_hist){
//				
//			}
//			else{
//				if(input_value == return_value){
//					histmap.put(sig_hist, new HashMap<Integer, int[]>());
//					
//					histmap.get(sig_hist).put(input_value, new int[2]);
//					
//					histmap.get(sig_hist).get(input_value)[0] = 1;
//					histmap.get(sig_hist).get(input_value)[1] = 1;
//			
//				}
//				else{
//					histmap.put(sig_hist, new HashMap<Integer, int[]>());
//					
//					histmap.get(sig_hist).put(input_value, new int[2]);
//					histmap.get(sig_hist).put(return_value, new int[2]);
//					
//					histmap.get(sig_hist).get(input_value)[0] = 1;
//					histmap.get(sig_hist).get(input_value)[1] = 0;
//					histmap.get(sig_hist).get(return_value)[1] = 1;
//					histmap.get(sig_hist).get(return_value)[0] = 0;
//				}
//			}
//		}
	}
	
	after(): execution(public static * main(..)){
		
		Set<String> histkeys = histmap.keySet();
		for(String f: histkeys){
			System.out.println(histmap.get(f));
		}
	}
	
}
