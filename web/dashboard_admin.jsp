<%@page import="javax.management.relation.Role"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title><i class="fas fa-store"></i>Dashboard Admin| Aplikasi KuyBELI</title>
        <!-- Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">

        <style>
            body {
                font-family: 'Poppins', sans-serif;
                background: linear-gradient(to right, #38ef7d, #11998e);
                min-height: 100vh;
                margin: 0;
            }

            .sidebar {
                background-color: rgba(0, 90, 0, 0.9);
                min-height: 100vh;
                padding: 30px 20px;
                color: white;
            }

            .sidebar h4 {
                font-weight: 600;
                margin-bottom: 30px;
            }

            .sidebar a {
                color: white;
                display: block;
                padding: 10px 15px;
                border-radius: 10px;
                margin-bottom: 10px;
                transition: all 0.3s;
                text-decoration: none;
            }

            .sidebar a:hover {
                background-color: #0e5f38;
                text-decoration: none;
            }

            .content {
                padding: 40px;
            }

            .card {
                border-radius: 20px;
                box-shadow: 0 8px 20px rgba(0,0,0,0.15);
                border: none;
            }

            .card-body {
                padding: 30px;
            }

            .card-title {
                font-weight: 600;
                color: #198754;
            }

            .btn-custom {
                background-color: #198754;
                color: white;
                border-radius: 30px;
                padding: 10px 20px;
                border: none;
                transition: all 0.3s ease-in-out;
            }

            .btn-custom:hover {
                background-color: #146c43;
            }
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <nav class="col-md-3 col-lg-2 sidebar">
                    <h4>Admin KuyBELI</h4>
                    <a href="main_menu.jsp">🏠 Home</a>
                    <a href="Data_register.jsp">👤 Data Register</a>
                    <a href="data_barang.jsp">📦 Data Barang</a>
                    <a href="Data_pesanan.jsp">🛒 Data Pesanan</a>

                    <a href="login.jsp">🚪 Logout</a>
                </nav>

                <!-- Main Content -->
                <main class="col-md-9 ms-sm-auto col-lg-10 content">
                    <h2 class="mb-4 text-white fw-bold">Selamat Datang di KuyBELI (Admin)</h2>

                    <div class="row g-4">
                        <div class="col-md-6 col-lg-4">
                            <div class="card">
                                <div class="card-body">
                                    <h5 class="card-title">Data Register</h5>
                                    <p class="card-text">Kelola informasi pengguna yang sudah mendaftar.</p>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6 col-lg-4">
                            <div class="card">
                                <div class="card-body">
                                    <h5 class="card-title">Data Barang</h5>
                                    <p class="card-text">Lihat dan kelola daftar barang yang tersedia.</p>
                                </div>
                            </div>
                        </div>

                    </div>
                </main>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
