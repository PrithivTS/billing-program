<html>

<head>
<title>ADD CONSUMER</title>
</head>

<body bgcolor="#CCFFFF">
<BR><BR>

	<CENTER>
	<H1> <u>NANDHINI SAREES</u> </H1>
	</CENTER>
	
	
	<%@ page errorPage="errorpage.jsp" language="java"  import="java.sql.*"  %>
	<%@ page import="java.io.*" %>
	<%@ page import="java.util.*" %>
	<%@ page import = "java.text.*" %>
	
	<%
		String name = request.getParameter("name");
		String address = request.getParameter("address");
		String state = request.getParameter("state");
		int pincode = Integer.parseInt(request.getParameter("pincode"));
		String gst = request.getParameter("gst");
		
		String folderLocation = "D:\\GST\\Private Files\\Sales\\";
		String fname = "consumer_details.xls";
		String filename = folderLocation + fname;
		
	 	try
		{
			FileWriter fw = new FileWriter(filename,true);
			fw.write(name +"\t"+ address +"\t"+ state +"\t"+ pincode +"\t"+ gst + "\n");
			fw.close();
		}catch(Exception e){out.println(e);} 

	%>
	<SCRIPT language="JavaScript">
		alert("New consumer is successfully added");
		location.href="home.htm";
	</SCRIPT>
	
	
</body>
</html>