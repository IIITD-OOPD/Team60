package neeti.logicGates;

public class NOT {
	int input=0;	
	int output=0;
	public int getInput() {
		return input;
	}
	public void setInput(int input) {
		this.input = input;
	}
	public int getOutput() {
		if(input==0)
			output=1;
		else output=0;
		
		return output;
	}
	public void setOutput(int output) {
		this.output = output;
	}
	
}
