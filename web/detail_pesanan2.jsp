<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String idInvoice = request.getParameter("id_invoice");
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Detail Pesanan</title>
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
           background: linear-gradient(135deg, #00c851, #00ff6b);
           font-family: 'Segoe UI', sans-serif;
           padding: 20px;
        }

        .main-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 25px;
            padding: 40px;
            box-shadow: 0 20px 60px rgba(45, 90, 39, 0.15);
            max-width: 1200px;
            margin: auto;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .page-header {
            text-align: center;
            margin-bottom: 40px;
            position: relative;
        }

        .page-title {
             background: linear-gradient(135deg, green);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-weight: 800;
            font-size: 2.5rem;
            margin-bottom: 10px;
        }

        .invoice-info {
            background: var(--soft-green);
            padding: 15px 25px;
            border-radius: 15px;
            margin-bottom: 30px;
            border-left: 5px solid var(--accent-green);
        }

        .invoice-info h5 {
            color: var(--primary-green);
            font-weight: 600;
            margin: 0;
        }

        .table-container {
            background: white;
            border-radius: 20px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(45, 90, 39, 0.1);
            margin-bottom: 30px;
        }

        .table {
            margin-bottom: 0;
            border-radius: 15px;
            overflow: hidden;
        }

        .table thead th {
            background: linear-gradient(135deg, green);
            color: white;
            font-weight: 600;
            text-align: center;
            padding: 18px 15px;
            border: none;
            font-size: 1.1rem;
            position: relative;
        }

        .table thead th:first-child {
            border-top-left-radius: 15px;
        }

        .table thead th:last-child {
            border-top-right-radius: 15px;
        }

        .table tbody td {
            padding: 15px;
            text-align: center;
            vertical-align: middle;
            border-color: #e9ecef;
            font-size: 1rem;
            transition: background-color 0.3s ease;
        }

        .table tbody tr:hover {
            background-color: rgba(104, 187, 89, 0.05);
        }

        .table tbody tr:nth-child(even) {
            background-color: rgba(248, 255, 254, 0.5);
        }

        .price-cell {
            color: var(--accent-green);
            font-weight: 600;
        }

        .qty-badge {
            background: var(--accent-green);
            color: white;
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: 600;
            display: inline-block;
            min-width: 50px;
        }

        .product-name {
            color: var(--primary-green);
            font-weight: 500;
        }

        /* Grand Total Section */
        .total-section {
            background: linear-gradient(135deg, green);
            color: white;
            padding: 25px 30px;
            border-radius: 20px;
            margin: 30px 0;
            box-shadow: 0 10px 30px rgba(45, 90, 39, 0.3);
            position: relative;
            overflow: hidden;
        }

        .total-section::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 100px;
            height: 100px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            transform: translate(30px, -30px);
        }

        .total-section::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 80px;
            height: 80px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 50%;
            transform: translate(-20px, 20px);
        }

        .total-content {
            position: relative;
            z-index: 1;
        }

        .total-label {
            font-size: 1.3rem;
            font-weight: 600;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
        }

        .total-amount {
            font-size: 2.2rem;
            font-weight: 800;
            color: #fff;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
        }

        .total-icon {
            font-size: 1.5rem;
            margin-right: 10px;
            opacity: 0.9;
        }

        .empty-state {
            text-align: center;
            color: #999;
            font-style: italic;
            padding: 40px;
        }

        .empty-state i {
            font-size: 4rem;
            color: #ddd;
            margin-bottom: 20px;
        }

        .error-state {
            background: rgba(220, 53, 69, 0.1);
            border: 2px solid rgba(220, 53, 69, 0.3);
            color: #dc3545;
            padding: 20px;
            border-radius: 15px;
            text-align: center;
        }

        .btn-back {
            background: linear-gradient(45deg, var(--accent-green));
            border: none;
            color: white;
            padding: 12px 30px;
            border-radius: 25px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            box-shadow: 0 5px 20px rgba(104, 187, 89, 0.3);
        }

        .btn-back:hover {
            background: linear-gradient(45deg, var(--primary-green), var(--light-green));
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(104, 187, 89, 0.4);
            color: white;
        }

        .btn-back i {
            margin-right: 8px;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .main-container {
                padding: 25px;
                margin: 10px;
            }
            
            .page-title {
                font-size: 2rem;
            }
            
            .table thead th,
            .table tbody td {
                padding: 12px 8px;
                font-size: 0.9rem;
            }
            
            .total-amount {
                font-size: 1.8rem;
            }
            
            .total-label {
                font-size: 1.1rem;
            }
        }

        @media (max-width: 576px) {
            .table-responsive {
                font-size: 0.8rem;
            }
            
            .qty-badge {
                padding: 6px 12px;
                font-size: 0.9rem;
            }
        }
    </style>
