package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet(name = "ExportExcelBarangServlet", urlPatterns = {"/ExportExcelBarangServlet"})
public class ExportExcelBarangServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/vnd.ms-excel");
        response.setHeader("Content-Disposition", "attachment; filename=data_barang.xls");

        try (PrintWriter out = response.getWriter()) {
            out.println("<table border='1'>");
            out.println("<tr><th>No</th><th>Nama Barang</th><th>Stok</th><th>Harga</th></tr>");

            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db_toko", "root", "");
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT * FROM barang ORDER BY id_barang ASC")) {

                int no = 1;
                while (rs.next()) {
                    String nama = rs.getString("nama_barang");
                    int stok = rs.getInt("stok");
                    double harga = rs.getDouble("harga");

                    out.println("<tr>");
                    out.println("<td>" + no++ + "</td>");
                    out.println("<td>" + nama + "</td>");
                    out.println("<td>" + stok + "</td>");
                    out.println("<td>" + String.format("Rp %, .0f", harga).replace(',', '.') + "</td>");
                    out.println("</tr>");
                }
            }

            out.println("</table>");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
