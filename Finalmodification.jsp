<html>
<head>
<title>Print</title>
<style>
table{
    border-collapse: collapse;
}
table.inside {
	border:none;
	border-collapse: collapse;
}
table.inside td {
	border-left: 1px solid black;
	border-right: 1px solid black;
}
</style>
</head>
<body bgcolor="#CCFFFF" onafterprint = "myFunction()">

<%@ page errorPage="errorpage.jsp" language="java"  import="java.sql.*"  %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import = "java.text.*" %>

	<%
		int date =  Integer.parseInt(request.getParameter("date"));
		int month = Integer.parseInt(request.getParameter("month"));
		int year = Integer.parseInt(request.getParameter("year"));
		DecimalFormat df = new DecimalFormat("#.00");
		
		String bookingplace = null;
		if(request.getParameter("booking") != null)
			bookingplace = request.getParameter("bookplace");
		
		int counter = Integer.parseInt(request.getParameter("counter"));
		int bundle = Integer.parseInt(request.getParameter("bundle"));
		String transport = request.getParameter("transport");
		String consumerName = request.getParameter("Consumer");
		int billno = Integer.parseInt(request.getParameter("invoice"));
		String Goods[] = new String[counter];
		int pieces[] = new int[counter];
		int rate[] = new int[counter];
		double length[] = new double[counter];
		String hsn[] = new String[counter];
		int pieces_tot_rate[] = new int[counter];
		double tot_price = 0;
		double cgst = 2.5/100;
		double sgst = 2.5/100;
		double igst = 5./100;
		double net_total;
		int i=0;

		for(i=0; i < counter;i++)
		{
			String x = "goods" + (i+1);
			Goods[i] = request.getParameter(x);
			x = "pieces" + (i+1);
			pieces[i] = Integer.parseInt(request.getParameter(x));
			x = "rate" + (i+1);
			rate[i] = Integer.parseInt(request.getParameter(x));
			x = "hsn" + (i+1);
			hsn[i] = request.getParameter(x);
			x = "length" + (i+1);
			length[i] = Double.parseDouble(request.getParameter(x));
			pieces_tot_rate[i] = pieces[i]*rate[i];
			tot_price += pieces_tot_rate[i];
		}
		
		String folderLocation = "D:\\GST\\Private Files\\Sales\\";
		String consumerfname = "consumer_details.xls";
		String consumerinputname = folderLocation + consumerfname;
		File file = new File(consumerinputname);
		Scanner inFile = new Scanner(file);
		ArrayList<String> Lines = new ArrayList<String>();
		String address = null;
		String state = null;
		int pincode = 0;
		String gst = null;
			
		if(file.exists())
		{
			while(inFile.hasNextLine())
				Lines.add(inFile.nextLine());
			inFile.close();
		}
		
		for(i = 0;i < Lines.size();i++)
		{
			String[] splitted = Lines.get(i).split("\\s+");
			int splitsize = splitted.length;
			String dummy = "";
		
			for(int j=0;j<(splitsize-4);j++)
				 dummy += splitted[j] +" ";
			dummy.trim();
			if(consumerName.equals(dummy))
			{
				address = splitted[splitsize-4];
				state = splitted[splitsize-3];
				pincode = Integer.parseInt(splitted[splitsize-2]);
				gst = splitted[splitsize-1];
			}
		}			

		String billname;
		if(month >= 4)
			billname = year + "_Bills.xls";
		else
			billname = (year-1) + "_Bills.xls";
		String billfilename = folderLocation + billname;
		file = new File(billfilename);
		ArrayList<String> Lines1 = new ArrayList<String>();
		int reqiValue = 0;
		i=0;
		if(file.exists())
		{
			Scanner inFile2 = new Scanner(file);
			while(inFile2.hasNextLine())
			{
				String dummy = inFile2.nextLine();
				String[] splitted = dummy.split("\\s+");
				if(billno == Integer.parseInt(splitted[0]))
					reqiValue = i;
				Lines1.add(dummy);
				i++;
			}
			inFile2.close();
		}

		net_total = tot_price + (tot_price * igst);

 		try
		{
			PrintStream ps = new PrintStream(file);
			for(i=0;i<Lines1.size();i++)
			{
				String[] splitted = Lines1.get(i).split("\\s+");
				if(i!=reqiValue)
				{
					int j;
					for(j=0;j<7;j++)
						ps.print(splitted[j] +"\t");
					int item = Integer.parseInt(splitted[5]);
					int impt = splitted.length - 5 * item -2;
					for(j=7;j<impt;j++)
						ps.print(splitted[j] +" ");
					for(j=impt;j<splitted.length;j++)
						ps.print("\t" + splitted[j]);
					ps.print("\n");
				}
				else
				{
					ps.print(billno +"\t"+ date +"\t"+ month +"\t"+ year +"\t"+ bundle +"\t"+ counter +"\t"+ transport +"\t"+ consumerName +"\t"+ gst + "\t" + state);
					for(int j=0; j < counter;j++)
						ps.print("\t" + Goods[j] +"\t"+ length[j] +"\t"+ hsn[j] +"\t"+ pieces[j] +"\t"+ rate[j]);
					ps.print("\n");
				}
			}
			ps.close();
		}catch(Exception e){out.println(e);} 
		
	%>
	
	<table width="100%" align="center" border="1">

	<tr>
	<td align="left" width="40%">GSTIN No.: 33ANTPL5721D1Z1</td>
	<td align="center" width="20%"><u><b>TAX INVOICE</u></b></td>
	<td align="right" width="40%">Cell: 9150681161</td>
	</tr>
	<tr>
	<td colspan="3" align="center"><font size="6"><b>NANDHINI SAREES</b></font>
	<br>
	Handloom Cloth Merchants
	<br>
	<b>39/55 Vasaga salai 3rd cross, Ponnammapet, Salem, TAMIL NADU - 636001.</b>
	</td>
	</tr>
	</table>

	<table width="100%" align="center" border="1">
	<tr>
	<td width="60%">
	<font size="4">
	To&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=consumerName%><br>
	<%
	if(bookingplace == null)
	{
		%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=address%> - <%=pincode%>.<br>
		   <br><br>
		<%
	}
	else
	{
		%>BOOKING TO &nbsp;&nbsp;&nbsp;&nbsp; <%=bookingplace%> <br>
	EXPORT TO &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <%=address%> - <%=pincode%>.
	<br><br>
		<%
	}
	%>
	GSTIN: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=gst%><br>
	State &nbsp;&nbsp;&nbsp;: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=state%>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Code: <%
	if(state.equals("TAMILNADU"))%>33
	<%
	if(state.equals("KARNATAKA"))%>29
	<%
	if(state.equals("MAHARASHTRA"))%>27
	</font>
	</td>
	<td width="40%">
	<font size="4">
	Invoice No &nbsp;&nbsp;: &nbsp;&nbsp;&nbsp;&nbsp; <%=billno%><br>
	Invoice Date: &nbsp;&nbsp;&nbsp;&nbsp; <%=date%>/<%=month%>/<%=year%><br>
	Order No &nbsp;&nbsp;&nbsp;&nbsp;: &nbsp;&nbsp;&nbsp;&nbsp; <br>
	Bale No	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: &nbsp;&nbsp;&nbsp;&nbsp; <%=bundle%><br>
	Transport &nbsp;&nbsp;&nbsp;&nbsp;: &nbsp;&nbsp;&nbsp;&nbsp; <%=transport%><br>
	L.R.No. &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:	&nbsp;&nbsp;&nbsp;&nbsp;
	</font>
	</td>
	</tr>
	</table>

	<table width="100%" align="center" border="1">
	<tr>
	<th width="6%" align="center">S. No.</th>
	<th width="11%" align="center">METERS</th>
	<th width="37%" align="center">Description of Goods</th>
	<th width="9%" align="center">HSN CODE</th>
	<th width="11%" align="center">No. of Pieces</th>
	<th width="11%" align="center">Rate</th>
	<th width="15%" align="center">Amount</th>
	</tr>
	<table>
	
	<table width="100%" align="center" border="1">
	<%
	for(i=0;i<counter;i++)
	{
		%>
	<tr>
	<td width="6%" align="center"><%=(i+1)%></td>
	<td width="11%" align="center"><%=df.format(length[i])%></td>
	<td width="37%" align="center"><%=Goods[i]%></td>
	<td width="9%" align="center"><%=hsn[i]%></td>
	<td width="11%" align="center"><%=pieces[i]%></td>
	<td width="11%" align="center"><%=rate[i]%></td>
	<td width="15%" align="center"><%=pieces_tot_rate[i]%></td>
	</tr>
	<%
	}%>
	</table>
	
	<table width="100%" align="center" class="inside">
	<%
	for(i=counter;i<=22;i++)
	{%>	
	<tr>
	<td width="6%">&nbsp;</td>
	<td width="11%">&nbsp;</td>
	<td width="37%">&nbsp;</td>
	<td width="9%">&nbsp;</td>
	<td width="11%">&nbsp;</td>
	<td width="11%">&nbsp;</td>
	<td width="15%">&nbsp;</td></tr>
	<%
	}%>
	</table>

	<table width="100%" align="center" border="1">
	<tr>
	<td rowspan="4" width="63%">Total Invoice Amount in Words: <%=convert((int)net_total)%> only</td>
	<td width="22%">Amount before Tax:</td>
	<td width="15%" align="center"><b><%=df.format(tot_price)%></b></td>
	</tr>

	<tr>
	<%
	if(state.equals("TAMILNADU"))
	{
	%><td>Add: CGST&nbsp;&nbsp;(2.5%):</td>
	<td align="center"><b><%=df.format(tot_price*cgst)%></b></td>
	<%
	}
	else
	{
		%><td>Add: CGST&nbsp;&nbsp;(Nil):</td>
	<td>&nbsp;</td>
	<%}%>
	</tr>

	<tr>
	<%
	if(state.equals("TAMILNADU"))
	{
	%><td>Add: SGST&nbsp;&nbsp;(2.5%):</td>
	<td align="center"><b><%=df.format(tot_price*sgst)%></b></td>
	<%
	}
	else
	{
		%><td>Add: SGST&nbsp;&nbsp;(Nil):</td>
	<td>&nbsp;</td>
	<%}%>
	</tr>

	<tr>
	<%
	if(state.equals("TAMILNADU"))
	{
	%><td>Add: IGST&nbsp;&nbsp;(Nil):</td>
	<td>&nbsp;</td>
	<%
	}
	else
	{
		%><td>Add: IGST&nbsp;&nbsp;(5%):</td>
	<td align="center"><b><%=df.format(tot_price*igst)%></b></td>
	<%}%>
	</tr>

	</table>

	<table width="100%" align="center" border="1">
	<tr>
	<td rowspan="5" width="42%"><u>Bank Details</u>&nbsp;: &nbsp;&nbsp;&nbsp;NANDHINI SAREES <br>
	Bank Name&nbsp;&nbsp;&nbsp;: &nbsp;&nbsp;&nbsp;City Union Bank<br>
	A/c No.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: &nbsp;&nbsp;&nbsp;510909010071388<br>
	IFSC code&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: &nbsp;&nbsp;&nbsp;CIUB0000042<br>
	Branch&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: &nbsp;&nbsp;&nbsp;Salem Main
	</td>
	<td width="21%" rowspan="5"></td>
	<td width="22%">NET TOTAL:</td>
	<td width="15%" align="center"><b><%=df.format(net_total)%></b></td>
	</tr>
	<tr>
	<td>GST Reverse Charge:</td>
	<td></td>
	</tr>
	<tr>
	<td colspan="2" rowspan="3" align="center">
	For NANDHINI SAREES<br>
	<br>
	Authorised Signatory
	</td>
	</tr>
	</table>

	<%! 	public String convert(int n) {
		
			String[] units = { "", "One", "Two", "Three", "Four",
				"Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve",
				"Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen",
				"Eighteen", "Nineteen" };

		String[] tens = { 
				"", 		// 0
				"",		// 1
				"Twenty", 	// 2
				"Thirty", 	// 3
				"Forty", 	// 4
				"Fifty", 	// 5
				"Sixty", 	// 6
				"Seventy",	// 7
				"Eighty", 	// 8
				"Ninety" 	// 9
		};
		
		
			if (n < 0) {
				return "Minus " + convert(-n);
			}

			if (n < 20) {
				return units[n];
			}

			if (n < 100) {
				return tens[n / 10] + ((n % 10 != 0) ? " " : "") + units[n % 10];
			}

			if (n < 1000) {
				return units[n / 100] + " Hundred" + ((n % 100 != 0) ? " " : "") + convert(n % 100);
			}

			if (n < 100000) {
				return convert(n / 1000) + " Thousand" + ((n % 10000 != 0) ? " " : "") + convert(n % 1000);
			}

			if (n < 10000000) {
				return convert(n / 100000) + " Lakh" + ((n % 100000 != 0) ? " " : "") + convert(n % 100000);
			}

			return convert(n / 10000000) + " Crore" + ((n % 10000000 != 0) ? " " : "") + convert(n % 10000000);
		}
	%>
	
<SCRIPT language="JavaScript">
print();
function myFunction() {
	location.href = "home.htm";
}
</SCRIPT>
</body>
</html>
