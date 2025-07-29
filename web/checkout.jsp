<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.ItemKeranjang" %>
<%
    List<ItemKeranjang> keranjang = (List<ItemKeranjang>) session.getAttribute("keranjang");
    if (keranjang == null) {
        keranjang = new ArrayList<>();
    }

    double total = 0;
    for (ItemKeranjang item : keranjang) {
        total += item.getSubtotal();
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Halaman Checkout</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #e8f5e8 0%, #f0fff0 50%, #e0ffe0 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
        }
        
        .page-header {
            background: linear-gradient(135deg, #4caf50 0%, #66bb6a 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
            border-radius: 0 0 30px 30px;
            box-shadow: 0 4px 20px rgba(76, 175, 80, 0.3);
        }
        
        .page-header h2 {
            font-weight: 700;
            margin-bottom: 0.5rem;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .page-header p {
            opacity: 0.9;
            font-size: 1.1rem;
        }
        
        .card {
            border-radius: 25px;
            box-shadow: 0 15px 35px rgba(76, 175, 80, 0.1);
            border: none;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(76, 175, 80, 0.15);
        }
        
        .card-header {
            background: linear-gradient(135deg, #81c784 0%, #a5d6a7 100%);
            color: white;
            border-radius: 25px 25px 0 0 !important;
            padding: 1.5rem;
            border: none;
        }
        
        .card-header h5 {
            margin: 0;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .table {
            border-radius: 15px;
            overflow: hidden;
            border: none;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }
        
        .table thead th {
            background: linear-gradient(135deg, #c8e6c9 0%, #dcedc8 100%);
            color: #2e7d32;
            font-weight: 600;
            border: none;
            padding: 1rem;
        }
        
        .table tbody td {
            border: none;
            padding: 1rem;
            background: rgba(255, 255, 255, 0.8);
        }
        
        .table tbody tr:nth-child(even) td {
            background: rgba(232, 245, 233, 0.3);
        }
        
        .total-row {
            background: linear-gradient(135deg, #a5d6a7 0%, #c8e6c9 100%) !important;
            color: #1b5e20 !important;
            font-weight: 700 !important;
            font-size: 1.1rem;
        }
        
        .total-row td {
            background: transparent !important;
            padding: 1.5rem 1rem !important;
        }
        
        .form-control, .form-select {
            border-radius: 15px;
            border: 2px solid #e8f5e8;
            padding: 0.75rem 1rem;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.9);
        }
        
        .form-control:focus, .form-select:focus {
            border-color: #66bb6a;
            box-shadow: 0 0 20px rgba(102, 187, 106, 0.2);
            background: white;
        }
        
        .form-label {
            color: #2e7d32;
            font-weight: 600;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #4caf50 0%, #66bb6a 100%);
            border: none;
            border-radius: 20px;
            padding: 1rem 2rem;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(76, 175, 80, 0.3);
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #388e3c 0%, #4caf50 100%);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(76, 175, 80, 0.4);
        }
        
        .btn-secondary {
            background: linear-gradient(135deg, #81c784 0%, #a5d6a7 100%);
            border: none;
            border-radius: 20px;
            color: white;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-secondary:hover {
            background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
            color: white;
            transform: translateY(-2px);
        }
        
        .checkout-icon {
            background: linear-gradient(135deg, #4caf50 0%, #66bb6a 100%);
            color: white;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            font-size: 1.5rem;
            box-shadow: 0 5px 15px rgba(76, 175, 80, 0.3);
        }
        
        .payment-option {
            transition: all 0.3s ease;
        }
        
        .payment-option:hover {
            background: rgba(200, 230, 201, 0.3);
        }
        
        /* Animasi loading untuk tombol */
        .btn-loading {
            position: relative;
            color: transparent;
        }
        
        .btn-loading:after {
            content: "";
            position: absolute;
            width: 16px;
            height: 16px;
            top: 50%;
            left: 50%;
            margin-left: -8px;
            margin-top: -8px;
            border-radius: 50%;
            border: 2px solid transparent;
            border-top-color: #ffffff;
            animation: spin 1s ease infinite;
        }
        
        @keyframes spin {
            to {
                transform: rotate(360deg);
            }
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .page-header {
                margin-bottom: 1rem;
                padding: 1.5rem 0;
            }
            
            .card {
                margin-bottom: 1rem;
            }
            
            .table-responsive {
                font-size: 0.9rem;
            }
        }
    </style>
</head>
<body>
    <%
    String status = request.getParameter("status");
    if ("sukses".equals(status)) {
%>
   <div class="alert alert-primary alert-dismissible fade show text-center mx-5" role="alert">
        <strong>Pesanan Anda sedang diproses.</strong> Terima kasih telah berbelanja!
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
<%
    }
%>

    <div class="page-header">
        <div class="container">
            <div class="text-center">
                <div class="checkout-icon">
                    <i class="fas fa-shopping-cart"></i>
                </div>
                <h2><i class="fas fa-check-circle me-2"></i>Checkout</h2>
                <p>Konfirmasi belanjaan & isi data pengiriman Anda</p>
            </div>
        </div>
    </div>

    <div class="container mb-5">
        <div class="row g-4">
            <!-- Keranjang -->
            <div class="col-lg-7">
                <div class="card">
                    <div class="card-header">
                        <h5><i class="fas fa-shopping-bag me-2"></i>Barang di Keranjang</h5>
                    </div>
                    <div class="card-body p-4">
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th><i class="fas fa-box me-1"></i>Nama</th>
                                        <th><i class="fas fa-tag me-1"></i>Harga</th>
                                        <th><i class="fas fa-sort-numeric-up me-1"></i>Jumlah</th>
                                        <th><i class="fas fa-calculator me-1"></i>Subtotal</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <%
                                    for (ItemKeranjang item : keranjang) {
                                %>
                                    <tr>
                                        <td><%= item.getNama() %></td>
                                        <td>Rp <%= String.format("%,.0f", item.getHarga()) %></td>
                                        <td><%= item.getJumlah() %></td>
                                        <td>Rp <%= String.format("%,.0f", item.getSubtotal()) %></td>
                                    </tr>
                                <%
                                    }
                                %>
                                    <tr class="total-row">
                                        <td colspan="3"><i class="fas fa-wallet me-2"></i>Total Pembayaran</td>
                                        <td>Rp <%= String.format("%,.0f", total) %></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <a href="keranjang.jsp" class="btn btn-secondary mt-3">
                            <i class="fas fa-arrow-left me-2"></i>Kembali ke Keranjang
                        </a>
                    </div>
                </div>
            </div>

            <!-- Form Pengiriman -->
            <div class="col-lg-5">
                <div class="card">
                    <div class="card-header">
                        <h5><i class="fas fa-truck me-2"></i>Data Pengiriman</h5>
                    </div>
                    <div class="card-body p-4">
                        <form action="CheckoutServlet" method="post" id="checkoutForm">
                            <div class="mb-3">
                                <label class="form-label">
                                    <i class="fas fa-user"></i>Nama Penerima
                                </label>
                                <input type="text" class="form-control" name="nama_penerima" 
                                       placeholder="Masukkan nama lengkap penerima" required>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">
                                    <i class="fas fa-map-marker-alt"></i>Alamat Lengkap
                                </label>
                                <textarea class="form-control" name="alamat" rows="3" 
                                          placeholder="Masukkan alamat lengkap dengan detail" required></textarea>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">
                                    <i class="fas fa-phone"></i>No. Telepon
                                </label>
                                <input type="text" class="form-control" name="telepon" 
                                       placeholder="Contoh: 08123456789" required>
                            </div>
                            
                            <div class="mb-4">
                                <label class="form-label">
                                    <i class="fas fa-credit-card"></i>Metode Pembayaran
                                </label>
                                <select class="form-select payment-option" name="pembayaran" required>
                                    <option value="">-- Pilih Metode Pembayaran --</option>
                                    <option value="Transfer Bank">🏦 Transfer Bank</option>
                                    <option value="COD">🚚 COD (Bayar di Tempat)</option>
                                    <option value="E-Wallet">💳 E-Wallet (OVO, DANA, GoPay)</option>
                                </select>
                            </div>
                            
                            <input type="hidden" name="total" value="<%= total %>">
                            
                            <button type="submit" class="btn btn-primary w-100" id="submitBtn">
                                <i class="fas fa-check-circle me-2"></i>Order Sekarang
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Animasi loading saat submit form
        document.getElementById('checkoutForm').addEventListener('submit', function() {
            const submitBtn = document.getElementById('submitBtn');
            submitBtn.classList.add('btn-loading');
            submitBtn.disabled = true;
        });

        // Validasi nomor telepon
        document.querySelector('input[name="telepon"]').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '');
            if (value.length > 13) {
                value = value.substring(0, 13);
            }
            e.target.value = value;
        });

        // Auto-focus ke field pertama
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelector('input[name="nama_penerima"]').focus();
        });
    </script>
</body>
</html>