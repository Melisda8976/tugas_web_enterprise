package servlet;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet(name = "InvoiceServlet", urlPatterns = {"/InvoiceServlet"})
public class InvoiceServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/db_toko";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String action = request.getParameter("action");

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
            switch (action) {
                case "edit":
                    editStatus(conn, request);
                    break;
                case "delete":
                    deleteInvoice(conn, request);
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        response.sendRedirect("Data_pesanan.jsp");
    }

    private void editStatus(Connection conn, HttpServletRequest request) throws SQLException {
        int id = Integer.parseInt(request.getParameter("id_invoice"));
        String status = request.getParameter("status");

        String sql = "UPDATE invoice SET status = ? WHERE id_invoice = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        }
    }

    private void deleteInvoice(Connection conn, HttpServletRequest request) throws SQLException {
        int id = Integer.parseInt(request.getParameter("id"));

        String sql = "DELETE FROM invoice WHERE id_invoice = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }
}
