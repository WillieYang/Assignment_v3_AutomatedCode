package q1.sy3g16;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Set;

import org.aspectj.lang.Signature;

public aspect Aspect_part_one {
	
	public String node; // The name of method being called.  
	public String edge; // The edge that between two nodes.
	public String current_node; // Current invoked method. 
	public String enclosing_node; // Enclosing method.
	public String nodefile = "./node.csv"; // CSV file to store the node being called.
	public String edgefile = "./edge.csv"; // CSV file to store the edge between two nodes. 
	HashMap<String, String> nodemap = new HashMap<String, String>();
	// A HashMap whose key is used to store the node.(in this case, use HashMap to avoid the duplicate nodes.) 
	HashMap<String, String> edgemap = new HashMap<String, String>();
	// A HashMap whose key is used to store the edge.(in this case, use HashMap to avoid the duplicate edges.) 
	pointcut callnodes(): call(public int q1..*(int));
	// A point-cut to call the method whose modifier is public, return type is integer, and in the package of q1. 
	pointcut calledge(): call(public int q1..*(int))
							&& withincode(public int q1..*(int));
	// A point-cut to call the method within the a particular method.  
	
	before() : callnodes(){
		
		Signature sig_node = thisJoinPointStaticPart.getSignature();
		// The signature of current join point.
		
		node = sig_node.getDeclaringTypeName() + "." + sig_node.getName() + "(int)";
		// The name of method being called.
		nodemap.put(node, null);	
		// Put the node into a HashMap as a key.
	} // This advice is to place the nodes being called into a HashMap.
	
	after(): calledge(){
		
		Signature sig_current = thisJoinPointStaticPart.getSignature();
		// The signature of current join point.
		Signature sig_enclosing = thisEnclosingJoinPointStaticPart.getSignature();
		// The signature of enclosing method about the current join point.
		current_node = sig_current.getDeclaringTypeName() + "." + sig_current.getName() + "(int)";
		// The name of current node.
		enclosing_node = sig_enclosing.getDeclaringTypeName() + "." + sig_enclosing.getName() + "(int)";
		// The name of enclosing node.
		edge = enclosing_node + "-->" + current_node;
		// The edge between two methods.
		edgemap.put(edge, null);
		// Put the edge into a HashMap as a key.
	} // This advice is to place the edges into a HashMap. 
	
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
			} // Write the nodes stored in the HashMap into a .csv file. 
		
		try(FileWriter fw_edge = new FileWriter(edgefile, true);
				BufferedWriter bw_edge = new BufferedWriter(fw_edge);
				PrintWriter out_edge = new PrintWriter(bw_edge)){
			
			Set<String> keys = edgemap.keySet();
			for(String n : keys){
				System.out.println(n);
				out_edge.println(n);}		
			}catch(IOException e){
				System.out.println("Error Message.");
			} // Write the edges stored in the HashMap into a .csv file.
	} // This advice is to write the nodes and edges stored into the CSV files.
}
