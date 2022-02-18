<html>

<head>
<title>Bill</title>
</head>
<style>
input {
	text-align: center;
	font-weight: bold;
}
</style>
<body bgcolor="#CCFFFF">
	<CENTER>
	<H1> <u>NANDHINI SAREES</u> </H1>
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
		
		int n = Lines.size();
		
		String consumerName[] = new String[n];
		String address[] = new String[n];
		String state[] = new String[n];
		int pincode[] = new int[n];
		String gst[] = new String[n];
		
		for(i = 0; i < n; i++)
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

	<center><font size="5">BILLING INFORMATION FOR SALES TAX INVOICE</font></p></center>
    	<BR><BR>
  
  	<table border="0" width="100%" height="100">
    	<tr>
      		<td width="17%" align="right" height="25"></td>
      		<td width="32%" height="25" align="right">Select Consumer</td>
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
			<td width="17%" align="right" height="25"></td>
      		<td width="32%" height="25" align="right">Booking to different place? <input type="checkbox" name="booking" value="booking"></td>
			<td width="51%" height="25"><input type="text" name="bookplace"></td>
		</tr>
		<tr>
			<td width="17%" align="right" height="25"></td>
      		<td width="32%" height="25" align="right">Number of bundles</td>
			<td width="51%" height="25"><input type="text" name="bundle" value="1"></td>
		</tr>
<% /*		<tr>
			<td width="17%" align="right" height="25"></td>
      		<td width="32%" height="25" align="right">Billing Date</td>
			<td width="51%" height="25">
			<input type="text" size="2" name="date">

			<input type="text" size="2" name="month">
				
			<input type="text" size="4" name="year">
			</td>
		</tr> */ %>
		<tr>
			<td width="17%" align="right" height="25"></td>
      		<td width="32%" height="25" align="right">Transport</td>
			<td width="51%" height="25"><input type="text" name="transport" value="V.R.L"></td>
		</tr>	
		<tr>
      		<td width="17%" align="right" height="21"></td>
      		<td width="32%" height="21"></td>
      		<td width="51%" height="21"><input type="button" value="    Add New Row    " name="addrow" onClick="addRow();"></td>
    	</tr>
		
  	</table>
	
	<div align="center">
		<input type="text" value="S.No." size = "2" />
		<input type="text" value="Description of Goods" />
		<input type="text" value="Length" />
		<input type="text" value="HSN code" size="5" />
		<input type="text" value="No. of pieces" />
		<input type="text" value="Rate" />
	</div>
	
	<div id="content" width="70%" align="center">
	<input type="text" name="serial1" value="1" size = "2" />
	<input type="text" name="goods1" />
	<input type="text" name="length1" />
	<input type="text" name="hsn1" value="5407" size="5" />
	<input type="text" name="pieces1" />
	<input type="text" name="rate1" />
	</div>
	
	<BR><BR>
    
    <center> <input type="button" value="    PRINT    " name="Print" onClick="startSearch();"></center>
  
	</form>
	
	<SCRIPT language="JavaScript">
	var counter =2;
	function addRow() {
    var div = document.createElement('div');
	
    div.className = 'row';

    div.innerHTML =
        '<input type="text" name="serial' + counter +'" value="' + counter +'" size="2" />\
		<input type="text" name="goods' + counter +'" />\
		<input type="text" name="length' + counter +'" />\
		<input type="text" name="hsn' + counter +'" value="5407" size="5"/>\
		<input type="text" name="pieces' + counter +'" />\
		<input type="text" name="rate' + counter +'" />';
	counter++;
    document.getElementById('content').appendChild(div);
}

  	function startSearch()
  	{
		if(document.frm.Consumer.value == "Select")
		{
			alert("You must select a customer");
			return;
		}
		
		if(document.frm.booking.checked == true)
		{
			if(document.frm.bookplace.value == "")
			{
				alert("You must enter the booking place address");
				return;
			}
		}
		var i;
		
		for(i=1; i<counter;i++)
		{
			var x = "document.frm.goods"+i;
			var y = "document.frm.pieces"+i;
			var z = "document.frm.rate"+i;
			var w = "document.frm.length"+i;
			if(eval(x).value=="")
			{
				alert("You must enter the description of the goods");
				return;
			}
			if(eval(y).value=="")
			{
				alert("You must enter no of pieces");
				return;
			}
			if(eval(z).value=="")
			{
				alert("You must enter the value of rate");
				return;
			}
			if(eval(w).value=="")
			{
				alert("You must enter the length");
				return;
			}
		}
  		document.frm.action="Print.jsp?counter="+(counter-1);
  		document.frm.submit();
	}
/* 	var d = new Date();
	function fillvalues()
	{
		document.frm.date.value = d.getDate();
		document.frm.month.value = d.getMonth()+1;
		document.frm.year.value = d.getFullYear();
	}
	window.fillvalues(); */
  	</SCRIPT>

</body>
</html>
