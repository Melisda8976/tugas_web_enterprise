<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>KuyBELI - Home</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        :root {
            --primary-green: #2d5a27;
            --light-green: #4a7c59;
            --accent-green: #68bb59;
            --soft-green: #e8f5e8;
            --mint-green: #b8e6b8;
            --dark-green: #1a3a17;
        }

        body {
            background: linear-gradient(135deg, #f8fffe 0%, var(--soft-green) 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
        }

        .sidebar {
            background: linear-gradient(180deg, var(--primary-green) 0%, var(--dark-green) 100%);
            min-height: 100vh;
            padding: 25px;
            color: white;
            box-shadow: 4px 0 15px rgba(0,0,0,0.1);
            position: relative;
            overflow: hidden;
        }

        .sidebar::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="leaf" patternUnits="userSpaceOnUse" width="100" height="100"><path d="M20,20 Q30,10 40,20 Q30,30 20,20" fill="rgba(255,255,255,0.05)"/></pattern></defs><rect width="100" height="100" fill="url(%23leaf)"/></svg>');
            opacity: 0.3;
        }

        .sidebar > * {
            position: relative;
            z-index: 1;
        }

        .sidebar h4 {
            font-weight: bold;
            font-size: 1.5rem;
            margin-bottom: 30px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
            border-bottom: 2px solid var(--accent-green);
            padding-bottom: 15px;
        }

        .sidebar a {
            display: flex;
            align-items: center;
            color: rgba(255,255,255,0.9);
            margin-bottom: 15px;
            text-decoration: none;
            padding: 12px 15px;
            border-radius: 10px;
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .sidebar a:hover {
            background: rgba(255,255,255,0.1);
            color: var(--accent-green);
            transform: translateX(5px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }

        .sidebar a i {
            width: 25px;
            text-align: center;
        }

        .main-content {
            padding: 30px;
            background: rgba(255,255,255,0.8);
            border-radius: 20px 0 0 20px;
            margin-left: -15px;
            backdrop-filter: blur(10px);
        }

        .welcome-title {
            background: linear-gradient(45deg, var(--primary-green), var(--accent-green));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-weight: 800;
            font-size: 2.2rem;
            margin-bottom: 30px;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .carousel {
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(45,90,39,0.2);
            margin-bottom: 40px;
        }

        .carousel-item img {
            height: 550px;
            width: 350px;
            object-fit: fixed;
            filter: brightness(1.1) contrast(1.05);
        }
       
        .carousel-control-prev,
        .carousel-control-next {
            background: linear-gradient(45deg, var(--primary-green), var(--accent-green));
            width: 50px;
            height: 50px;
            border-radius: 50%;
            top: 50%;
            transform: translateY(-50%);
            opacity: 0.8;
            transition: all 0.3s ease;
        }

        .carousel-control-prev:hover,
        .carousel-control-next:hover {
            opacity: 1;
            transform: translateY(-50%) scale(1.1);
        }

        .product-card {
            border: none;
            border-radius: 20px;
            overflow: hidden;
            transition: all 0.4s ease;
            background: white;
            box-shadow: 0 5px 20px rgba(45,90,39,0.1);
            position: relative;
        }

        .product-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--accent-green), var(--light-green));
            transform: scaleX(0);
            transition: transform 0.3s ease;
        }

        .product-card:hover::before {
            transform: scaleX(1);
        }

        .product-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 40px rgba(45,90,39,0.2);
        }

        .product-card img {
            height: 200px;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .product-card:hover img {
            transform: scale(1.05);
        }

        .card-body {
            padding: 20px;
        }

        .card-title {
            color: var(--primary-green);
            font-weight: 600;
            margin-bottom: 10px;
            font-size: 1.1rem;
        }

        .price {
            color: var(--accent-green);
            font-weight: bold;
            font-size: 1.2rem;
            margin-bottom: 15px;
        }

        .btn-add-cart {
            background: linear-gradient(45deg, var(--accent-green), var(--light-green));
            border: none;
            color: white;
            padding: 10px 20px;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(104,187,89,0.3);
        }

        .btn-add-cart:hover {
            background: linear-gradient(45deg, var(--light-green), var(--primary-green));
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(104,187,89,0.4);
            color: white;
        }

        .section-divider {
            height: 3px;
            background: linear-gradient(90deg, var(--accent-green), transparent);
            border: none;
            margin: 40px 0;
            border-radius: 2px;
        }

        .stock-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: var(--accent-green);
            color: white;
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .loading-spinner {
            color: var(--accent-green);
        }

        .error-message {
            background: rgba(220, 53, 69, 0.1);
            border: 1px solid rgba(220, 53, 69, 0.3);
            color: #dc3545;
            padding: 15px;
            border-radius: 10px;
            margin: 20px 0;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .product-card {
            animation: fadeInUp 0.6s ease forwards;
        }

        .product-card:nth-child(1) { animation-delay: 0.1s; }
        .product-card:nth-child(2) { animation-delay: 0.2s; }
        .product-card:nth-child(3) { animation-delay: 0.3s; }
        .product-card:nth-child(4) { animation-delay: 0.4s; }

        /* Responsive Design */
        @media (max-width: 768px) {
            .sidebar {
                min-height: auto;
                padding: 15px;
            }
            
            .main-content {
                margin-left: 0;
                border-radius: 0;
                padding: 20px;
            }
            
            .welcome-title {
                font-size: 1.8rem;
            }
            
            .carousel-item img {
                height: 350px;
                 width: 350px;
            }
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <nav class="col-md-3 col-lg-2 sidebar">
            <h4 class="mb-4">
                <i class="fas fa-store me-2"></i>KuyBELI
            </h4>
            <a href="main_menu.jsp">
                <i class="fas fa-home me-3"></i>
                <span>Home</span>
            </a>
            <a href="keranjang.jsp">
                <i class="fas fa-shopping-cart me-3"></i>
                <span>Keranjang</span>
            </a>
            <a href="pesanan_saya.jsp">
                <i class="fas fa-clipboard-list me-3"></i>
                <span>Pesanan</span>
            </a>
            <a href="profil_user.jsp">
                <i class="fas fa-user me-3"></i>
                <span>Profil</span>
            </a>
            <a href="login.jsp">
                <i class="fas fa-sign-out-alt me-3"></i>
                <span>Logout</span>
            </a>
        </nav>

        <!-- Main Content -->
        <main class="col-md-9 col-lg-10 main-content">
            <h1 class="welcome-title">
                 Selamat Datang di KuyBELI!
            </h1>
            <p class="text-muted mb-4">Temukan produk terbaik dengan kualitas premium dan harga terjangkau</p>

            <!-- Carousel Iklan -->
            <!-- Carousel Iklan -->
            <div id="iklanCarousel" class="carousel slide" data-bs-ride="carousel" data-bs-interval="4000">
                <div class="carousel-indicators">
                    <button type="button" data-bs-target="#iklanCarousel" data-bs-slide-to="0" class="active"></button>
                    <button type="button" data-bs-target="#iklanCarousel" data-bs-slide-to="1"></button>
                    <button type="button" data-bs-target="#iklanCarousel" data-bs-slide-to="2"></button>
                </div>

                <div class="carousel-inner">
                    <div class="carousel-item active">
                        <img src="uploads/iklan1.jpg" class="d-block w-100" alt="Promo 1">
                    </div>
                    <div class="carousel-item active">
                        <img src="uploads/iklan2.jpg" class="d-block w-100" alt="Promo 2">
                    </div>
                    <div class="carousel-item active">
                        <img src="uploads/iklan3.jpg" class="d-block w-100" alt="Promo 3">
                    </div>
                </div>
                <button class="carousel-control-prev" type="button" data-bs-target="#iklanCarousel" data-bs-slide="prev">
                    <span class="carousel-control-prev-icon"></span>
                    <span class="visually-hidden">Previous</span>
                </button>
                <button class="carousel-control-next" type="button" data-bs-target="#iklanCarousel" data-bs-slide="next">
                    <span class="carousel-control-next-icon"></span>
                    <span class="visually-hidden">Next</span>
                </button>
            </div>


            <hr class="section-divider">

            <!-- Header Katalog -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="text-success fw-bold">
                    <i class="fas fa-store me-2"></i>Katalog Produk
                </h3>
                <div class="text-muted">
                    <i class="fas fa-boxes me-2"></i>Produk Tersedia
                </div>
            </div>

            <!-- Katalog Produk -->
            <div class="row g-4">
                <%
                    Connection conn = null;
                    Statement stmt = null;
                    ResultSet rs = null;
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db_toko", "root", "");
                        stmt = conn.createStatement();
                        rs = stmt.executeQuery("SELECT * FROM barang WHERE stok > 0 ORDER BY nama_barang");

                        int productCount = 0;
                        while (rs.next()) {
                            productCount++;
                %>
                <div class="col-lg-3 col-md-4 col-sm-6">
                    <div class="card product-card h-100">
                        <div class="position-relative">
                            <img src="uploads/<%= rs.getString("gambar") %>" 
                                 class="card-img-top" 
                                 alt="<%= rs.getString("nama_barang") %>"
                                 onerror="this.src='https://via.placeholder.com/300x200?text=No+Image'">
                            <span class="stock-badge">
                                <i class="fas fa-cube me-1"></i><%= rs.getInt("stok") %>
                            </span>
                        </div>
                        <div class="card-body d-flex flex-column">
                            <h5 class="card-title"><%= rs.getString("nama_barang") %></h5>
                            <p class="price mb-3">
                                <i class="fas fa-tag me-1"></i>Rp <%= String.format("%,.0f",rs.getDouble("harga")) %>
                            </p>
                            <div class="mt-auto">
                                <form action="keranjang.jsp" method="post" class="w-100">
                                    <input type="hidden" name="id" value="<%= rs.getString("id_barang") %>">
                                    <input type="hidden" name="nama" value="<%= rs.getString("nama_barang") %>">
                                    <input type="hidden" name="harga" value="<%= rs.getDouble("harga") %>">
                                    <input type="hidden" name="jumlah" value="1">
                                    <button type="submit" class="btn btn-add-cart w-100">
                                        <i class="fas fa-cart-plus me-2"></i>Tambah ke Keranjang
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <%
                        }
                        
                        if (productCount == 0) {
                %>
                <div class="col-12">
                    <div class="text-center py-5">
                        <i class="fas fa-box-open text-muted" style="font-size: 4rem;"></i>
                        <h4 class="text-muted mt-3">Belum Ada Produk Tersedia</h4>
                        <p class="text-muted">Produk akan segera hadir. Silakan cek kembali nanti!</p>
                    </div>
                </div>
                <%
                        }
                    } catch (Exception e) {
                %>
                <div class="col-12">
                    <div class="error-message">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <strong>Gagal memuat produk:</strong> <%= e.getMessage() %>
                        <br><small>Silakan refresh halaman atau hubungi administrator.</small>
                    </div>
                </div>
                <%
                    } finally {
                        try { if (rs != null) rs.close(); } catch (Exception e) {}
                        try { if (stmt != null) stmt.close(); } catch (Exception e) {}
                        try { if (conn != null) conn.close(); } catch (Exception e) {}
                    }
                %>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Smooth scrolling untuk navigasi
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            document.querySelector(this.getAttribute('href')).scrollIntoView({
                behavior: 'smooth'
            });
        });
    });

    // Loading animation untuk gambar
    document.querySelectorAll('.product-card img').forEach(img => {
        img.addEventListener('load', function() {
            this.style.opacity = '1';
        });
    });

    // Hover effect untuk sidebar links
    document.querySelectorAll('.sidebar a').forEach(link => {
        link.addEventListener('mouseenter', function() {
            this.style.transform = 'translateX(8px)';
        });
        
        link.addEventListener('mouseleave', function() {
            this.style.transform = 'translateX(0)';
        });
    });
</script>
</body>
</html>