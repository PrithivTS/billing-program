<html>

<head>
<title>Old Bills</title>
</head>
<style>
input {
	text-align: center;
	font-weight: bold;
}
</style>
<body bgcolor="#CCFFFF">
<br>
	<CENTER>
	<H2> <u>NANDHINI SAREES</u> </H2>
	</CENTER>


  
  	<%@ page errorPage="errorpage.jsp" import="java.net.*" %>
	<%@ page import="java.io.*" %>
	<%@ page import="java.util.*" %>
	<%
		String folderLocation = "D:\\GST\\Private Files\\Sales\\";
		String fname = "consumer_details.xls";
		String name = folderLocation + fname;
		File file = new File(name);
		Scanner inFile = new Scanner(file);
				
		int i = 0;
		ArrayList<String> Lines = new ArrayList<String>();
		
		if(file.exists())
		{
			while(inFile.hasNextLine())
				Lines.add(inFile.nextLine());
			inFile.close();
		}
		
		int n=Lines.size();
		String consumerName[] = new String[n];
		String address[] = new String[n];
		String state[] = new String[n];
		int pincode[] = new int[n];
		String gst[] = new String[n];
		
		for(i=0;i<n;i++)
		{
			String[] splitted = Lines.get(i).split("\\s+");
			int splitsize = splitted.length;
			consumerName[i] = "";
			for(int j=0;j<(splitsize-4);j++)
				consumerName[i] += splitted[j] +" ";
			consumerName[i].trim();
			address[i] = splitted[splitsize-4];
			state[i] = splitted[splitsize-3];
			pincode[i] = Integer.parseInt(splitted[splitsize-2]);
			gst[i] = splitted[splitsize-1];
		}
	%>


	<form name ="frm" method="POST">

	<center><h4>SEARCH CRITERIA TO EITHER VIEW OR MODIFY</h4></center>
    	<BR><BR>
  
  	<table border="0" width="100%" height="100">
    	<tr>
      		<td width="32%" align="right" height="25"><input type="radio" name="R1" checked value="Consumer"></td>
      		<td width="17%" height="25">Sort by Consumer</td>
      		<td width="51%" height="25">
      			<select size="1" name="Consumer">
      			<option selected value="Select">Select Consumer</option>
				<%
					i=0;
					while(i<n)
					{
				%>
	    			<option value="<%=consumerName[i]%>"><%=consumerName[i]%></option>
  				<%
					i++;
					}
				%>
    			</select>
    	      	</td>
    	</tr>
		<tr>
			<td width="32%" align="right" height="25"><input type="radio" name="R1" checked value="Date"></td>
      		<td width="17%" height="25" >Sort by date</td>
			<td width="51%" height="25">
				<select size="1" name="year" id="year">
					<option selected value="Select">Select Year</option>
				</select>
			</td>
		</tr>
		
		
  	</table>
	
	
	<BR><BR>
    
    <table width="100%">
	<tr>
	<td width="45%" align="right"><input type="button" value="    VIEW    " name="Submit" onClick="startSearch();"></td>
	<td width="10%"></td>
	<td align="left"><input type="button" value="    MODIFY   " name="Modify" onClick="modify();"></td>
	</tr>
	
	</table>
  
	</form>
	
	<SCRIPT language="JavaScript">
	var d = new Date();

	function startSearch()
  	{
	 	if(document.frm.R1[0].checked)
  		{
			if(document.frm.Consumer.value == "Select")
			{
				alert("You must select a customer");
				return;
			}
		}
    		
  		if(document.frm.R1[1].checked)
  		{
	  		if(document.frm.year.value == "Select")
			{
				alert("You must select a year");
				return;
			}
  		}	
		document.frm.action = "OldBills.jsp";
		document.frm.submit();  		
 	}
	
	function modify()
  	{
	 	if(document.frm.R1[0].checked)
  		{
			if(document.frm.Consumer.value == "Select")
			{
				alert("You must select a customer");
				return;
			}
		}
    		
  		if(document.frm.R1[1].checked)
  		{
	  		if(document.frm.year.value == "Select")
			{
				alert("You must select a year");
				return;
			}
  		}	
		document.frm.action = "Modify.jsp";
		document.frm.submit();  		
 	}

	function fillvalues()
	{
		var select = document.getElementById('year');
		for(var i=d.getFullYear();i>=2018;i--)
		{
			var opt = document.createElement('option');
			opt.value = i;
			opt.innerHTML = i + "-" + (i+1);
			select.add(opt);
		}
	}
	window.fillvalues();
  	</SCRIPT>
	
</body>
</html>
