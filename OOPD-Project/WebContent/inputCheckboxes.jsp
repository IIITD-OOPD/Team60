<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@ page import="neeti.logicGates.*" %>
<%@ page import="neeti.DBConnection" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
</head>
<body bgcolor="black">
<div style="text-align:center">
<form action="Circuit.jsp" method="post" target="myframe0">

<table align="center">
<tr height="20px"></tr>
<% 
	DBConnection db = new DBConnection("com.mysql.jdbc.Driver","jdbc:mysql://localhost:3306/","oopd","root","");
	TreeMap<Integer,Integer> inputs = new TreeMap<Integer,Integer>();
	int id2 = 0;
	if((application.getAttribute("id2"))!=null)
		id2 = (Integer)application.getAttribute("id2");
	request.setAttribute("idFromCB", id2);
	ResultSet rs_inputs = db.executeSelect("select * from elements where element_type='input' and circuit_id='"+id2+"'", 3);
	while(rs_inputs.next())
	{
		inputs.put(Integer.parseInt(rs_inputs.getString(1)), 0);
	}
	int count = inputs.size();
	for(int i=0;i<count;i++)
	{
		%>


<tr height="40px">
<td></td><td></td><td><input type="checkbox" name="input_checkbox" value="<%=inputs.firstKey()%>"></td>
</tr>
<%
	inputs.remove(inputs.firstKey());
	}   %>
</table>
<input type="submit" value="Submit"> 
</form>
</div>
</body>
</html>