<%-- 
    Document   : logout
    Created on : Nov 7, 2012, 8:50:27 PM
    Author     : om
--%>

<%
    session.setAttribute("isSessionSet", null);
    session.setAttribute("userName", null);
    session.setAttribute("userId", null);
    session.setAttribute("profileType", null);
    response.sendRedirect("index.jsp");
%>   
