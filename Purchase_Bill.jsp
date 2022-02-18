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
		String folderLocation = "D:\\GST\\Private Files\\Purchase\\";
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

	<center><font size="5">BILLING INFORMATION FOR PURCHASE TAX INVOICE</font></p></center>
    	<BR><BR>
  
  	<table border="0" width="100%">
    	<tr>
      		<td width="17%" align="right" height="25"></td>
      		<td width="32%" height="25" align="right">Select Consumer</td>
      		<td width="51%" height="25">
      			<select size="1" name="Consumer" onchange="ungst();">
      			<option selected value="Select">Select Consumer</option>
				<option value="unGST">Un GST</option>
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
		</table>
		<div id="ungs" class="readonly">

		</div>
	<table border="0" width="100%">
		<tr>
      		<td width="17%" align="right" height="21"></td>
      		<td width="32%" height="21" align="right">Invoice Number</td>
      		<td width="51%" height="21"><input type="text" name="invoice"></td>
    	</tr>	
		<tr>
			<td width="17%" align="right" height="25"></td>
      		<td width="32%" height="25" align="right">Select Date</td>
			<td width="51%" height="25">
			<select size="1" name="date">
				<option selected value="Select">Date</option>
				<%
				for(int j=1;j<=31;j++)
				{
					%>
					<option value="<%=j%>"><%=j%></option>
					<%
				}
				%>
			</select>
			<select size="1" name="month">
				<option selected value="Select">Month</option>
				<option value="1">January</option>
				<option value="2">February</option>
				<option value="3">March</option>
				<option value="4">April</option>
				<option value="5">May</option>
				<option value="6">June</option>
				<option value="7">July</option>
				<option value="8">August</option>
				<option value="9">September</option>
				<option value="10">October</option>
				<option value="11">November</option>
				<option value="12">December</option>
			</select>
			<select size="1" name="year" id="year">
				<option selected value="Select">Year</option>
			</select>
				</td>
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
    
    <center> <input type="button" value="    SUBMIT    " name="Print" onClick="startSearch();"></center>
  
	</form>

	<SCRIPT language="JavaScript">
	document.getElementById('ungs').style.display = "none";
	function ungst() {
		if(document.frm.Consumer.value == "unGST")
		{
			var div = document.createElement('div');
			div.innerHTML = '<table border="0" width="100%"><tr>\
			<td width="17%" align="right" height="25"></td>\
      		<td width="32%" height="25" align="right">Name of the unGST consumer</td>\
      		<td width="51%" height="25"><input type="text" name="ungstname" /></td>\
		</tr></table>';
		
		document.getElementById('ungs').appendChild(div);
		document.getElementById('ungs').style.display = "block";
		}
	}
	
	var d = new Date();
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
		if(document.frm.Consumer.value == "unGST")
		{
			if(document.frm.ungstname.value == "")
			{
				alert("You must enter the name of the unGST customer");
				return;
			}
		}

		if(document.frm.date.value == "Select")
		{
			alert("You must select the date");
			return;
		}
		if(document.frm.month.value == "Select")
		{
			alert("You must select the month");
			return;
		}
		if(document.frm.year.value == "Select")
		{
			alert("You must select the year");
			return;
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
  		document.frm.action="Purchase_Print.jsp?counter="+(counter-1);
  		document.frm.submit();
	}
	
	function fillvalues()
	{
		var select = document.getElementById('year');
		for(var i=d.getFullYear();i>=2018;i--)
		{
			var opt = document.createElement('option');
			opt.value = i;
			opt.innerHTML = i;
			select.add(opt);
		}
	}
	window.fillvalues();
  	</SCRIPT>
</body>
</html>
