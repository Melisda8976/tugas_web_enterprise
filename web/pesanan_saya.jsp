<%@ page import="java.sql.*, javax.sql.*, javax.naming.*, java.util.*" %>
<%@ page session="true" %>
<%
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pesanan Saya - KuyBELI</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #00c851;
            --primary-dark: #00a843;
            --primary-light: #e8f5e8;
            --secondary-color: #6c757d;
            --success-color: #28a745;
            --info-color: #17a2b8;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --dark-color: #343a40;
            --light-color: #f8f9fa;
            --white: #ffffff;
            --shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            --shadow-hover: 0 8px 30px rgba(0, 0, 0, 0.12);
            --border-radius: 12px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, var(--primary-color) 0%, #00ff6b 100%);
            min-height: 100vh;
            padding: 20px 0;
            color: var(--dark-color);
        }

        .main-container {
            background: var(--white);
            border-radius: 20px;
            padding: 40px;
            box-shadow: var(--shadow);
            max-width: 1400px;
            margin: 0 auto;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid var(--light-color);
        }

        .page-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--dark-color);
            margin: 0;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .page-title i {
            color: var(--primary-color);
            font-size: 2.2rem;
        }

        .stats-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: var(--white);
            padding: 20px;
            border-radius: var(--border-radius);
            text-align: center;
            box-shadow: var(--shadow);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-hover);
        }

        .stat-card i {
            font-size: 2rem;
            margin-bottom: 10px;
            opacity: 0.9;
        }

        .stat-card h4 {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .stat-card p {
            font-size: 0.9rem;
            opacity: 0.9;
            margin: 0;
        }

        .table-container {
            background: var(--white);
            border-radius: var(--border-radius);
            overflow: hidden;
            box-shadow: var(--shadow);
            border: 1px solid #e9ecef;
        }

        .table {
            margin: 0;
            font-size: 0.95rem;
        }

        .table thead th {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: var(--white);
            font-weight: 600;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border: none;
            padding: 18px 15px;
            text-align: center;
            vertical-align: middle;
        }

        .table tbody tr {
            transition: all 0.3s ease;
            border-bottom: 1px solid #f1f3f5;
        }

        .table tbody tr:hover {
            background-color: var(--primary-light);
            transform: scale(1.01);
            box-shadow: 0 2px 10px rgba(0, 200, 81, 0.1);
        }

        .table tbody td {
            padding: 20px 15px;
            vertical-align: middle;
            text-align: center;
            font-weight: 500;
        }

        .table tbody tr:last-child {
            border-bottom: none;
        }

        .status-badge {
            font-size: 0.8rem;
            font-weight: 600;
            padding: 8px 16px;
            border-radius: 20px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .status-badge i {
            font-size: 0.7rem;
        }

        .badge-pending {
            background: linear-gradient(135deg, #fff3cd, #ffeaa7);
            color: #856404;
            border: 1px solid #ffeaa7;
        }

        .badge-diproses {
            background: linear-gradient(135deg, #d1ecf1, #74b9ff);
            color: #0c5460;
            border: 1px solid #74b9ff;
        }

        .badge-dikirim {
            background: linear-gradient(135deg, #cce5ff, #0984e3);
            color: #004085;
            border: 1px solid #0984e3;
        }

        .badge-selesai {
            background: linear-gradient(135deg, #d4edda, #00b894);
            color: #155724;
            border: 1px solid #00b894;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
            justify-content: center;
        }

        .btn-action {
            border-radius: 8px;
            font-weight: 500;
            font-size: 0.85rem;
            padding: 8px 16px;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            border: none;
            cursor: pointer;
        }

        .btn-view {
            background: linear-gradient(135deg, #0984e3, #74b9ff);
            color: var(--white);
        }

        .btn-view:hover {
            background: linear-gradient(135deg, #0770c2, #5a9df7);
            color: var(--white);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(9, 132, 227, 0.3);
        }

        .btn-back {
            background: linear-gradient(135deg, var(--secondary-color), #8d9498);
            color: var(--white);
            padding: 12px 24px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            margin-top: 30px;
        }

        .btn-back:hover {
            background: linear-gradient(135deg, #5a6268, #6c757d);
            color: var(--white);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(108, 117, 125, 0.3);
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: var(--secondary-color);
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 20px;
            color: #dee2e6;
        }

        .empty-state h4 {
            font-size: 1.5rem;
            margin-bottom: 10px;
            color: var(--secondary-color);
        }

        .empty-state p {
            font-size: 1rem;
            margin-bottom: 0;
        }

        .order-number {
            font-weight: 600;
            color: var(--primary-color);
        }

        .date-time {
            font-size: 0.9rem;
            color: var(--secondary-color);
        }

        .recipient-name {
            font-weight: 600;
            color: var(--dark-color);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .main-container {
                padding: 20px;
                margin: 10px;
            }

            .page-title {
                font-size: 2rem;
            }

            .table-container {
                overflow-x: auto;
            }

            .stats-cards {
                grid-template-columns: 1fr;
            }

            .action-buttons {
                flex-direction: column;
            }
        }

        /* Loading Animation */
        .loading {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid #f3f3f3;
            border-top: 3px solid var(--primary-color);
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Hover Effects */
        .table tbody tr:hover .order-number {
            color: var(--primary-dark);
        }

        .fade-in {
            animation: fadeIn 0.6s ease-in;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
    <div class="main-container fade-in">
        <div class="page-header">
            <h1 class="page-title">
                <i class="fas fa-shopping-bag"></i>
                Pesanan Saya
            </h1>
        </div>

       

        <div class="table-container">
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th><i class="fas fa-hashtag"></i> No</th>
                            <th><i class="fas fa-user"></i> Nama Penerima</th>
                            <th><i class="fas fa-calendar-alt"></i> Tanggal Pemesanan</th>
                            <th><i class="fas fa-info-circle"></i> Status</th>
                            <th><i class="fas fa-cogs"></i> Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db_toko", "root", "");

                                String sql = "SELECT id_invoice, nama_penerima, tanggal, status FROM invoice ORDER BY tanggal DESC";
                                ps = conn.prepareStatement(sql);
                                rs = ps.executeQuery();
                                
                                boolean hasData = false;
                                int no = 1;
                                while (rs.next()) {
                                    hasData = true;
                        %>
                        <tr>
                            <td>
                                <span class="order-number"><%= no++ %></span>
                            </td>
                            <td>
                                <span class="recipient-name"><%= rs.getString("nama_penerima") %></span>
                            </td>
                            <td>
                                <span class="date-time">
                                    <i class="fas fa-clock"></i>
                                    <%= new java.text.SimpleDateFormat("dd MMM yyyy, HH:mm").format(rs.getTimestamp("tanggal")) %>
                                </span>
                            </td>
                            <td>
                                <%
                                    String status = rs.getString("status");
                                    String badgeClass = "badge-secondary";
                                    String icon = "fas fa-question-circle";
                                    
                                    if ("pending".equalsIgnoreCase(status)) {
                                        badgeClass = "badge-pending";
                                        icon = "fas fa-clock";
                                    } else if ("diproses".equalsIgnoreCase(status)) {
                                        badgeClass = "badge-diproses";
                                        icon = "fas fa-cog";
                                    } else if ("dikirim".equalsIgnoreCase(status)) {
                                        badgeClass = "badge-dikirim";
                                        icon = "fas fa-truck";
                                    } else if ("selesai".equalsIgnoreCase(status)) {
                                        badgeClass = "badge-selesai";
                                        icon = "fas fa-check-circle";
                                    }
                                %>
                                <span class="status-badge <%= badgeClass %>">
                                    <i class="<%= icon %>"></i>
                                    <%= status %>
                                </span>
                            </td>
                            <td>
                                <div class="action-buttons">
                                    <a href="detail_pesanan.jsp?id_invoice=<%= rs.getInt("id_invoice") %>" 
                                       class="btn-action btn-view" 
                                       title="Lihat Detail Pesanan">
                                        <i class="fas fa-eye"></i>
                                        Lihat Detail
                                    </a>
                                </div>
                            </td>
                        </tr>
                        <%
                                }
                                
                                if (!hasData) {
                        %>
                        <tr>
                            <td colspan="5" class="empty-state">
                                <i class="fas fa-shopping-bag"></i>
                                <h4>Belum Ada Pesanan</h4>
                                <p>Anda belum memiliki pesanan. Mulai berbelanja sekarang!</p>
                            </td>
                        </tr>
                        <%
                                }
                            } catch (Exception e) {
                                out.println("<tr><td colspan='5' class='text-danger text-center'>");
                                out.println("<i class='fas fa-exclamation-triangle'></i><br>");
                                out.println("<strong>Terjadi Kesalahan:</strong><br>" + e.getMessage());
                                out.println("</td></tr>");
                            } finally {
                                if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                                if (ps != null) try { ps.close(); } catch (SQLException ignore) {}
                                if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>

        <a href="dashboard_user.jsp" class="btn-back">
            <i class="fas fa-arrow-left"></i>
            Kembali 
        </a>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Update total orders counter
        document.addEventListener('DOMContentLoaded', function() {
            const tableRows = document.querySelectorAll('tbody tr');
            const emptyStateRow = document.querySelector('.empty-state');
            let totalOrders = tableRows.length;
            
            if (emptyStateRow) {
                totalOrders = 0;
            }
            
            document.getElementById('totalOrders').textContent = totalOrders;
            
            // Add loading effect for buttons
            document.querySelectorAll('.btn-view').forEach(btn => {
                btn.addEventListener('click', function(e) {
                    const icon = this.querySelector('i');
                    const originalIcon = icon.className;
                    icon.className = 'loading';
                    
                    // Restore icon after a short delay (for demo purposes)
                    setTimeout(() => {
                        icon.className = originalIcon;
                    }, 1000);
                });
            });
        });

        // Smooth scroll and enhanced UX
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                document.querySelector(this.getAttribute('href')).scrollIntoView({
                    behavior: 'smooth'
                });
            });
        });
    </script>
</body>
</html>