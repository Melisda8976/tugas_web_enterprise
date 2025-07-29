<%-- 
    Document   : koneksitest
    Created on : 23 Apr 2025, 11.09.42
    Author     : melisda
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.cj.jdbc.Driver" %>

<%
    Connection connection = null;
    String status = "";
    try {
        String connectionURL = "jdbc:mysql://localhost:3306/user";
        String username = "root";
        String password = "";
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(connectionURL, username, password);
        
        if (connection == null) {
            status = "gagal";
        } else {
            status = "berhasil";
        }

        connection.close();
    } catch (ClassNotFoundException ex) {
        status = "Driver Error";
    } catch (SQLException ex) {
        status = "gagal";
    }
%>

<html>
<head>
    <title>Koneksi test</title>
</head>
<body>
    Koneksi ke database <%= status %>
    <br/>
    Script diatas akan memunculkan status koneksi.
</body>
</html>
