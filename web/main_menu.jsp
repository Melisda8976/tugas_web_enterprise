<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Beranda | Aplikasi KuyBELI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;500;700&display=swap');

        body {
            background: linear-gradient(to right, #1f4037, #99f2c8);
            min-height: 100vh;
            font-family: 'Poppins', sans-serif;
            color: white;
            display: flex;
            flex-direction: column;
        }

        .navbar {
            background-color: rgba(0, 0, 0, 0.8) !important;
        }

        .navbar-brand {
            font-weight: 700;
            font-size: 1.6rem;
        }

        .nav-link {
            font-size: 1rem;
            transition: color 0.3s ease;
        }

        .nav-link:hover {
            color: #ffc107 !important;
        }

        .hero-section {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 80px 20px;
        }

        .hero-section h1 {
            font-weight: 700;
            font-size: 3rem;
            animation: fadeInDown 1s ease-out;
        }

        .hero-section p {
            font-size: 1.2rem;
            margin-top: 10px;
            max-width: 600px;
            animation: fadeInUp 1s ease-out;
        }

        .btn-custom {
            padding: 12px 30px;
            font-size: 1rem;
            border-radius: 50px;
            transition: all 0.3s ease-in-out;
            margin: 10px;
        }

        .btn-login {
            background-color: #ffffff;
            color: #1f4037;
            border: none;
        }

        .btn-login:hover {
            background-color: #e0f7fa;
            transform: translateY(-3px);
        }

        .btn-register {
            background-color: transparent;
            border: 2px solid #ffffff;
            color: #ffffff;
        }

        .btn-register:hover {
            background-color: #ffffff;
            color: #1f4037;
            transform: translateY(-3px);
        }

        footer {
            background-color: rgba(0, 0, 0, 0.6);
            font-size: 0.95rem;
        }

        @keyframes fadeInDown {
            from {opacity: 0; transform: translateY(-20px);}
            to {opacity: 1; transform: translateY(0);}
        }

        @keyframes fadeInUp {
            from {opacity: 0; transform: translateY(20px);}
            to {opacity: 1; transform: translateY(0);}
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="#">KuyBELI</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                    data-bs-target="#navbarNav" aria-controls="navbarNav"
                    aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
                <ul class="navbar-nav">
                    <li class="nav-item"><a class="nav-link active" href="#">Beranda</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Tentang</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Kontak</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section">
        <h1>Selamat Datang di Aplikasi KuyBELI</h1>
        <p>Platform modern berbasis JSP untuk manajemen data yang responsif dan efisien.</p>
        <div class="d-flex justify-content-center flex-wrap">
            <a href="login.jsp" class="btn btn-custom btn-login">Masuk</a>
            <a href="register.jsp" class="btn btn-custom btn-register">Daftar</a>
        </div>
    </section>

    <!-- Footer -->
    <footer class="text-white text-center py-3">
        <p class="mb-0">© 2025 Aplikasi KuyBELI. Semua Hak Dilindungi.</p>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
