package q3;

public class A {

	public int foo(int a) throws Exception{
		bar(a);
		return 0;
	}
	
	public int bar(int b) throws Exception{
		
		if(b==2){
			
				throw new Exception();
		}else{	return baz(b);}
		
	
	}
	
	public int baz(int a) throws Exception{
		
		return a + a;
	}
	
	public int tell(int a) throws Exception{
		
		System.out.println("shengyang");
		return baz(a);

	}
}
