<html>

<head>
<title>Old Bills</title>
</head>

<body bgcolor="#CCFFFF">
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
		Calendar now = Calendar.getInstance();
		
		int cMonth = now.get(Calendar.MONTH)+1;
		int YEAR = now.get(Calendar.YEAR);
		if(cMonth <= 4)
			YEAR -= 1;
		String consumerName = "";
		int searchVar = 0;
		
		if(request.getParameter("R1").equals("Consumer"))
		{
			consumerName = request.getParameter("Consumer");
			searchVar = 1;
		}
		if(request.getParameter("R1").equals("Date"))
		{
			YEAR = Integer.parseInt(request.getParameter("year"));
			searchVar = 2;
		}		
		
		String folderLocation = "D:\\GST\\Private Files\\Purchase\\";
		
		
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
						int items = Integer.parseInt(splitted[4]);
						String name = "";
						int impt = splitsize - 5 * items - 2;
						for(int j=5; j < impt; j++)
							name += splitted[j] + " ";
						if(consumerName.equals(name))
							Lines.add(check);
					}
				}
				inFile.close();
			}
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
		

	%>
	
	<center>
	<h2>NANDHINI SAREES</h2>
	<h4>PURCHASE INVOICE DETAILS FOR 
	<%
		if(searchVar==1)
			out.println(consumerName);
		if(searchVar==2)
			out.println(YEAR + "-" + (YEAR+1));
	%></h4>
	</center>
	<form name="frm" method="POST">
	<table border=1 width="100%" align="center">
		<tr>
		<th width="4%" align="center">S.No</th>
		<th width="13%" align="center">GSTIN</th>
		<th width="13%" align="center">Name of Party</th>
		<th width="8%" align="center">Invoice Gross Value</th>
		<th width="8%" align="center">Invoice No.</th>
		<th width="8%" align="center">Date</th>
		<th width="8%" align="center">Invoice Taxable Value</th>
		<th width="6%" align="center">Rate of duty</th>
		<th width="8%" align="center">Tax amount</th>
		<th width="8%" align="center">HSN No.</th>
		<th width="8%" align="center">No. of pieces</th>
		<th width="8%" align="center">Rate of piece</th>
		</tr>
		
		<%
		for(i=(n-1);i>=0;i--)
		{
			%>
			<tr>
				<td rowspan="<%=items[i]%>" align="center"><input type="radio" name="Invoice" value="<%=i%>"></td>
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
				<td rowspan="<%=items[i]%>" align="center"><%
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
	<br>
	<div id="dummy"></div>
	<center><input type="button" value="	MODIFY		" onClick="modify();">
<% //	<input type="button" value="	CANCEL		" onClick="cancel();"> 
%>
</center>
	</form>

</body>
<SCRIPT language="JavaScript">
function modify()
{
	var i;
	var check;
	var dummy = 0;
	for(i=0;i<document.frm.Invoice.length;i++)
	{
		if(document.frm.Invoice[i].checked)
		{
			check = i;
			dummy++;
		}
	}
	var div = document.createElement('div');
	<%
	if(searchVar == 1)
	{
		%>
		div.innerHTML = '<input type="hidden" name="consumer" value="<%=consumerName%>">';
		<%
	}
	else
	{
		%>
		div.innerHTML = '<input type="hidden" name="year" value="<%=YEAR%>">';
		<%
	}
	%>
	document.getElementById('dummy').appendChild(div);
	if(dummy == 0)
	{
		alert("You must select a bill to continue");
		return;
	}
	else
	{
		document.frm.action = "Purchase_Modification.jsp?searchVar=" + <%=searchVar%>;
		document.frm.submit();
	}
}
function cancel()
{
	var i;
	var check;
	var dummy = 0;
	for(i=0;i<document.frm.Invoice.length;i++)
	{
		if(document.frm.Invoice[i].checked)
		{
			check = i;
			dummy++;
		}
	}
	var div = document.createElement('div');
	<%
	if(searchVar == 1)
	{
		%>
		div.innerHTML = '<input type="hidden" name="consumer" value="<%=consumerName%>">';
		<%
	}
	else
	{
		%>
		div.innerHTML = '<input type="hidden" name="year" value="<%=YEAR%>">';
		<%
	}
	%>
	document.getElementById('dummy').appendChild(div);
	if(dummy == 0)
	{
		alert("You must select a bill to continue");
		return;
	}
	else
	{
		document.frm.action = "Cancel.jsp?searchVar=" + <%=searchVar%>;
		document.frm.submit();
	}
}
</SCRIPT>
</html>
