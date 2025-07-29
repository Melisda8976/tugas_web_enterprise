/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "InvoiceServlet", urlPatterns = {"/InvoiceServlet"})
public class InvoiceServlet extends HttpServlet {

    private final String DB_URL = "jdbc:mysql://localhost:3306/db_toko";
    private final String DB_USER = "root";
    private final String DB_PASS = "";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String action = request.getParameter("action");
        if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id_invoice"));
            String status = request.getParameter("status");

            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                 PreparedStatement ps = conn.prepareStatement("UPDATE invoice SET status = ? WHERE id_invoice = ?")) {

                ps.setString(1, status);
                ps.setInt(2, id);
                ps.executeUpdate();

            } catch (SQLException e) {
                e.printStackTrace();
            }

            response.sendRedirect("Data_pesanan.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));

            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                 PreparedStatement ps = conn.prepareStatement("DELETE FROM invoice WHERE id_invoice = ?")) {

                ps.setInt(1, id);
                ps.executeUpdate();

            } catch (SQLException e) {
                e.printStackTrace();
            }

            response.sendRedirect("Data_pesanan.jsp");
        }
    }
}
