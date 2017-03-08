package q3.sy3g16;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Set;

import org.aspectj.lang.Signature;

public aspect Aspect_part_threee_1 {
	
	public String sig_hist;
	HashMap<String, HashMap<Integer, int[]>> histmap = new HashMap<>(); 
	public String histfile;
	
	pointcut callhist(int input_value): call(public int q3..*(int))
	&& args(input_value);
	
	after(int input_value) returning(Object o): callhist(input_value){
		
		Signature sig = thisJoinPointStaticPart.getSignature();
		sig_hist = sig.toString();
		
		int return_value = (Integer) o;
		
		System.out.println(sig_hist + input_value + "---" + return_value);
		
		if(histmap.get(sig_hist) == null){
			histmap.put(sig_hist, new HashMap<Integer, int[]>());}
			
			if(histmap.get(sig_hist).get(input_value) == null){
				
				histmap.get(sig_hist).put(input_value, new int[2]);
				
				histmap.get(sig_hist).get(input_value)[0] = 1;
				histmap.get(sig_hist).get(input_value)[1] = 0;
			}
		else{
				++ histmap.get(sig_hist).get(input_value)[0];
			}
		
			if(histmap.get(sig_hist).get(return_value) == null){
				histmap.get(sig_hist).put(return_value, new int[2]);
				
				histmap.get(sig_hist).get(return_value)[0] = 0;
				histmap.get(sig_hist).get(return_value)[1] = 1;
			}
			else{
				++ histmap.get(sig_hist).get(return_value)[1];
			}
	}
	
	after(): execution(public static * main(..)){
		
		Set<String> histkeys = histmap.keySet();
		for(String f: histkeys){
			System.out.println(histmap.get(f));
			histfile = "./" + f + ".csv";
			try(FileWriter fw_hist = new FileWriter(histfile, true);
					BufferedWriter bw_hist = new BufferedWriter(fw_hist);
					PrintWriter out_hist = new PrintWriter(bw_hist))
			{
				Set<Integer> values = histmap.get(f).keySet();
					for(Integer v : values){
						int it_fr = histmap.get(f).get(v)[0];
						int rt_fr = histmap.get(f).get(v)[1];
						
						out_hist.println("Value:" + v);
						out_hist.println("Input Frequency:" + it_fr);
						out_hist.println("Return Frequency:" + rt_fr);
						out_hist.println("-----------------");
						System.out.println(v);
						System.out.println(f);
						System.out.println(it_fr);
						System.out.println(rt_fr);
				}
			}catch(IOException e){
				System.out.println("Error Message.");
			}
		}
	}
}
