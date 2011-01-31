<%--

    Copyright (C) 2000 - 2009 Silverpeas

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    As a special exception to the terms and conditions of version 3.0 of
    the GPL, you may redistribute this Program in connection with Free/Libre
    Open Source Software ("FLOSS") applications as described in Silverpeas's
    FLOSS exception.  You should have recieved a copy of the text describing
    the FLOSS exception, and it is also available here:
    "http://repository.silverpeas.com/legal/licensing"

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

--%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="check.jsp" %>

<% 
	// r�cup�ration des param�tres :
	String 		albumId			= (String) request.getAttribute("AlbumId");
	List  	path 			= (List) request.getAttribute("Path");
	Form 		formUpdate 		= (Form) request.getAttribute("Form");
	DataRecord	data			= (DataRecord) request.getAttribute("Data");
	String		searchKeyWord	= (String) request.getAttribute("SearchKeyWord");
		
	// d�claration des variables :
	String 		title 				= "";
	String 		description 		= "";
	String 		author 				= "";
	boolean 	download 			= false;
	String		beginDownloadDate	= "";
	String		endDownloadDate		= "";
	String 		keyWord 			= "";
	String 		beginDate			= "";
	String 		endDate				= "";
	
	PagesContext 		context 	= new PagesContext("photoForm", "0", resource.getLanguage(), false, componentId, gallerySC.getUserId(), gallerySC.getAlbum(gallerySC.getCurrentAlbumId()).getNodePK().getId()); //Pas de passage de l'objectId dans le contexte car on est en traitement par lot, ce passage se fera lors de la validation du formulaire
	context.setBorderPrinted(false);
	context.setCurrentFieldIndex("10");
	context.setUseBlankFields(true);
	context.setUseMandatory(false);
		
	// d�claration des boutons
	Button validateButton = (Button) gef.getFormButton(resource.getString("GML.validate"), "javascript:onClick=sendData();", false);
	Button cancelButton;
	if (albumId != null && !albumId.equals("") &&  !albumId.equals("null"))
		cancelButton   = (Button) gef.getFormButton(resource.getString("GML.cancel"), "GoToCurrentAlbum?AlbumId="+albumId, false);
	else
		cancelButton   = (Button) gef.getFormButton(resource.getString("GML.cancel"), "SearchKeyWord?SearchKeyWord="+searchKeyWord, false);
%>

