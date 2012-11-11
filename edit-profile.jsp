<%-- 
    Document   : edit-profile
    Created on : Nov 8, 2012, 12:18:27 AM
    Author     : om
--%>
<%@page import="java.lang.String"%>
<% if(session.getAttribute("isSessionSet")==null){
    response.sendRedirect("index.jsp");
    }
%>
<%@include file="includes/connection.jsp" %>
<%@page import="com.mysql.jdbc.exceptions.jdbc4.MySQLIntegrityConstraintViolationException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<% String title="Job Portal | Edit Profile";%>
<% if(request.getMethod()=="POST"){ 
      try{
%>
   <%@ page import="java.util.List" %>
   <%@ page import="java.util.Iterator" %>
   <%@ page import="java.io.File" %>
   <%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
   <%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
   <%@ page import="org.apache.commons.fileupload.*"%>
<%
          String fname = "";
          String lname = "";
          String qualification = "";
          String skills = "";
          String work_ex = "";
          String address = "";
          String city = "";
          String country = "";
          String picture = "";
          String resume_url = "";
          out.print(fname);
          try{
              Statement stmt = con.createStatement();
             // String query1 = "insert into individual(fname,lname,qualification,skills,work_ex,address,city,country) value('"+fname+"', '"+lname+"', '"+qulification+"', '"+skills+"', '"+work_ex+"', '"+address+"', '"+city+"', '"+country+"');";
             // stmt.executeUpdate(query1);
              stmt.close();
          }
          catch(Exception e){
                  e.printStackTrace();
          }
          boolean isMultipart = ServletFileUpload.isMultipartContent(request);
          if(isMultipart){
              FileItemFactory factory = new DiskFileItemFactory();              
              ServletFileUpload upload = new ServletFileUpload(factory);
              List items = null;
              try{
                items = upload.parseRequest(request);
              }
              catch(Exception e){
                  e.printStackTrace();
              }
              Iterator iterator = items.iterator();
              while(iterator.hasNext()){
                  FileItem item = (FileItem) iterator.next();
                  if(item.isFormField()){
                //     out.print(item.getFieldName());
                     if(item.getFieldName().equalsIgnoreCase("fname")) {
                         fname=item.getString();
                     }
                     else if(item.getFieldName().equalsIgnoreCase("lname")) {
                         lname=item.getString();
                     }
                     else if(item.getFieldName().equalsIgnoreCase("qualification")) {
                         qualification=item.getString();
                     }
                     else if(item.getFieldName().equalsIgnoreCase("skills")) {
                         skills=item.getString();
                     }
                     else if(item.getFieldName().equalsIgnoreCase("work_ex")) {
                         work_ex=item.getString();
                     }
                     else if(item.getFieldName().equalsIgnoreCase("address")) {
                         address=item.getString();
                     }
                     else if(item.getFieldName().equalsIgnoreCase("city")) {
                         city=item.getString();
                     }
                     else if(item.getFieldName().equalsIgnoreCase("country")) {
                         country=item.getString();
                     }
                  }
                  else{
                      String fileName = item.getName();
                      String fileType = item.getContentType();
                     // out.print(fileType);
                      if(fileType.toLowerCase().contains("pdf")){
                           File savedFile = new File(config.getServletContext().getRealPath("/")+"uploads/ind/resumes/"+session.getAttribute("userId").toString()+fname+".pdf");
			   item.write(savedFile); 
                           resume_url=session.getAttribute("userId").toString()+fname+".pdf";
                      }
                      else if(fileType.toLowerCase().contains("jpg")||fileType.toLowerCase().contains("jpeg")||fileType.toLowerCase().contains("png")) {
                           picture = session.getAttribute("userId").toString()+fname+"."+fileType.split("/")[1];
                           File savedFile = new File(config.getServletContext().getRealPath("/")+"uploads/ind/pics/"+picture);
                           item.write(savedFile); 
                           out.print(picture);
                          // picture="uploads/ind/resumes/"+session.getAttribute("userId").toString()+fname+fileType;
                      }
                        //out.print("hello"+picture);
                      
                  }
              }
          }
          try{
              Statement stmt = con.createStatement();
              try{
//              out.print("hello"+fname+lname+skills);
              String query="update individual set fname='"+fname+"', lname='"+lname+"', qualification='"+qualification+"', skills='"+skills+"', work_ex='"+work_ex+"', address='"+address+"', city='"+city+"', country='"+country+"' where id="+session.getAttribute("userId");
              stmt.executeUpdate(query);
                           }
              catch(Exception e){
                  out.print(e.toString());
              }
            if(!picture.equalsIgnoreCase("")){                            
                String query1 = "update individual set photograph='"+picture+"' where id="+session.getAttribute("userId");
                stmt.executeUpdate(query1);                             
             }
             if(!resume_url.equalsIgnoreCase("")){                          
                String query1 = "update individual set resume_url='"+resume_url+"' where id="+session.getAttribute("userId");
                stmt.executeUpdate(query1);               
             } 
              stmt.close();
          }                 
          catch(Exception e){
            out.print(e.toString());
          }
      }      
      catch(Exception e){
          out.print(e.toString());
         out.print(e.toString());
      }
    }
    Statement stmt = con.createStatement();
    String query = "select * from individual where id="+session.getAttribute("userId");
    ResultSet rs = stmt.executeQuery(query);
    rs.next();
