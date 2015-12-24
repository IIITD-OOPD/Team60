package neeti.logicGates;

public class XOR {
	int input1=0;
	int input2=0;
	int output=0;
	public int getInput1() {
		return input1;
	}
	public void setInput1(int input1) {
		this.input1 = input1;
	}
	public int getInput2() {
		return input2;
	}
	public void setInput2(int input2) {
		this.input2 = input2;
	}
	public int getOutput() {
		if(input1+input2==2 || input1+input2==0)
			output=0;
		else output=1;
		
		return output;
	}
	public void setOutput(int output) {
		this.output = output;
	}
}