</head>
<body>
<div class="main-container">
    <div class="page-header">
        <h1 class="page-title">
            <i class="fas fa-receipt me-3"></i>Detail Pesanan
        </h1>
        <p class="text-muted">Rincian lengkap pesanan Anda</p>
    </div>

    <%-- Invoice Info --%>
    <div class="invoice-info">
        <h5><i class="fas fa-file-invoice me-2"></i>ID Invoice: <span class="text-primary"><%= idInvoice != null ? idInvoice : "N/A" %></span></h5>
    </div>

    <div class="table-container">
        <div class="table-responsive">
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th><i class="fas fa-list-ol me-2"></i>No</th>        
                        <th><i class="fas fa-box me-2"></i>Nama Barang</th>
                        <th><i class="fas fa-sort-amount-up me-2"></i>Qty</th>
                        <th><i class="fas fa-tag me-2"></i>Harga</th>
                        <th><i class="fas fa-calculator me-2"></i>Subtotal</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    double grandTotal = 0;
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db_toko", "root", "");

                        String sql = "SELECT * FROM detail_invoice WHERE id_invoice = ?";
                        stmt = conn.prepareStatement(sql);
                        stmt.setString(1, idInvoice);
                        rs = stmt.executeQuery();

                        boolean hasData = false;
                        int no = 1;
                        while (rs.next()) {
                            hasData = true;
                            double subtotal = rs.getDouble("subtotal");
                            grandTotal += subtotal;
                %>
                    <tr>
                        <td><span class="badge bg-secondary"><%= no++ %></span></td>
                        <td class="product-name"><%= rs.getString("nama_barang") %></td>
                        <td><span class="qty-badge"><%= rs.getInt("jumlah") %></span></td>
                        <td class="price-cell">Rp <%= String.format("%,.0f", rs.getDouble("harga")) %></td>
                        <td class="price-cell fw-bold">Rp <%= String.format("%,.0f", subtotal) %></td>
                    </tr>
                <%
                        }

                        if (!hasData) {
                %>
                    <tr>
                        <td colspan="5" class="empty-state">
                            <i class="fas fa-inbox"></i>
                            <h5>Tidak ada detail pesanan</h5>
                            <p>Tidak ada detail pesanan untuk invoice ini.</p>
                        </td>
                    </tr>
                <%
                        }
                    } catch (Exception e) {
                %>
                    <tr>
                        <td colspan="5" class="error-state">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <strong>Error:</strong> <%= e.getMessage() %>
                        </td>
                    </tr>
                <%
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                        if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
                        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>

    <%-- Grand Total Section --%>
    <% if (grandTotal > 0) { %>
    <div class="total-section">
        <div class="total-content">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <div class="total-label">
                        <i class="fas fa-money-bill-wave total-icon"></i>
                        Total Keseluruhan
                    </div>
                    <div class="text-light opacity-75">
                        <small><i class="fas fa-info-circle me-1"></i>Sudah termasuk semua item dalam pesanan</small>
                    </div>
                </div>
                <div class="col-md-4 text-md-end text-center mt-3 mt-md-0">
                    <div class="total-amount">
                        Rp <%= String.format("%,.0f", grandTotal) %>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <% } %>

    <div class="text-center">
        <a href="Data_pesanan.jsp" class="btn btn-back">
            <i class="fas fa-arrow-left"></i>Kembali 
        </a> <div class="text-center">
        
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Add smooth animations
    document.addEventListener('DOMContentLoaded', function() {
        // Animate table rows
        const rows = document.querySelectorAll('tbody tr');
        rows.forEach((row, index) => {
            row.style.opacity = '0';
            row.style.transform = 'translateY(20px)';
            setTimeout(() => {
                row.style.transition = 'all 0.5s ease';
                row.style.opacity = '1';
                row.style.transform = 'translateY(0)';
            }, index * 100);
        });

        // Animate total section
        const totalSection = document.querySelector('.total-section');
        if (totalSection) {
            setTimeout(() => {
                totalSection.style.opacity = '0';
                totalSection.style.transform = 'scale(0.9)';
                totalSection.style.transition = 'all 0.6s ease';
                setTimeout(() => {
                    totalSection.style.opacity = '1';
                    totalSection.style.transform = 'scale(1)';
                }, 100);
            }, 500);
        }
    });

    // Add hover effects
    document.querySelectorAll('.table tbody tr').forEach(row => {
        row.addEventListener('mouseenter', function() {
            this.style.transform = 'scale(1.02)';
            this.style.boxShadow = '0 5px 15px rgba(45, 90, 39, 0.1)';
        });
        
        row.addEventListener('mouseleave', function() {
            this.style.transform = 'scale(1)';
            this.style.boxShadow = 'none';
        });
    });
</script>
</body>
</html>