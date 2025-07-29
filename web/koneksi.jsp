<%-- 
    Document   : koneksi
    Created on : 10 Jun 2025, 18.51.39
    Author     : melisda
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.cj.jdbc.Driver" %>
<%
    Connection conn = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db_toko", "root", "");
        application.setAttribute("koneksi", conn);
    } catch(Exception e) {
        out.println("Koneksi Gagal: " + e.getMessage());
    }
%>