<html>
<head>
	<%
		out.println(gef.getLookStyleSheet());
	%>
	<script type="text/javascript" src="<%=m_context%>/wysiwyg/jsp/FCKeditor/fckeditor.js"></script>
	<script type="text/javascript" src="<%=m_context%>/util/javaScript/animation.js"></script>
	<script type="text/javascript" src="<%=m_context%>/util/javaScript/dateUtils.js"></script>
	<script type="text/javascript" src="<%=m_context%>/util/javaScript/checkForm.js"></script>
	<% if (formUpdate != null) { 
		formUpdate.displayScripts(out, context);
	} %>
	<script language="javascript">
	
	// fonctions de contr�le des zones du formulaire avant validation
	function sendData() 
	{
		<% if (formUpdate != null) { %>
			if (isCorrectHeaderForm() && isCorrectForm())
			{
	       		document.photoForm.submit();
			}
		<% } else { %>
			if (isCorrectHeaderForm())
			{
	       		document.photoForm.submit();
			}
		<% } %>
	}
		
	function isCorrectHeaderForm() 
	{
     	var errorMsg = "";
     	var errorNb = 0;
     	var title = stripInitialWhitespace(document.photoForm.Im$Title.value);
     	var descr = document.photoForm.Im$Description.value;
     	var beginDownloadDate = document.photoForm.Im$BeginDownloadDate.value;
     	var endDownloadDate = document.photoForm.Im$EndDownloadDate.value;
     	var beginDate = document.photoForm.Im$BeginDate.value;
     	var endDate = document.photoForm.Im$EndDate.value;
     	var langue = "<%=resource.getLanguage()%>";
     	var re = /(\d\d\/\d\d\/\d\d\d\d)/i;
		     	
		var yearDownloadBegin = extractYear(beginDownloadDate, langue);
		var monthDownloadBegin = extractMonth(beginDownloadDate, langue);
		var dayDownloadBegin = extractDay(beginDownloadDate, langue);
		var yearDownloadEnd = extractYear(endDownloadDate, langue);
		var monthDownloadEnd = extractMonth(endDownloadDate, langue);
		var dayDownloadEnd = extractDay(endDownloadDate, langue);
		var yearBegin = extractYear(beginDate, langue);
		var monthBegin = extractMonth(beginDate, langue);
		var dayBegin = extractDay(beginDate, langue);
		var yearEnd = extractYear(endDate, langue);
		var monthEnd = extractMonth(endDate, langue);
		var dayEnd = extractDay(endDate, langue);
     					
		var beginDownloadDateOK = true;
		var beginDateOK = true;
		     	
     	if (title.length > 255) 
     	{ 
			errorMsg+="  - '<%=resource.getString("GML.title")%>'  <%=resource.getString("gallery.MsgTaille")%>\n";
           	errorNb++;
     	}
   		if (descr.length > 255) 
     	{
     		errorMsg+="  - '<%=resource.getString("GML.description")%>'  <%=resource.getString("gallery.MsgTaille")%>\n";
           	errorNb++;
     	}				
     	// v�rifier les dates de d�but et de fin de p�riode
     	// les dates de t�l�chargements
     	if (!isWhitespace(beginDownloadDate)) 
     	{
   			if (beginDownloadDate.replace(re, "OK") != "OK") 
   			{
       			errorMsg+="  - '<%=resource.getString("gallery.dateBegin")%>' <%=resource.getString("GML.MustContainsCorrectDate")%>\n";
       			errorNb++;
	   			beginDownloadDateOK = false;
   			} 
   			else 
   			{
	   			if (isCorrectDate(yearDownloadBegin, monthDownloadBegin, dayDownloadBegin)==false) 
	   			{
	       			errorMsg+="  - '<%=resource.getString("GML.dateBegin")%>' <%=resource.getString("GML.MustContainsCorrectDate")%>\n";
	       			errorNb++;
		 			beginDownloadDateOK = false;
	   			}
			}
   		}
	    if (!isWhitespace(endDownloadDate)) 
	    {
	        if (endDownloadDate.replace(re, "OK") != "OK") 
	        {
	             errorMsg+="  - '<%=resource.getString("GML.dateEnd")%>' <%=resource.getString("GML.MustContainsCorrectDate")%>\n";
	             errorNb++;
	        } 
	        else 
	        {
	            if (isCorrectDate(yearDownloadEnd, monthDownloadEnd, dayDownloadEnd)==false) 
	            {
	                errorMsg+="  - '<%=resource.getString("GML.dateEnd")%>' <%=resource.getString("GML.MustContainsCorrectDate")%>\n";
	                errorNb++;
	            } 
	            else 
	            {
	                if ((isWhitespace(beginDownloadDate) == false) && (isWhitespace(endDownloadDate) == false)) 
	                {
	                    if (beginDownloadDateOK && isD1AfterD2(yearDownloadEnd, monthDownloadEnd, dayDownloadEnd, yearDownloadBegin, monthDownloadBegin, dayDownloadBegin) == false) 
	                    {
	                         errorMsg+="  - '<%=resource.getString("GML.dateEnd")%>' <%=resource.getString("GML.MustContainsPostOrEqualDateTo")%> "+beginDownloadDate+"\n";
	                         errorNb++;
	                    }
	                } 
	                else 
	                {
					   if ((isWhitespace(beginDownloadDate) == true) && (isWhitespace(endDownloadDate) == false)) 
					   {
						   if (isFutureDate(yearDownloadEnd, monthDownloadEnd, dayDownloadEnd) == false) 
						   {
							  errorMsg+="  - '<%=resource.getString("GML.dateEnd")%>' <%=resource.getString("GML.MustContainsPostDate")%>\n";
							  errorNb++;
						   }
					   }
					}
			    }
			}
		}		
		// les dates de visibilit�
		if (!isWhitespace(beginDate)) 
		{
			if (beginDate.replace(re, "OK") != "OK") 
			{
				errorMsg+="  - '<%=resource.getString("GML.dateBegin")%>' <%=resource.getString("GML.MustContainsCorrectDate")%>\n";
			    errorNb++;
				beginDateOK = false;
			} 
			else 
			{
				if (isCorrectDate(yearBegin, monthBegin, dayBegin)==false) 
				{
					errorMsg+="  - '<%=resource.getString("GML.dateBegin")%>' <%=resource.getString("GML.MustContainsCorrectDate")%>\n";
					errorNb++;
					beginDateOK = false;
			    }
			}
	    }
		if (!isWhitespace(endDate)) 
		{
		    if (endDate.replace(re, "OK") != "OK") 
		    {
		        errorMsg+="  - '<%=resource.getString("GML.dateEnd")%>' <%=resource.getString("GML.MustContainsCorrectDate")%>\n";
		        errorNb++;
		    } 
		    else 
		    {
		        if (isCorrectDate(yearEnd, monthEnd, dayEnd)==false) 
		        {
		             errorMsg+="  - '<%=resource.getString("GML.dateEnd")%>' <%=resource.getString("GML.MustContainsCorrectDate")%>\n";
		             errorNb++;
		        } 
		        else 
		        {
		             if ((isWhitespace(beginDate) == false) && (isWhitespace(endDate) == false)) 
		             {
		                  if (beginDateOK && isD1AfterD2(yearEnd, monthEnd, dayEnd, yearBegin, monthBegin, dayBegin) == false) 
		                  {
		                       errorMsg+="  - '<%=resource.getString("GML.dateEnd")%>' <%=resource.getString("GML.MustContainsPostOrEqualDateTo")%> "+beginDate+"\n";
		                       errorNb++;
		                  }
		             } 
		             else 
		             {
		            	 if ((isWhitespace(beginDate) == true) && (isWhitespace(endDate) == false)) 
						 {
		            		 if (isFutureDate(yearEnd, monthEnd, dayEnd) == false) 
							 {
								  errorMsg+="  - '<%=resource.getString("GML.dateEnd")%>' <%=resource.getString("GML.MustContainsPostDate")%>\n";
								  errorNb++;
						     }
				         }
					}
				}
			}
		}				
     	switch(errorNb) 
     	{
        	case 0 :
            	result = true;
            	break;
        	case 1 :
            	errorMsg = "<%=resource.getString("GML.ThisFormContains")%> 1 <%=resource.getString("GML.error")%> : \n" + errorMsg;
            	window.alert(errorMsg);
            	result = false;
            	break;
        	default :
            	errorMsg = "<%=resource.getString("GML.ThisFormContains")%> " + errorNb + " <%=resource.getString("GML.errors")%> :\n" + errorMsg;
            	window.alert(errorMsg);
            	result = false;
            	break;
	    } 
	    return result;
	}
	</script>
		
