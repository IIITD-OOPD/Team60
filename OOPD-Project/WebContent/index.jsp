<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ page language ="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>



<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<script TYPE="text/javascript">
	function check()
	{
		var radios = document.getElementsByName("ckt");
		var flag=0;
		for (var i = 0; i < radios.length; i++) 
	    {
			if (radios.item(i).checked) {
                alert("checked!!");
                flag=1;
                break;
            } 
	    }
		if(flag==0)
		{
			alert("Please select a circuit!");
		}
		
	}
</script>
</head>
<body bgcolor="black">
<div style="text-align:center ;margin-top: 5%">
<form action='neeti/hello' method='post' enctype="multipart/form-data">
<font color="white">
Choose file..
<input type="file" name="filess" size="20"></input>
<input type="submit" name="button_upload" value="upload"></input>
</font>
</form>
<form name="myform" action="Circuit.jsp"  method="post" target="myframe0" >
<font color="white">

<%  Connection con=null;
	Statement m_Statement=null;
	String query=null;
	ResultSet m_ResultSet=null;
	
	Class.forName("com.mysql.jdbc.Driver");
	con = DriverManager.getConnection("jdbc:mysql://localhost:3306/oopd", "root", "");
	m_Statement = con.createStatement();
    query = "SELECT * FROM circuits";    
    m_ResultSet = m_Statement.executeQuery(query);	

if(m_ResultSet!=null)
{
while (m_ResultSet.next()) {           

      %>
<input type="radio" name="ckt" value="<%=m_ResultSet.getString(1)%>" ><%=m_ResultSet.getString(2) %><br>

<% }
}
%>
<input type="submit" value="Submit" onclick="check()">
</font>
</form>

</div>

</body>
</html>