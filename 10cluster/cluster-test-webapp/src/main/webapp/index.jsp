<html>
<body>
<%
    Integer counter;

    counter = (Integer) session.getAttribute("counter");
    if (counter == null) {
	counter = 0;
    } else {
	counter ++;
    }
    session.setAttribute("counter", counter);
%>
<h2>Cluster test application</h2>
<p>
    Local server name (cluster node): <%= System.getProperty("jboss.node.name") + "/" + System.getProperty("jboss.server.name")  %><br/>
    Server name: <%= request.getServerName() %><br/>
    Server port: <%= request.getServerPort() %><br/>
</p>
<p>
    Web session id: <%= session.getId() %>
    <hr/>
    Counter: <%= counter %>
</p>
</body>
</html>
