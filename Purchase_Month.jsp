<html>

<head>
<title>Month chart preparation</title>
</head>

<body bgcolor="#CCFFFF" onafterprint="myFunction()">
<BR>
<style>
table{
    border: 1px solid black;
    border-collapse: collapse;
}

</style>

	<%@ page errorPage="errorpage.jsp" language="java"  import="java.sql.*"  %>
	<%@ page import="java.io.*" %>
	<%@ page import="java.util.*" %>
	<%@ page import = "java.text.*" %>
	
	<%
		DecimalFormat df = new DecimalFormat("#.00");
		
		int YEAR = Integer.parseInt(request.getParameter("year"));
		int MONTH = Integer.parseInt(request.getParameter("month"));
		
		String folderLocation = "D:\\GST\\Private Files\\Purchase\\";
		String billname;
		if(MONTH >= 4)
			billname = YEAR + "_Bills.xls";
		else
			billname = (YEAR-1) + "_Bills.xls";
		String billfilename = folderLocation + billname;
		File file = new File(billfilename);
		Scanner inFile = new Scanner(file);
		
		ArrayList<String> Lines = new ArrayList<String>();
		int i=0;
		
		if(file.exists())
		{
			while(inFile.hasNextLine())
			{
				String dummy = inFile.nextLine();
				String[] splitted = dummy.split("\\s+");
				if(Integer.parseInt(splitted[2])==MONTH && Integer.parseInt(splitted[3])==YEAR)
					Lines.add(dummy);
			}
			inFile.close();
		}
		int n = Lines.size();
		
		int billno[] = new int[n];
		int date[] = new int[n];
		int month[] = new int[n];
		int year[] = new int[n];
		int items[] =new int[n];
		String name[] = new String[n];
		String gst[] = new String[n];
		String state[] = new String[n];
		String itemname[][] = new String[n][20];
		double itemlength[][] = new double[n][20];
		int itemhsncode[][] = new int[n][20];
		int itempieces[][] = new int[n][20];
		int itemrate[][] = new int[n][20];
		double invoicegrossvalue[] = new double[n];
		int invoicetaxablevalue[] = new int[n];
		double taxvalue[] = new double[n];
		
		for(i = 0; i < n; i++)
		{
			String[] splitted = Lines.get(i).split("\\s+");
			int splitsize = splitted.length;

			billno[i] = Integer.parseInt(splitted[0]);
			date[i] = Integer.parseInt(splitted[1]);
			month[i] = Integer.parseInt(splitted[2]);
			year[i] = Integer.parseInt(splitted[3]);
			items[i] = Integer.parseInt(splitted[4]);
			name[i] = "";
			int impt = splitsize - 5 * items[i] - 2;
			for(int j=5; j < impt; j++)
				name[i] += splitted[j] + " ";
			gst[i] = splitted[impt];
			state[i] = splitted[impt+1];
			invoicetaxablevalue[i]=0;
			for(int j=1; j<=items[i];j++)
			{
				itemname[i][j-1] = splitted[impt+(j-1)*5+2];
				itemlength[i][j-1] = Double.parseDouble(splitted[impt+(j-1)*5+3]);
				itemhsncode[i][j-1] = Integer.parseInt(splitted[impt+(j-1)*5+4]);
				itempieces[i][j-1] = Integer.parseInt(splitted[impt+(j-1)*5+5]);
				itemrate[i][j-1] = (int)Math.round(Double.parseDouble(splitted[impt+(j-1)*5+6]));
				invoicetaxablevalue[i] += itempieces[i][j-1] * itemrate[i][j-1];
			}
			if(itemname[i][0].equals("Kraft"))
				taxvalue[i] = 0.12 * invoicetaxablevalue[i];
			else
				taxvalue[i] = 0.05 * invoicetaxablevalue[i];
			if(gst[i].equals("N/A"))
				taxvalue[i] = 0;
			invoicegrossvalue[i] = invoicetaxablevalue[i] + taxvalue[i];
		}
		
		String monthchartfolder = "D:\\GST\\PURCHASES\\Month Charts\\";

		String monthname;
		if(MONTH == 1)
			monthname = "JANUARY";
		else if(MONTH == 2)
			monthname = "FEBRUARY";
		else if(MONTH == 3)
			monthname = "MARCH";
		else if(MONTH == 4)
			monthname = "APRIL";
		else if(MONTH == 5)
			monthname = "MAY";
		else if(MONTH == 6)
			monthname = "JUNE";
		else if(MONTH == 7)
			monthname = "JULY";
		else if(MONTH == 8)
			monthname = "AUGUST";
		else if(MONTH == 9)
			monthname = "SEPTEMBER";
		else if(MONTH == 10)
			monthname = "OCTOBER";
		else if(MONTH == 11)
			monthname = "NOVEMBER";
		else
			monthname = "DECEMBER";
		
		String monthfilename = "PURCHASE_" + YEAR + "_" + monthname + ".xls";
		String outputfilename = monthchartfolder  + monthfilename;
		
		try
		{
			PrintStream ps = new PrintStream(new File(outputfilename));
			ps.println("GST No.\tName of Party\tInvoice Gross Value\tInvoie No\tDate\tInvoice taxable Value\tRate of duty\tTax amount\tHSN No\tNo. of pieces\tRate of piece");
			for(i=0;i<n;i++)
			{
				if(items[i]==1)
				{
					if(gst[i].equals("N/A"))
					{
						ps.println(gst[i] +"\t"+ name[i] +"\t"+ df.format(invoicegrossvalue[i])  +"\t"+ billno[i] +"\t"+ date[i]+"/"+month[i]+"/"+year[i] +"\t"+ invoicetaxablevalue[i] +"\t"+ "Nil" +"\t"+ df.format(taxvalue[i]) +"\t"+ itemhsncode[i][0] +"\t"+ itempieces[i][0] +"\t"+ itemrate[i][0]);
					}
					else
					{
						if(itemname[i][0].equals("Kraft"))
							ps.println(gst[i] +"\t"+ name[i] +"\t"+ df.format(invoicegrossvalue[i])  +"\t"+ billno[i] +"\t"+ date[i]+"/"+month[i]+"/"+year[i] +"\t"+ invoicetaxablevalue[i] +"\t"+ "12%" +"\t"+ df.format(taxvalue[i]) +"\t"+ itemhsncode[i][0] +"\t"+ itempieces[i][0] +"\t"+ itemrate[i][0]);
						else
							ps.println(gst[i] +"\t"+ name[i] +"\t"+ df.format(invoicegrossvalue[i])  +"\t"+ billno[i] +"\t"+ date[i]+"/"+month[i]+"/"+year[i] +"\t"+ invoicetaxablevalue[i] +"\t"+ "5%" +"\t"+ df.format(taxvalue[i]) +"\t"+ itemhsncode[i][0] +"\t"+ itempieces[i][0] +"\t"+ itemrate[i][0]);
					}
				}
				else
				{
					if(gst[i].equals("N/A"))
					{
						ps.println(gst[i] +"\t"+ name[i] +"\t"+ df.format(invoicegrossvalue[i])  +"\t"+ billno[i] +"\t"+ date[i]+"/"+month[i]+"/"+year[i] +"\t"+ invoicetaxablevalue[i] +"\t"+ "Nil" +"\t"+ df.format(taxvalue[i]) +"\t"+ itemhsncode[i][0] +"\t"+ itempieces[i][0] +"\t"+ itemrate[i][0]);
						for(int j=2;j<=items[i];j++)
							ps.println("\t\t\t\t\t\t\t\t\t"+ itempieces[i][j-1] +"\t"+ itemrate[i][j-1]);
					}
					else
					{
						if(itemname[i][0].equals("Kraft"))
							ps.println(gst[i] +"\t"+ name[i] +"\t"+ df.format(invoicegrossvalue[i])  +"\t"+ billno[i] +"\t"+ date[i]+"/"+month[i]+"/"+year[i] +"\t"+ invoicetaxablevalue[i] +"\t"+ "12%" +"\t"+ df.format(taxvalue[i]) +"\t"+ itemhsncode[i][0] +"\t"+ itempieces[i][0] +"\t"+ itemrate[i][0]);
						else
							ps.println(gst[i] +"\t"+ name[i] +"\t"+ df.format(invoicegrossvalue[i])  +"\t"+ billno[i] +"\t"+ date[i]+"/"+month[i]+"/"+year[i] +"\t"+ invoicetaxablevalue[i] +"\t"+ "5%" +"\t"+ df.format(taxvalue[i]) +"\t"+ itemhsncode[i][0] +"\t"+ itempieces[i][0] +"\t"+ itemrate[i][0]);
						for(int j=2;j<=items[i];j++)
							ps.println("\t\t\t\t\t\t\t\t\t"+ itempieces[i][j-1] +"\t"+ itemrate[i][j-1]);
					}
				}
			}
			ps.close();
		}catch(Exception e){out.println(e);}
	%>
	
	<center>
	<h2>NANDHINI SAREES</h2>
	<h4>PURCHASE INVOICE DETAILS FOR <%=monthname%> <%=YEAR%></h4>
	</center>
	
	<table border=1 width="100%" align="center">
		<tr>
		<th width="15%" align="center">GSTIN</td>
		<th width="15%" align="center">Name of Party</td>
		<th width="8%" align="center">Invoice Gross Value</td>
		<th width="8%" align="center">Invoice No.</td>
		<th width="8%" align="center">Date</td>
		<th width="8%" align="center">Invoice Taxable Value</td>
		<th width="6%" align="center">Rate of duty</td>
		<th width="8%" align="center">Tax amount</td>
		<th width="8%" align="center">HSN No.</td>
		<th width="8%" align="center">No. of pieces</td>
		<th width="8%" align="center">Rate of piece</td>
		</tr>
		
		<%
		for(i=0;i<n;i++)
		{
			%>
			<tr>
				<td rowspan="<%=items[i]%>" align="center"><%=gst[i]%></td>
				<td rowspan="<%=items[i]%>" align="center"><%=name[i]%></td>
				<td rowspan="<%=items[i]%>" align="center"><%=df.format(invoicegrossvalue[i])%></td>
				<td rowspan="<%=items[i]%>" align="center"><%
				if(billno[i] == -1)
					out.print("N/A");
				else
					out.print(billno[i]);%></td>
				<td rowspan="<%=items[i]%>" align="center"><%=date[i]%>/<%=month[i]%>/<%=year[i]%></td>
				<td rowspan="<%=items[i]%>" align="center"><%=invoicetaxablevalue[i]%></td>
				<td rowspan="<%=items[i]%>" align="center">
				<%
				if(gst[i].equals("N/A"))
				{
					%>Nil<%
				}
				else
				{
					if(state[i].equals("TAMILNADU"))
					{
						if(itemname[i][0].equals("Kraft"))
						{
							%>6%<br>6%
						<%
						}
						else
						{
							%>2.5%<br>2.5%
						<%
						}
					}
					else
					{
						%>5%
						<%
					}
				}%>
				</td>
				<td rowspan="<%=items[i]%>" align="center">
				<%
				if(gst[i].equals("N/A"))
				{
					%>Nil<%
				}
				else
				{
					if(state[i].equals("TAMILNADU"))
					{
						%><%=df.format(taxvalue[i]/2)%><br><%=df.format(taxvalue[i]/2)%>
					<%
					}
					else
					{
						%><%=df.format(taxvalue[i])%>
						<%
					}
				}
				%>
				</td>
				<td align="center"><%=itemhsncode[i][0]%></td>
				<td align="center"><%=itempieces[i][0]%></td>
				<td align="center"><%=itemrate[i][0]%></td>
			</tr>
			<%
				for(int j=2;j<=items[i];j++)
				{
					%>
					<tr>
					<td align="center"><%=itemhsncode[i][j-1]%></td>
					<td align="center"><%=itempieces[i][j-1]%></td>
					<td align="center"><%=itemrate[i][j-1]%></td>
					</tr>
					<%
				}
		}
		%>
				
	</table>
</body>
<SCRIPT language="JavaScript">
print();
function myFunction() {
	location.href = "home.htm";
}
</SCRIPT>
</html>
