<html>

<head>
<title>Old Bills</title>
</head>

<body bgcolor="#CCFFFF">
<BR>
<style>

input {
	text-align: center;
	font-weight: bold;
}
</style>

	<%@ page errorPage="errorpage.jsp" language="java"  import="java.sql.*"  %>
	<%@ page import="java.io.*" %>
	<%@ page import="java.util.*" %>
	<%@ page import = "java.text.*" %>
	
	<%
		DecimalFormat df = new DecimalFormat("#.00");
		Calendar now = Calendar.getInstance();
		
		int cMonth = now.get(Calendar.MONTH)+1;
		int YEAR = now.get(Calendar.YEAR);
		if(cMonth <= 4)
			YEAR -= 1;
		String consumerName = "";
		int searchVar = Integer.parseInt(request.getParameter("searchVar"));
		if(searchVar == 1)
			consumerName = request.getParameter("consumer");
		else
			YEAR = Integer.parseInt(request.getParameter("year"));
		
		String folderLocation = "D:\\GST\\Private Files\\Sales\\";
		int reqiValue = Integer.parseInt(request.getParameter("Invoice"));
		
		ArrayList<String> Lines = new ArrayList<String>();
		int i=0;
		if(searchVar == 2)
		{
			String billname = YEAR + "_Bills.xls";
			String billfilename = folderLocation + billname;
			File file = new File(billfilename);
			Scanner inFile = new Scanner(file);
			if(file.exists())
			{
				while(inFile.hasNextLine())
				{
					String check = inFile.nextLine();
					String[] splitted = check.split("\\s+");
					int month = Integer.parseInt(splitted[2]);
					int year = Integer.parseInt(splitted[3]);
						Lines.add(check);
				}
			}
			inFile.close();
		}
		if(searchVar == 1)
		{
			for(int k=YEAR; k>=2018;k--)
			{
				String billname = k + "_Bills.xls";
				String billfilename = folderLocation + billname;
				File file = new File(billfilename);
				Scanner inFile = new Scanner(file);
				if(file.exists())
				{
					while(inFile.hasNextLine())
					{
						String check = inFile.nextLine();
						String[] splitted = check.split("\\s+");
						int splitsize = splitted.length;
						int items = Integer.parseInt(splitted[5]);
						String name = "";
						int impt = splitsize - 5 * items - 2;
						for(int j=7; j < impt; j++)
							name += splitted[j] + " ";
						if(consumerName.equals(name))
							Lines.add(check);
					}
				}
				inFile.close();
			}
		}
		int n = Lines.size();
		
		int billno=0;
		int date=0;
		int month=0;
		int year=0;
		int bundle=0;
		int items=0;
		String transport="";
		String name="";
		String gst="";
		String state="";
		String itemname[] = new String[20];
		double itemlength[] = new double[20];
		int itemhsncode[] = new int[20];
		int itempieces[] = new int[20];
		int itemrate[] = new int[20];

			String[] splitted = Lines.get(reqiValue).split("\\s+");
			int splitsize = splitted.length;
			
			billno = Integer.parseInt(splitted[0]);
			date = Integer.parseInt(splitted[1]);
			month = Integer.parseInt(splitted[2]);
			year = Integer.parseInt(splitted[3]);
			bundle = Integer.parseInt(splitted[4]);
			items = Integer.parseInt(splitted[5]);
			transport = splitted[6];
			name = "";
			int impt = splitsize - 5 * items - 2;
			for(int j=7; j < impt; j++)
				name += splitted[j] + " ";
			gst = splitted[impt];
			state = splitted[impt+1];
			
			for(int j=1; j<=items;j++)
			{
				itemname[j-1] = splitted[impt+(j-1)*5+2];
				itemlength[j-1] = Double.parseDouble(splitted[impt+(j-1)*5+3]);
				itemhsncode[j-1] = Integer.parseInt(splitted[impt+(j-1)*5+4]);
				itempieces[j-1] = Integer.parseInt(splitted[impt+(j-1)*5+5]);
				itemrate[j-1] = Integer.parseInt(splitted[impt+(j-1)*5+6]);
				
			}

		

	%>
	
	<center>
	<h2>NANDHINI SAREES</h2>
	<h4>SALES INVOICE DETAILS FOR INVOICE NO. <%=billno%></h4>
	</center>
	
	<form name ="frm" method="POST">

  	<table border="0" width="100%" height="100">
    	<tr>
      		<td width="17%" align="right" height="25"></td>
      		<td width="32%" height="25" align="right">Consumer Name</td>
      		<td width="51%" height="25"><input type="text" name="Consumer" value="<%=name%>" readonly>
    	      	</td>
    	</tr>
		<tr>
      		<td width="17%" align="right" height="21"></td>
      		<td width="32%" height="21" align="right">Invoice Number</td>
      		<td width="51%" height="21"><input size="8" type="text" name="invoice" value="<%=billno%>" readonly></td>
    	</tr>	
		<tr>
			<td width="17%" align="right" height="25"></td>
      		<td width="32%" height="25" align="right">Invoice Date</td>
			<td width="51%" height="25"><input size="2" type="text" name="date" value="<%=date%>" readonly>
			<input size="2" type="text" name="month" value="<%=month%>" readonly>
			<input size="4" type="text" name="year" value="<%=year%>" readonly>

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
			<td width="51%" height="25"><input type="text" name="bundle" value="<%=bundle%>"></td>
		</tr>
		<tr>
			<td width="17%" align="right" height="25"></td>
      		<td width="32%" height="25" align="right">Transport</td>
			<td width="51%" height="25"><input type="text" name="transport" value="<%=transport%>"></td>
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
	
	
	<%
	for(int j=1; j<=items;j++)
	{
		if(j!=items)
		{
			%>
			<div width="70%" align="center">
			<input type="text" name="serial<%=j%>" value="<%=j%>" size = "2" />
			<input type="text" name="goods<%=j%>" value="<%=itemname[j-1]%>"/>
			<input type="text" name="length<%=j%>" value="<%=itemlength[j-1]%>"/>
			<input type="text" name="hsn<%=j%>" value="<%=itemhsncode[j-1]%>" size="5" />
			<input type="text" name="pieces<%=j%>" value="<%=itempieces[j-1]%>"/>
			<input type="text" name="rate<%=j%>" value="<%=itemrate[j-1]%>"/>
			</div>
			<%
		}
		else
		{
			%>
			<div id="content" width="70%" align="center">
			<input type="text" name="serial<%=j%>" value="<%=j%>" size = "2" />
			<input type="text" name="goods<%=j%>" value="<%=itemname[j-1]%>"/>
			<input type="text" name="length<%=j%>" value="<%=itemlength[j-1]%>"/>
			<input type="text" name="hsn<%=j%>" value="<%=itemhsncode[j-1]%>" size="5" />
			<input type="text" name="pieces<%=j%>" value="<%=itempieces[j-1]%>"/>
			<input type="text" name="rate<%=j%>" value="<%=itemrate[j-1]%>"/>
			</div>
			<%
		}
	}
	%>
	
	
	<BR><BR>
    
    <center> <input type="button" value="    Modify    " name="Modify" onClick="startSearch();"></center>
  
	</form>


</body>
<SCRIPT language="JavaScript">
var counter = <%=items+1%>;
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
  		document.frm.action="Finalmodification.jsp?counter="+(counter-1);
  		document.frm.submit();
	}

</SCRIPT>
</html>
