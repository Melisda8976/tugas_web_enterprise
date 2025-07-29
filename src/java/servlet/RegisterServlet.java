package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/RegisterServlet"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Ambil data dari form
        String nama_lengkap = request.getParameter("nama_lengkap");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String konfirmasi = request.getParameter("konfirmasi");
        String role = request.getParameter("role");

        try {
            // Koneksi ke database
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/user", "root", "");

            // Query untuk menyimpan data user
            String sql = "INSERT INTO users (nama_lengkap, email, password, konfirmasi, role) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, nama_lengkap);
            stmt.setString(2, email);
            stmt.setString(3, password);
            stmt.setString(4, konfirmasi);// Disarankan: hash password
            stmt.setString(5, role);
            stmt.executeUpdate();

            // Set session login
            HttpSession session = request.getSession();
            session.setAttribute("email", email);
            session.setAttribute("role", role);

            // Redirect ke dashboard berdasarkan role
            
                response.sendRedirect("login.jsp");
         

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Gagal mendaftar: " + e.getMessage());
        }
    }
}