</head>
<body class="yui-skin-sam" onLoad="javascript:document.photoForm.Im$Title.focus();">
<%
	browseBar.setDomainName(spaceLabel);
	browseBar.setComponentName(componentLabel, "Main");
	displayPath(path, browseBar);
	
	Board board	= gef.getBoard();
	
	out.println(window.printBefore());
    out.println(frame.printBefore());
%>
<FORM Name="photoForm" action="UpdateSelectedPhoto" Method="POST" ENCTYPE="multipart/form-data">
	<%=board.printBefore()%>
	<!-- Affichage des donn�es ent�te -->
	<table cellpadding="5">
		<tr>
			<td class="txtlibform"><%=resource.getString("GML.title")%> :</td>
			<TD><input type="text" name="Im$Title" size="60" maxlength="150" value="<%=title%>">
				<input type="hidden" name="Im$SearchKeyWord" value="<%=searchKeyWord%>"></td>
		</tr>
		<tr>
			<td class="txtlibform"><%=resource.getString("GML.description")%> :</td>
			<TD><input type="text" name="Im$Description" size="60" maxlength="150" value="<%=description%>"></TD>
		</tr>
		<tr>
			<td class="txtlibform"><%=resource.getString("GML.author")%> :</td>
			<TD><input type="text" name="Im$Author" size="60" maxlength="150" value="<%=author%>"></TD>
		</tr>
		<tr>
			<td class="txtlibform"><%=resource.getString("gallery.keyWord")%> :</td>
			<TD><input type="text" name="Im$KeyWord" size="60" maxlength="150" value="<%=keyWord%>"></TD>
		</tr>
		<tr>
			<td class="txtlibform"><%=resource.getString("gallery.download")%> :</td>
			<%
				String downloadCheck = "";
				if (download)
					downloadCheck = "checked";
			%>
		    <td><input type="checkbox" name="Im$Download" value="true" <%=downloadCheck%>></td>
		</tr>
		<tr>
			<td class="txtlibform"><%=resource.getString("gallery.beginDownloadDate")%> :</td>
			<td><input type="text" class="dateToPick" name="Im$BeginDownloadDate" size="12" maxlength="10" value="<%=beginDownloadDate%>"/></td>
		</tr>
		<tr>
			<td class="txtlibform"><%=resource.getString("gallery.endDownloadDate")%> :</td>
			<td><input type="text" class="dateToPick" name="Im$EndDownloadDate" size="12" maxlength="10" value="<%=endDownloadDate%>"/></td>
		</tr>
		<tr>
			<td class="txtlibform"><%=resource.getString("gallery.beginDate")%> :</td>
			<td><input type="text" class="dateToPick" name="Im$BeginDate" size="12" maxlength="10" value="<%=beginDate%>"/></td>
		</tr>
		<tr>
			<td class="txtlibform"><%=resource.getString("gallery.endDate")%> :</td>
			<td><input type="text" class="dateToPick" name="Im$EndDate" size="12" maxlength="10" value="<%=endDate%>"/>&nbsp;</td>
		</tr>
	</table>
	<%=board.printAfter()%>

<% if (formUpdate != null) { %>
<!-- Affichage du formulaire XML -->
	<br/>
	<%=board.printBefore()%>
	<table><tr><td>
	<% 
		formUpdate.display(out, context, data); 
	%>
	</td></tr></table>
	<%=board.printAfter()%>
<% } %>
</form>

<% 
	ButtonPane buttonPane = gef.getButtonPane();
    buttonPane.addButton(validateButton);
    buttonPane.addButton(cancelButton);
	out.println("<BR><center>"+buttonPane.print()+"</center><BR>");
 	out.println(frame.printAfter());
	out.println(window.printAfter());
%>

</body>
</html>