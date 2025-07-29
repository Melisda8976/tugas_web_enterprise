package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.*;
import java.util.UUID;

@WebServlet(name = "BarangServlet", urlPatterns = {"/BarangServlet"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,   // 2MB
    maxFileSize = 1024 * 1024 * 10,        // 10MB
    maxRequestSize = 1024 * 1024 * 50      // 50MB
)
public class BarangServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads";
    private static final String DB_URL = "jdbc:mysql://localhost:3306/db_toko";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "") {
                case "save":
                    tambahBarang(request, response);
                    break;
                case "update":
                    editBarang(request, response);
                    break;
                case "delete":
                    hapusBarang(request, response);
                    break;
                case "clear":
                    hapusSemuaBarang(request, response);
                    break;
                default:
                    response.sendRedirect("data_barang.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Terjadi kesalahan: " + e.getMessage());
        }
    }

    private void tambahBarang(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        String nama = request.getParameter("nama_barang");
        String stokStr = request.getParameter("stok");
        String hargaStr = request.getParameter("harga");
        
        // Validasi input
        if (nama == null || nama.trim().isEmpty() || 
            stokStr == null || hargaStr == null) {
            throw new IllegalArgumentException("Data tidak lengkap");
        }
        
        int stok = Integer.parseInt(stokStr);
        double harga = Double.parseDouble(hargaStr);
        String namaGambar = uploadGambar(request);

        String sql = "INSERT INTO barang (nama_barang, gambar, stok, harga) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, nama.trim());
            ps.setString(2, namaGambar);
            ps.setInt(3, stok);
            ps.setDouble(4, harga);
            ps.executeUpdate();
        }

        response.sendRedirect("data_barang.jsp");
    }

    private void editBarang(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        String idStr = request.getParameter("id");
        String nama = request.getParameter("nama_barang");
        String stokStr = request.getParameter("stok");
        String hargaStr = request.getParameter("harga");
        
        if (idStr == null || nama == null || stokStr == null || hargaStr == null) {
            throw new IllegalArgumentException("Data tidak lengkap");
        }
        
        int id = Integer.parseInt(idStr);
        int stok = Integer.parseInt(stokStr);
        double harga = Double.parseDouble(hargaStr);
        String gambarBaru = uploadGambar(request);

        try (Connection conn = getConnection()) {
            String sql;
            PreparedStatement ps;
            
            if (gambarBaru != null && !gambarBaru.trim().isEmpty()) {
                sql = "UPDATE barang SET nama_barang=?, gambar=?, stok=?, harga=? WHERE id_barang=?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, nama.trim());
                ps.setString(2, gambarBaru);
                ps.setInt(3, stok);
                ps.setDouble(4, harga);
                ps.setInt(5, id);
            } else {
                sql = "UPDATE barang SET nama_barang=?, stok=?, harga=? WHERE id_barang=?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, nama.trim());
                ps.setInt(2, stok);
                ps.setDouble(3, harga);
                ps.setInt(4, id);
            }
            
            ps.executeUpdate();
            ps.close();
        }

        response.sendRedirect("data_barang.jsp");
    }

    private void hapusBarang(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        String idStr = request.getParameter("id_barang");
        if (idStr == null) {
            throw new IllegalArgumentException("ID barang tidak ditemukan");
        }
        
        int id = Integer.parseInt(idStr);

        String sql = "DELETE FROM barang WHERE id_barang=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ps.executeUpdate();
        }

        response.sendRedirect("data_barang.jsp");
    }

    private void hapusSemuaBarang(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        String sql = "DELETE FROM barang";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.executeUpdate();
        }

        response.sendRedirect("data_barang.jsp");
    }

    private String uploadGambar(HttpServletRequest request) throws IOException, ServletException {
        Part filePart = request.getPart("gambar");
        
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }

        String originalFileName = filePart.getSubmittedFileName();
        if (originalFileName == null || originalFileName.trim().isEmpty()) {
            return null;
        }

        // Buat nama file unik untuk menghindari konflik
        String fileExtension = getFileExtension(originalFileName);
        String uniqueFileName = UUID.randomUUID().toString() + fileExtension;

        // Dapatkan path absolut untuk folder uploads
        String realPath = request.getServletContext().getRealPath("/");
        Path uploadPath = Paths.get(realPath, UPLOAD_DIR);
        
        // Buat direktori jika belum ada
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        // Path lengkap untuk file
        Path filePath = uploadPath.resolve(uniqueFileName);
        
        // Simpan file
        try (InputStream inputStream = filePart.getInputStream()) {
            Files.copy(inputStream, filePath);
        }

        return uniqueFileName;
    }
    
    private String getFileExtension(String fileName) {
        int lastDotIndex = fileName.lastIndexOf('.');
        if (lastDotIndex > 0 && lastDotIndex < fileName.length() - 1) {
            return fileName.substring(lastDotIndex);
        }
        return "";
    }

    private Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }
}