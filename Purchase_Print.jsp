<html>
<head>
<title>Print</title>
<style>
table{
    border: 1px solid black;
    border-collapse: collapse;
}

</style>
</head>
<body bgcolor="#CCFFFF">

<%@ page errorPage="errorpage.jsp" language="java"  import="java.sql.*"  %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import = "java.text.*" %>

	<%
		int date =  Integer.parseInt(request.getParameter("date"));
		int month = Integer.parseInt(request.getParameter("month"));
		int year = Integer.parseInt(request.getParameter("year"));
		DecimalFormat df = new DecimalFormat("#.00");
		int counter = Integer.parseInt(request.getParameter("counter"));
		String consumerName = request.getParameter("Consumer");
		String Goods[] = new String[counter];
		int pieces[] = new int[counter];
		double rate[] = new double[counter];
		double length[] = new double[counter];
		String hsn[] = new String[counter];
		double pieces_tot_rate[] = new double[counter];
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
			rate[i] = Double.parseDouble(request.getParameter(x));
			x = "hsn" + (i+1);
			hsn[i] = request.getParameter(x);
			x = "length" + (i+1);
			length[i] = Double.parseDouble(request.getParameter(x));
			pieces_tot_rate[i] = pieces[i]*rate[i];
			tot_price += pieces_tot_rate[i];
		}
		
		String folderLocation = "D:\\GST\\Private Files\\Purchase\\";
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
		if(Goods[0].equals("Kraft"))
		{
			cgst = 6.0/100;
			sgst = 6.0/100;
			igst = 12.0/100;
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
		
		if(consumerName.equals("unGST"))
		{
			consumerName = request.getParameter("ungstname");
			address = null;
			state = "TAMILNADU";
			pincode = 0;
			gst = "N/A";
		}
		
		int billno = Integer.parseInt(request.getParameter("invoice"));
		String billname;
		if(month >= 4)
			billname = year + "_Bills.xls";
		else
			billname = (year-1) + "_Bills.xls";
		String billfilename = folderLocation + billname;
		file = new File(billfilename);
		
		net_total = tot_price + (tot_price * igst);
		
		try
		{
			FileWriter fw = new FileWriter(billfilename,true);
			fw.write(billno +"\t"+ date +"\t"+ month +"\t"+ year +"\t"+ counter +"\t"+ consumerName +"\t"+ gst +"\t" + state);
			for(i=0; i < counter;i++)
				fw.write("\t" + Goods[i] +"\t"+ length[i] +"\t"+ hsn[i] +"\t"+ pieces[i] +"\t"+ rate[i]);
			fw.write("\n");
			fw.close();
		}catch(Exception e){out.println(e);}
		response.sendRedirect("home.htm");
	%>


</body>
</html>
