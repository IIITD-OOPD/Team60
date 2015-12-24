<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<%@ page import="neeti.logicGates.*" %>
<%@ page import="neeti.DBConnection" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.*" %>
</head>
<body>
<%  
	int id = 0;
	String[] checkboxes=null;
	if(request.getParameter("id")!=null)
		id=Integer.parseInt(request.getParameter("id"));
	if(request.getAttribute("id")!=null)
		id=(Integer)(request.getAttribute("id"));
	application.setAttribute("id2", id);
	String name = "";
	if(request.getParameterValues("input_checkbox")!=null && request.getAttribute("idFromCB")!=null)
	{
		id=(Integer)request.getAttribute("idFromCB");
		checkboxes=request.getParameterValues("input_checkbox");
	}
	if(request.getAttribute("idFromCB")!=null)
	{
		id=(Integer)request.getAttribute("idFromCB");
		
	}
	DBConnection db = new DBConnection("com.mysql.jdbc.Driver","jdbc:mysql://localhost:3306/","oopd","root","");
	ResultSet rs = db.executeSelect("select CircuitName from circuits where idCircuits='"+id+"'", 1);
	while(rs.next())
	{
		name = rs.getString(1);
	}
%>
<%=name %>
<table >
  
<% TreeMap<Integer,Integer> gates = new TreeMap<Integer,Integer>();
	TreeMap<Integer,Integer> inputs = new TreeMap<Integer,Integer>();
	TreeMap<Integer,Integer> output = new TreeMap<Integer,Integer>();	
	
	ResultSet rs_total_gates = db.executeSelect("select COUNT(*) FROM elements where element_type='gate'",5);
	int levels=0;
	while(rs_total_gates.next())
		levels = ((Integer.parseInt(rs_total_gates.getString(1)))/3);	
	
	ResultSet rs_inputs = db.executeSelect("select * from elements where element_type='input' and circuit_id='"+id+"'", 3);
	while(rs_inputs.next())
	{
		inputs.put(Integer.parseInt(rs_inputs.getString(1)), 0);
	}
	if(checkboxes!=null)
	{
		for(int i=0;i<checkboxes.length;i++)
		{
			inputs.replace(Integer.parseInt(checkboxes[i]), 1);
		}
	}
	int count = inputs.size();
	ResultSet rs_outputs = db.executeSelect("select * from elements where element_type='output' and circuit_id='"+id+"'", 4);
	while(rs_outputs.next())
	{
		output.put(Integer.parseInt(rs_outputs.getString(1)), -1);
	}
	ResultSet rs_gates = db.executeSelect("select * from elements where element_type='gate' and circuit_id='"+id+"'", 4);
	while(rs_gates.next())
	{
		gates.put(Integer.parseInt(rs_gates.getString(1)), -1);
	}
	int count_gates=gates.size();
	int gate_input1[]=new int[count_gates];
	for(int i=0;i<count_gates;i++)
	{
		gate_input1[i]=-1;
	}
	int gate_input2[]=new int[count_gates];
	for(int i=0;i<count_gates;i++)
	{
		gate_input2[i]=-1;
	}
	int gate_output[]=new int[count_gates];
	for(int i=0;i<count_gates;i++)
	{
		gate_output[i]=-1;
	}
	int final_output=-1;
	while(final_output==-1)
	{
		for(int i=1;i<count_gates;i++)
		{
			ResultSet set = db.executeSelect("select input1_type,input2_type,input1_id,input2_id,label from elements where element_type='gate' and circuit_id='"+id+"' and element_id='"+i+"'", 4);
			while(set.next())
			{
				String input1_type = set.getString(1);
				String input2_type = set.getString(2);
				int input1_id = Integer.parseInt(set.getString(3));
				int input2_id = Integer.parseInt(set.getString(4));
				String label = set.getString(5);
				if(input1_type.equalsIgnoreCase("input-point"))
				{
					gate_input1[i-1]=inputs.get(input1_id);
				}
				if(input2_type.equalsIgnoreCase("input-point"))
				{
					gate_input2[i-1]=inputs.get(input1_id);
				}
				if(input1_type.equalsIgnoreCase("gate") && gate_output[input1_id-1]>-1)
				{
					gate_input1[i-1]=gate_output[input1_id-1];
				}
				if(input2_type.equalsIgnoreCase("gate") && gate_output[input2_id-1]>-1)
				{
					gate_input2[i-1]=gate_output[input2_id-1];
				}
							if(label.equalsIgnoreCase("AND"))
							{
				 				AND and=new AND();
								if(gate_input1[i-1]>-1 && gate_input2[i-1]>-1)
								{
									and.setInput1(gate_input1[i-1]);
									and.setInput2(gate_input2[i-1]);
									gate_output[i-1]=and.getOutput();
								}
							}
							
							else if(label.equalsIgnoreCase("OR"))
							{
								OR or=new OR();
							
								if(gate_input1[i-1]>-1 && gate_input2[i-1]>-1)
								{
									or.setInput1(gate_input1[i-1]);
									or.setInput2(gate_input2[i-1]);
									gate_output[i-1]=or.getOutput();
								}
							}
								
							else if(label.equalsIgnoreCase("NOR"))
							{
								NOR nor=new NOR();
							
								if(gate_input1[i-1]>-1 && gate_input2[i-1]>-1)
								{
									nor.setInput1(gate_input1[i-1]);
									nor.setInput2(gate_input2[i-1]);
									gate_output[i-1]=nor.getOutput();
								}
							}
							
							else if(label.equalsIgnoreCase("NAND"))
							{
								NAND nand=new NAND();
							
								if(gate_input1[i-1]>-1 && gate_input2[i-1]>-1)
								{
									nand.setInput1(gate_input1[i-1]);
									nand.setInput2(gate_input2[i-1]);
									gate_output[i-1]=nand.getOutput();
								}
							}
								
							else if(label.equalsIgnoreCase("XOR"))
							{
								XOR xor=new XOR();
							
								if(gate_input1[i-1]>-1 && gate_input2[i-1]>-1)
								{
									xor.setInput1(gate_input1[i-1]);
									xor.setInput2(gate_input2[i-1]);
									gate_output[i-1]=xor.getOutput();
								}
							}
								
							else if(label.equalsIgnoreCase("XNOR"))
							{
								XNOR xnor=new XNOR();
							
								if(gate_input1[i-1]>-1 && gate_input2[i-1]>-1)
								{
									xnor.setInput1(gate_input1[i-1]);
									xnor.setInput2(gate_input2[i-1]);
									gate_output[i-1]=xnor.getOutput();
								}
							}
								
							else if(label.equalsIgnoreCase("NOT"))
							{
								NOT not=new NOT();
							
								if(input1_type!=null && gate_input1[i-1]>-1)
								{
									not.setInput(gate_input1[i-1]);
									gate_output[i-1]=not.getOutput();
								}
								if(input2_type!=null && gate_input2[i-1]>-1)
								{
									not.setInput(gate_input2[i-1]);
									gate_output[i-1]=not.getOutput();
								}
							}
								
					
			}
				ResultSet set1 = db.executeSelect("select input1_type,input1_id from elements where element_type='output' and circuit_id='"+id+"'", 4);
				while(set1.next())
				{
					String input1_type = set1.getString(1);
					
					int input1_id = Integer.parseInt(set1.getString(2));
					
					if(input1_type.equalsIgnoreCase("input-point"))
					{
						final_output=inputs.get(input1_id);
					}
					else if(input1_type.equalsIgnoreCase("gate") && gate_output[input1_id-1]>-1)
					{
						final_output=gate_output[input1_id-1];
					}
					
				}
			}
		}
	
	
	ResultSet rs_number1 = db.executeSelect("select COUNT(*) FROM elements where input1_type='input-point' and input2_type='input-point'",6);
	for(int i = 0;i< levels+2;i++)
	{		
%>
	<tr height="40px">
    <% if(count!=0)
		{ %>
    <td><img src="0.png" width="40px" height="40px"></img></td>
    <% count--;
    }else { %>
    <td></td>
    <%} %>
    <td><div id=1><img src="not-gate.png" width="40px" height="40px"></img></div></td> 
    <td><img src="1.png" width="40px" height="7px"></img></td>
    <td><img src="1-11.png" width="40px" height="40px"></img></td>
    <td><img src="or-gate.png" width="40px" height="40px"></img></td> 
    <td><img src="1-11.png" width="40px" height="40px"></img></td>
    <td><img src="11.png" width="40px" height="40px"></img></td>
    <td><img src="xnor-gate.png" width="40px" height="40px"></img></td> 
    
 	</tr>

<% } %>
<% db.releaseResources(); %>
</table>
FINAL OUTPUT <%=final_output %>
</body>
</html>