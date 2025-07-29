<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Data Pesanan</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #2d5a27;
            --primary-hover: #1e3a1a;
            --light-green: #90c695;
            --lighter-green: #a8d5a8;
            --accent-green: #4a7c59;
            --secondary-color: #f0f8f0;
            --danger-color: #dc3545;
            --warning-color: #ffc107;
            --info-color: #0dcaf0;
            --success-color: #198754;
        }

        body {
            background: linear-gradient(135deg, var(--light-green), var(--lighter-green));
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            padding: 20px 0;
        }

        .main-container {
            background: #fff;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.15);
            max-width: 1400px;
            margin: auto;
            position: relative;
            overflow: hidden;
        }

        .main-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(90deg, var(--primary-color), var(--light-green));
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid var(--secondary-color);
            flex-wrap: wrap;
            gap: 15px;
        }

        .header-title {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .header-stats {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .stat-card {
            background: linear-gradient(135deg, var(--primary-color), var(--accent-green));
            color: white;
            padding: 15px 20px;
            border-radius: 15px;
            text-align: center;
            min-width: 120px;
            box-shadow: 0 5px 15px rgba(45,90,39,0.2);
        }

        .stat-number {
            font-size: 1.5rem;
            font-weight: bold;
            display: block;
        }

        .stat-label {
            font-size: 0.8rem;
            opacity: 0.9;
        }

        .table-container {
            overflow-x: auto;
            margin-bottom: 20px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
        }

        .table {
            min-width: 900px;
            margin-bottom: 0;
            border-radius: 15px;
            overflow: hidden;
        }

        .table th {
            background: var(--secondary-color);
            border: none;
            font-weight: 600;
            color: var(--primary-color);
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
            padding: 15px 12px;
        }

        .table td {
            border: none;
            border-bottom: 1px solid #e9ecef;
            vertical-align: middle;
            padding: 15px 12px;
        }

        .table tbody tr {
            transition: all 0.2s ease;
        }

        .table tbody tr:hover {
            background-color: rgba(144,198,149,0.1);
            transform: translateY(-1px);
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        /* Pengaturan lebar kolom */
        .table th:nth-child(1), .table td:nth-child(1) { width: 8%; text-align: center; }
        .table th:nth-child(2), .table td:nth-child(2) { 
            width: 25%; 
            text-align: left;
        }
        .table th:nth-child(3), .table td:nth-child(3) { width: 20%; text-align: center; }
        .table th:nth-child(4), .table td:nth-child(4) { width: 15%; text-align: center; }
        .table th:nth-child(5), .table td:nth-child(5) { width: 32%; text-align: center; }

        .customer-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .customer-avatar {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--light-green), var(--accent-green));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 0.9rem;
        }

        .customer-name {
            font-weight: 600;
            color: var(--primary-color);
        }

        .date-display {
            color: #6c757d;
            font-size: 0.9rem;
        }

        .date-day {
            font-weight: 600;
            color: var(--primary-color);
            display: block;
        }

        /* Status badges dengan animasi */
        .status-badge {
            font-size: 0.75em;
            padding: 0.5em 0.8em;
            border-radius: 20px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            position: relative;
            overflow: hidden;
            animation: fadeIn 0.3s ease;
        }

        .status-pending {
            background: linear-gradient(135deg, #ffc107, #ffed4e);
            color: #856404;
        }

        .status-diproses {
            background: linear-gradient(135deg, #0dcaf0, #6edff6);
            color: #055160;
        }

        .status-dikirim {
            background: linear-gradient(135deg, #0d6efd, #6ea8fe);
            color: #0a3b7a;
        }

        .status-selesai {
            background: linear-gradient(135deg, #198754, #51cf66);
            color: #0a3d2b;
        }

        /* Button styling */
        .btn-group-actions {
            display: flex;
            gap: 8px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn-action {
            font-size: 0.8em;
            padding: 0.4rem 0.8rem;
            border-radius: 20px;
            border: none;
            font-weight: 500;
            transition: all 0.2s ease;
            position: relative;
            overflow: hidden;
        }

        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        .btn-view {
            background: linear-gradient(135deg, var(--primary-color), var(--accent-green));
            color: white;
        }

        .btn-edit {
            background: linear-gradient(135deg, #ffc107, #ffed4e);
            color: #856404;
        }

        .btn-delete {
            background: linear-gradient(135deg, #dc3545, #f5c2c7);
            color: white;
        }

        .empty-state {
            text-align: center;
            color: #6c757d;
            font-style: italic;
            padding: 50px;
        }

        .empty-state i {
            font-size: 4rem;
            color: var(--light-green);
            margin-bottom: 20px;
        }

        /* Modal enhancements */
        .modal-content {
            border-radius: 15px;
            border: none;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }

        .modal-header {
            border-radius: 15px 15px 0 0;
            border-bottom: none;
            padding: 20px 25px;
        }

        .modal-body {
            padding: 25px;
        }

        .modal-footer {
            border-top: none;
            padding: 20px 25px;
        }

        .form-select {
            border-radius: 10px;
            border: 2px solid var(--light-green);
            padding: 10px 15px;
        }

        .form-select:focus {
            border-color: var(--accent-green);
            box-shadow: 0 0 0 0.2rem rgba(144,198,149,0.25);
        }

        /* Filter section */
        .filter-section {
            background: var(--secondary-color);
            padding: 20px;
            border-radius: 15px;
            margin-bottom: 20px;
        }

        .filter-row {
            display: flex;
            gap: 15px;
            align-items: end;
            flex-wrap: wrap;
        }

        .filter-group {
            flex: 1;
            min-width: 200px;
        }

        .filter-label {
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 5px;
            display: block;
        }

        /* Loading animation */
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255,255,255,0.9);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 9999;
        }

        .loading-spinner {
            width: 50px;
            height: 50px;
            border: 4px solid var(--light-green);
            border-top: 4px solid var(--primary-color);
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Responsive adjustments */
        @media (max-width: 1200px) {
            .main-container {
                margin: 10px;
                padding: 20px;
            }
        }

        @media (max-width: 992px) {
            .header-stats {
                width: 100%;
                justify-content: center;
            }
            
            .filter-row {
                flex-direction: column;
                align-items: stretch;
            }
            
            .btn-group-actions {
                flex-direction: column;
                gap: 5px;
            }
        }

        @media (max-width: 768px) {
            .table th:nth-child(2), .table td:nth-child(2) {
                min-width: 150px;
            }
            
            .customer-info {
                flex-direction: column;
                gap: 5px;
                text-align: center;
            }
            
            .customer-avatar {
                align-self: center;
            }
        }
    </style>
</head>
<body>
<div class="loading-overlay" id="loadingOverlay">
    <div class="loading-spinner"></div>
</div>

<div class="main-container">
    <div class="page-header">
        <div class="header-title">
            <h2 class="mb-0">
                <i class="fas fa-file-invoice me-2"></i>Daftar Pesanan
            </h2>
        </div>
        <div class="header-stats" id="headerStats">
            <!-- Stats akan diisi oleh JavaScript -->
        </div>
    </div>

    <!-- Filter Section -->
    <div class="filter-section">
        <div class="filter-row">
            <div class="filter-group">
                <label class="filter-label">
                    <i class="fas fa-filter me-1"></i>Filter Status
                </label>
                <select class="form-select" id="statusFilter" onchange="filterTable()">
                    <option value=""> Status</option>
                    <option value="pending">Pending</option>
                    <option value="diproses">Diproses</option>
                    <option value="dikirim">Dikirim</option>
                    <option value="selesai">Selesai</option>
                </select>
            </div>
            <div class="filter-group">
                <label class="filter-label">
                    <i class="fas fa-search me-1"></i>Cari Nama
                </label>
                <input type="text" class="form-select" id="nameSearch" 
                       placeholder="Ketik nama penerima..." onkeyup="filterTable()">
            </div>
            <div class="filter-group" style="flex: 0;">
                <button class="btn btn-outline-secondary" onclick="resetFilters()">
                    <i class="fas fa-undo me-1"></i>Reset
                </button>
            </div>
        </div>
    </div>

    <div class="table-container">
        <table class="table" id="invoiceTable">
            <thead>
                <tr>
                    <th><i class="fas fa-hashtag me-1"></i>ID</th>
                    <th><i class="fas fa-user me-1"></i>Pelanggan/Penerima</th>
                    <th><i class="fas fa-calendar me-1"></i>Tanggal</th>
                    <th><i class="fas fa-info-circle me-1"></i>Status</th>
                    <th><i class="fas fa-cogs me-1"></i>Aksi</th>
                </tr>
            </thead>
            <tbody>
            <%
                SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");
                SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
                int totalOrders = 0;
                int pendingCount = 0;
                int prosesCount = 0;
                int kirimCount = 0;
                int selesaiCount = 0;
                
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db_toko", "root", "");
                    PreparedStatement ps = conn.prepareStatement("SELECT id_invoice, nama_penerima, tanggal, status FROM invoice ORDER BY tanggal DESC");
                    ResultSet rs = ps.executeQuery();

                    while (rs.next()) {
                        totalOrders++;
                        int id = rs.getInt("id_invoice");
                        String nama = rs.getString("nama_penerima");
                        Timestamp tanggal = rs.getTimestamp("tanggal");
                        String status = rs.getString("status") != null ? rs.getString("status") : "pending";

                        // Count status
                        switch(status.toLowerCase()) {
                            case "pending": pendingCount++; break;
                            case "diproses": prosesCount++; break;
                            case "dikirim": kirimCount++; break;
                            case "selesai": selesaiCount++; break;
                        }

                        String statusClass = "status-" + status.toLowerCase();
                        String initials = nama.length() >= 2 ? 
                            (nama.charAt(0) + "" + nama.charAt(1)).toUpperCase() : 
                            nama.substring(0, 1).toUpperCase();
            %>
            <tr data-status="<%= status.toLowerCase() %>" data-name="<%= nama.toLowerCase() %>">
                <td>
                    <strong class="text-primary">#<%= String.format("%04d", id) %></strong>
                </td>
                <td>
                    <div class="customer-info">
                        <div class="customer-avatar"><%= initials %></div>
                        <div>
                            <div class="customer-name"><%= nama %></div>
                        </div>
                    </div>
                </td>
                <td>
                    <div class="date-display">
                        <span class="date-day"><%= dateFormat.format(tanggal) %></span>
                        <small><%= timeFormat.format(tanggal) %></small>
                    </div>
                </td>
                <td>
                    <span class="status-badge <%= statusClass %>">
                        <i class="fas fa-circle me-1" style="font-size: 0.5em;"></i>
                        <%= status.toUpperCase() %>
                    </span>
                </td>
                <td>
                    <div class="btn-group-actions">
                        <a href="detail_pesanan2.jsp?id_invoice=<%= id %>" 
                           class="btn btn-action btn-view" title="Lihat Detail">
                            <i class="fas fa-eye me-1"></i>Lihat
                        </a>
                        <button class="btn btn-action btn-edit" 
                                data-bs-toggle="modal" 
                                data-bs-target="#editModal<%= id %>" 
                                title="Edit Status">
                            <i class="fas fa-edit me-1"></i>Edit
                        </button>
                        <button class="btn btn-action btn-delete" 
                                onclick="deleteInvoice(<%= id %>, '<%= nama %>')" 
                                title="Hapus Pesanan">
                            <i class="fas fa-trash me-1"></i>Hapus
                        </button>
                    </div>
                </td>
            </tr>

            <!-- Enhanced Modal Edit Status -->
            <div class="modal fade" id="editModal<%= id %>" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <form method="post" action="InvoiceServlet" onsubmit="showLoading()">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="id_invoice" value="<%= id %>">
                        <div class="modal-content">
                            <div class="modal-header" style="background: linear-gradient(135deg, var(--warning-color), #ffed4e);">
                                <h5 class="modal-title">
                                    <i class="fas fa-edit me-2"></i>Edit Status Pesanan
                                </h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label class="filter-label">Pesanan ID</label>
                                    <input type="text" class="form-control" value="#<%= String.format("%04d", id) %>" readonly>
                                </div>
                                <div class="mb-3">
                                    <label class="filter-label">Nama Pelanggan</label>
                                    <input type="text" class="form-control" value="<%= nama %>" readonly>
                                </div>
                                <div class="mb-3">
                                    <label for="status<%= id %>" class="filter-label">
                                        <i class="fas fa-info-circle me-1"></i>Status Pesanan
                                    </label>
                                    <select name="status" id="status<%= id %>" class="form-select" required>
                                        <option value="pending" <%= status.equalsIgnoreCase("pending") ? "selected" : "" %>>
                                            ? Pending - Menunggu Konfirmasi
                                        </option>
                                        <option value="diproses" <%= status.equalsIgnoreCase("diproses") ? "selected" : "" %>>
                                            ? Diproses - Sedang Diproses
                                        </option>
                                        <option value="dikirim" <%= status.equalsIgnoreCase("dikirim") ? "selected" : "" %>>
                                            ? Dikirim - Dalam Perjalanan
                                        </option>
                                        <option value="selesai" <%= status.equalsIgnoreCase("selesai") ? "selected" : "" %>>
                                            ? Selesai - Pesanan Selesai
                                        </option>
                                    </select>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                    <i class="fas fa-times me-1"></i>Batal
                                </button>
                                <button type="submit" class="btn" style="background: var(--warning-color); color: #856404;">
                                    <i class="fas fa-save me-1"></i>Simpan Perubahan
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <%
                    } // end while
                    
                    if (totalOrders == 0) {
            %>
            <tr>
                <td colspan="5" class="empty-state">
                    <i class="fas fa-inbox"></i>
                    <h4>Belum Ada Pesanan</h4>
                    <p class="mb-0">Belum ada pesanan yang masuk ke sistem</p>
                </td>
            </tr>
            <%
                    }
                    
                    rs.close();
                    ps.close();
                    conn.close();
                } catch (Exception e) {
                    out.println("<tr><td colspan='5' class='text-danger empty-state'>");
                    out.println("<i class='fas fa-exclamation-triangle'></i>");
                    out.println("<h4>Terjadi Kesalahan</h4>");
                    out.println("<p>Error: " + e.getMessage() + "</p>");
                    out.println("</td></tr>");
                }
            %>
            </tbody>
        </table>
    </div>

    <div class="d-flex justify-content-between align-items-center mt-4">
        <a href="dashboard_admin.jsp" class="btn btn-secondary">
            <i class="fas fa-arrow-left me-2"></i>Kembali 
        </a>
        <div class="text-muted">
            <i class="fas fa-info-circle me-1"></i>
            Total <strong id="visibleCount"><%= totalOrders %></strong> pesanan ditampilkan
        </div>
    </div>
</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Data statistik dari server
    const stats = {
        total: <%= totalOrders %>,
        pending: <%= pendingCount %>,
        diproses: <%= prosesCount %>,
        dikirim: <%= kirimCount %>,
        selesai: <%= selesaiCount %>
    };

    // Render header statistics
    function renderHeaderStats() {
        const headerStats = document.getElementById('headerStats');
        headerStats.innerHTML = `
            <div class="stat-card">
                <span class="stat-number">${stats.total}</span>
                <span class="stat-label">Total</span>
            </div>
            <div class="stat-card" style="background: linear-gradient(135deg, #ffc107, #ffed4e);">
                <span class="stat-number">${stats.pending}</span>
                <span class="stat-label">Pending</span>
            </div>
            <div class="stat-card" style="background: linear-gradient(135deg, #0dcaf0, #6edff6);">
                <span class="stat-number">${stats.diproses}</span>
                <span class="stat-label">Diproses</span>
            </div>
            <div class="stat-card" style="background: linear-gradient(135deg, #0d6efd, #6ea8fe);">
                <span class="stat-number">${stats.dikirim}</span>
                <span class="stat-label">Dikirim</span>
            </div>
            <div class="stat-card" style="background: linear-gradient(135deg, #198754, #51cf66);">
                <span class="stat-number">${stats.selesai}</span>
                <span class="stat-label">Selesai</span>
            </div>
        `;
    }

    // Filter table function
    function filterTable() {
        const statusFilter = document.getElementById('statusFilter').value.toLowerCase();
        const nameSearch = document.getElementById('nameSearch').value.toLowerCase();
        const rows = document.querySelectorAll('#invoiceTable tbody tr[data-status]');
        let visibleCount = 0;

        rows.forEach(row => {
            const status = row.getAttribute('data-status');
            const name = row.getAttribute('data-name');
            
            const statusMatch = !statusFilter || status === statusFilter;
            const nameMatch = !nameSearch || name.includes(nameSearch);
            
            if (statusMatch && nameMatch) {
                row.style.display = '';
                visibleCount++;
            } else {
                row.style.display = 'none';
            }
        });

        document.getElementById('visibleCount').textContent = visibleCount;
    }

    // Reset filters
    function resetFilters() {
        document.getElementById('statusFilter').value = '';
        document.getElementById('nameSearch').value = '';
        filterTable();
    }

    // Delete invoice with confirmation
    function deleteInvoice(id, nama) {
        if (confirm(`Apakah Anda yakin ingin menghapus pesanan dari "${nama}"?\n\nTindakan ini tidak dapat dibatalkan!`)) {
            showLoading();
            window.location.href = `InvoiceServlet?action=delete&id=${id}`;
        }
    }

    // Show loading overlay
    function showLoading() {
        document.getElementById('loadingOverlay').style.display = 'flex';
    }

    // Hide loading overlay
    function hideLoading() {
        document.getElementById('loadingOverlay').style.display = 'none';
    }

    // Initialize page
    document.addEventListener('DOMContentLoaded', function() {
        renderHeaderStats();
        
        // Hide loading when page is fully loaded
        window.addEventListener('load', hideLoading);
        
        // Auto-hide loading after 3 seconds as fallback
        setTimeout(hideLoading, 3000);
    });

    // Enhanced form submission with validation
    document.querySelectorAll('form[action="InvoiceServlet"]').forEach(form => {
        form.addEventListener('submit', function(e) {
            const statusSelect = this.querySelector('select[name="status"]');
            if (statusSelect && !statusSelect.value) {
                e.preventDefault();
                alert('Silakan pilih status pesanan!');
                return false;
            }
            showLoading();
        });
    });

    // Smooth scroll to top when filters change
    function smoothScrollToTop() {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    }

    // Add keyboard shortcuts
    document.addEventListener('keydown', function(e) {
        // Ctrl + F untuk fokus ke search
        if (e.ctrlKey && e.key === 'f') {
            e.preventDefault();
            document.getElementById('nameSearch').focus();
        }
        
        // Escape untuk reset filters
        if (e.key === 'Escape') {
            resetFilters();
        }
    });
</script>
</body>
</html>