package q2;

public class B {

	public int foo(int a) throws Exception{
		bar(2);
		return 0;
	}
	
	public int bar(int b) throws Exception{
		
		if(b==2){
			
				throw new Exception();
		}
		
		return baz(b);
	}
	
	public int baz(int a){
		
		return a + a;
	}
}
