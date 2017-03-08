package q3;

public class B {

	public int foo(int a){
		bar(2);
		return 0;
	}
	
	public int bar(int b){
		
		return baz(b);
	}
	
	public int baz(int a){
		
		return a + a;
	}
}
