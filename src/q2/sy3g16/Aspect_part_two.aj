package q2.sy3g16;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Set;

import org.aspectj.lang.Signature;

public aspect Aspect_part_two {

	public String node;
	public String edge;
	public String current_node;
	public String enclosing_node;
	public String nodefile = "./node.csv";
	public String edgefile = "./edge.csv";
	HashMap<String, String> nodemap = new HashMap<String, String>();
	HashMap<String, String> edgemap = new HashMap<String, String>();

	pointcut callnodes(): call(public int q2..*(int));
	pointcut calledge(): call(public int q2..*(int))
	&& withincode(public int q2..*(int));
	
	before() : callnodes(){
		
		Signature sig_node = thisJoinPointStaticPart.getSignature();
		
		node = sig_node.getDeclaringTypeName() + "." + sig_node.getName() + "(int)";
	
		nodemap.put(node, null);
		
	}
	
	after() returning(Object o) : calledge(){
		
		Signature sig_current = thisJoinPointStaticPart.getSignature();
		Signature sig_enclosing = thisEnclosingJoinPointStaticPart.getSignature();
		
		current_node = sig_current.getDeclaringTypeName() + "." + sig_current.getName() + "(int)";
		enclosing_node = sig_enclosing.getDeclaringTypeName() + "." + sig_enclosing.getName() + "(int)";
		
		edge = enclosing_node + "-->" + current_node;
		
		System.out.println("Return normally:" + o);
		
		edgemap.put(edge, null);
	
	}
	
	after(): execution(public static * main(..)){
		
		try(FileWriter fw_node = new FileWriter(nodefile, true);
				BufferedWriter bw_node = new BufferedWriter(fw_node);
				PrintWriter out_node = new PrintWriter(bw_node))
			{
			Set<String> keys = nodemap.keySet();
			for(String n : keys){
				System.out.println(n);
				out_node.println(n);
			}	
				
			}catch(IOException e){
				System.out.println("Error Message.");
			}
		
		try(FileWriter fw_edge = new FileWriter(edgefile, true);
				BufferedWriter bw_edge = new BufferedWriter(fw_edge);
				PrintWriter out_edge = new PrintWriter(bw_edge))
			{
			Set<String> keys = edgemap.keySet();
			for(String n : keys){
				System.out.println(n);
				out_edge.println(n);
			}	
				
			}catch(IOException e){
				System.out.println("Error Message.");
			}
		
	}
}
