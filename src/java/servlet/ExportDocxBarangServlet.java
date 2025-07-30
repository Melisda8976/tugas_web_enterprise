/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.sql.*;

@WebServlet(name = "ExportDocxBarangServlet", urlPatterns = {"/ExportDocxBarangServlet"})
public class ExportDocxBarangServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/msword");
        response.setHeader("Content-Disposition", "attachment; filename=\"data_barang.doc\"");

        PrintWriter out = response.getWriter();

        out.println("<html><head><meta charset='UTF-8'></head><body>");
        out.println("<h2 style='text-align:center;'>Data Barang</h2>");
        out.println("<table border='1' cellpadding='8' cellspacing='0' width='100%'>");
        out.println("<tr style='background-color:#f2f2f2; font-weight:bold;'>");
        out.println("<td>No</td>");
        out.println("<td>Nama</td>");
        out.println("<td>Gambar</td>");
        out.println("<td>Stok</td>");
        out.println("<td>Harga</td>");
        out.println("</tr>");

        try (
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db_toko", "root", "");
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM barang ORDER BY id_barang ASC")
        ) {
            int no = 1;
            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + (no++) + "</td>");
                out.println("<td>" + rs.getString("nama_barang") + "</td>");
                out.println("<td>" + rs.getString("gambar") + "</td>");
                out.println("<td>" + rs.getInt("stok") + "</td>");
                out.println("<td>Rp " + String.format("%,.0f", rs.getDouble("harga")).replace(",", ".") + "</td>");
                out.println("</tr>");
            }
        } catch (Exception e) {
            out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
            e.printStackTrace();
        }

        out.println("</table>");
        out.println("</body></html>");
    }
}