%>
<%@ include file="includes/head.jsp" %>
<body>
  <%@include file="includes/menu.jsp" %>
  <div class="container-fluid">
      <div class="row-fluid">
        <div class="span3">
          <div class="well sidebar-nav">
            <ul class="nav nav-list">
              <li class="nav-header">Job For You</li>
<%
        String like="requirements like '%";
        String []skills = rs.getString("skills").split(",");
        for (int i=0;i<skills.length;i++){
            if(i!=skills.length-1)
                like+=skills[i].trim()+"%' or requirements like '%";
            else
                like+=skills[i].trim();
        }
        //out.print(like);
        String query1="select jid,post_name,cname from joboffer as j, company as c where c.cid=j.cid and "+like+"%';";
        //out.print(query1);
        Statement stmt1 = con.createStatement();
        ResultSet rsj = stmt1.executeQuery(query1);
        while(rsj.next()){
%>            
                <li><a href="job.jsp?id=<%=rsj.getInt("jid")%>"><%=rsj.getString("post_name")+" @ "+rsj.getString("cname")%> </a> </li>
<%      } %>
        <script type="text/javascript">
    function showResult(str)
{
if (str.length==0)
  {
  document.getElementById("livesearch").innerHTML="";
  document.getElementById("livesearch").style.border="0px";
  return;
  }
if (window.XMLHttpRequest)
  {// code for IE7+, Firefox, Chrome, Opera, Safari
  xmlhttp=new XMLHttpRequest();
  }
else
  {// code for IE6, IE5
  xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  }
xmlhttp.onreadystatechange=function()
  {
  if (xmlhttp.readyState==4 && xmlhttp.status==200)
    {
    document.getElementById("livesearch").innerHTML=xmlhttp.responseText;
    document.getElementById("livesearch").style.border="1px solid #A5ACB2";
    }
  }
xmlhttp.open("GET","includes/livesearch.jsp?q="+str,true);
xmlhttp.send();
}
</script>
<br>
<li class="nav-header"> <i class="icon-search"></i> Live Search Jobs</li>
    <input type="text" name="search-term"  onkeyup="showResult(this.value)" placeholder="Enter Keyword..." class="input-medium search-query">
    <div id="livesearch" style="border:none">&nbsp;&nbsp;Search results...</div>
            </ul>
          </div><!--/.well -->
        </div><!--/span-->
        <div class="span9">
<%            
    try{
%>
            <form action="" method="POST" enctype="multipart/form-data">
                  <legend>Edit profile to allow us search better.</legend>
                  <label>First name</label>
                  <input type="text" name="fname" placeholder="Your First Name" value="<%=rs.getString("fname")%>" required>
                  <label>Last Name</label>
                  <input type="text" name="lname" placeholder="Your Last Name" value="<%=rs.getString("lname")%>">
                  <label>Qualification</label>
                  <input type="text" name="qualification" placeholder="Qualification" value="<%=rs.getString("qualification")%>" required>
                  <label>Skills</label>
                  <input type="text" name="skills" placeholder="Seperated by commans" value="<%=rs.getString("skills")%>">
                  <label>Work Experience</label>
                  <input type="text" name="work_ex" placeholder="Work Experieince" value="<%=rs.getString("work_ex")%>">
                  <label>Address</label>
                  <input type="text" name="address" placeholder="Address" value="<%=rs.getString("address")%>" required>
                  <label>City</label>
                  <input type="text" name="city" placeholder="City" value="<%=rs.getString("city")%>"required>
                  <label>Country</label>
                  <input type="text" name="country" placeholder="Country" value="<%=rs.getString("country")%>" required>
                  <label>Photograph (png/jpg only)</label>
                  <input type="file" name="photo" accept="image/jpg,image/png">
                  <% if(rs.getString("photograph").equals("")){ %>
                  <img src="uploads/ind/resumes/default.gif" />
                  <% } else { %>
                  <img src="uploads/ind/pics/<%=rs.getString("photograph")%>" /><br><br>
                  <label>Resume (PDF only)</label><% } %>
                  <input type="file" name="resume_url" accept="application/pdf" placeholder="Resume">
                  <% if(!rs.getString("resume_url").equals("")) %>
                  <a href="uploads/ind/resumes/<%=rs.getString("resume_url")%>" target="_blank" >Present Resume</a><br><br>
                  <button type="submit" class="btn">Save Details</button>
                </form>
<%
   }
    catch(Exception e){
        out.print(e.toString());
        e.printStackTrace();
    }
%>    
        </div><!--/span-->
      </div><!--/row-->

      <hr>

      <footer>
        <p>&copy; JobPortal 2012</p>
      </footer>

    </div>
    <script type="text/javascript">
      $('.dropdown-toggle').dropdown();
    </script>
    <script type="text/javascript" src="js/bootstrap-dropdown.js"></script>
</body>
</html>