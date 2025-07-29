package servlet;

import model.ItemKeranjang;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.List;

@WebServlet(name = "CheckoutServlet", urlPatterns = {"/CheckoutServlet"})
public class CheckoutServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/db_toko";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nama = request.getParameter("nama_penerima");
        String alamat = request.getParameter("alamat");
        String telepon = request.getParameter("telepon");
        double total = Double.parseDouble(request.getParameter("total"));
        String pembayaran = request.getParameter("pembayaran");
        String status = "Pending";
        String aksi = "lihat_detail";  // ini akan digunakan untuk menandai tombol "Lihat Detail" di halaman invoice

        HttpSession session = request.getSession();
        List<ItemKeranjang> keranjang = (List<ItemKeranjang>) session.getAttribute("keranjang");

        if (keranjang == null || keranjang.isEmpty()) {
            response.sendRedirect("keranjang.jsp");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (
                Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                PreparedStatement psInvoice = conn.prepareStatement(
                    "INSERT INTO invoice (nama_penerima, alamat, telepon, total, pembayaran, tanggal, status, aksi) " +
                    "VALUES (?, ?, ?, ?, ?, NOW(), ?, ?)",
                    Statement.RETURN_GENERATED_KEYS
                )
            ) {
                psInvoice.setString(1, nama);
                psInvoice.setString(2, alamat);
                psInvoice.setString(3, telepon);
                psInvoice.setDouble(4, total);
                psInvoice.setString(5, pembayaran);
                psInvoice.setString(6, status);
                psInvoice.setString(7, aksi);
                psInvoice.executeUpdate();

                int invoiceId;
                try (ResultSet rs = psInvoice.getGeneratedKeys()) {
                    rs.next();
                    invoiceId = rs.getInt(1);
                }

                try (PreparedStatement psDetail = conn.prepareStatement(
                    "INSERT INTO detail_invoice (id_invoice, id_barang, nama_barang, harga, jumlah, subtotal) VALUES (?, ?, ?, ?, ?, ?)")
                ) {
                    for (ItemKeranjang item : keranjang) {
                        psDetail.setInt(1, invoiceId);
                        psDetail.setInt(2, item.getId());
                        psDetail.setString(3, item.getNama());
                        psDetail.setDouble(4, item.getHarga());
                        psDetail.setInt(5, item.getJumlah());
                        psDetail.setDouble(6, item.getSubtotal());
                        psDetail.addBatch();
                        
                         String sqlUpdateStok = "UPDATE barang SET stok = stok - ? WHERE id_barang = ?";
                            PreparedStatement pstStok = conn.prepareStatement(sqlUpdateStok);
                            pstStok.setInt(1, item.getJumlah());
                            pstStok.setInt(2, item.getId());
                            pstStok.executeUpdate();
                            pstStok.close();
                    }
                    psDetail.executeBatch();
                }
        

                // Hapus keranjang dari session setelah sukses checkout
                session.removeAttribute("keranjang");

                // Redirect ke halaman invoice.jsp dengan parameter id
                response.sendRedirect("checkout.jsp?status=sukses");


            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/plain");
            response.getWriter().println("Checkout gagal: " + e.getMessage());
        }
    }
}
