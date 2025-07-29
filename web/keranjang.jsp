<%@ page import="java.util.*, model.ItemKeranjang" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<ItemKeranjang> keranjang = (List<ItemKeranjang>) session.getAttribute("keranjang");

    if (keranjang == null) {
        keranjang = new ArrayList<>();
        session.setAttribute("keranjang", keranjang);
    }

    // Aksi Update Jumlah Item
    String updateIdStr = request.getParameter("updateId");
    String newJumlahStr = request.getParameter("newJumlah");
    if (updateIdStr != null && newJumlahStr != null) {
        int updateId = Integer.parseInt(updateIdStr);
        int newJumlah = Integer.parseInt(newJumlahStr);
        
        if (newJumlah <= 0) {
            keranjang.removeIf(item -> item.getId() == updateId);
        } else {
            for (ItemKeranjang item : keranjang) {
                if (item.getId() == updateId) {
                    item.setJumlah(newJumlah);
                    break;
                }
            }
        }
        session.setAttribute("keranjang", keranjang);
        response.sendRedirect("keranjang.jsp");
        return;
    }

    // Aksi Hapus Item
    String hapusIdStr = request.getParameter("hapusId");
    if (hapusIdStr != null) {
        int hapusId = Integer.parseInt(hapusIdStr);
        keranjang.removeIf(item -> item.getId() == hapusId);
        session.setAttribute("keranjang", keranjang);
        response.sendRedirect("keranjang.jsp");
        return;
    }

    // Aksi Clear All
    String clearAll = request.getParameter("clearAll");
    if ("true".equals(clearAll)) {
        keranjang.clear();
        session.setAttribute("keranjang", keranjang);
        response.sendRedirect("keranjang.jsp");
        return;
    }

    // Aksi Tambah Item
    String idStr = request.getParameter("id");
    String nama = request.getParameter("nama");
    String hargaStr = request.getParameter("harga");
    String jumlahStr = request.getParameter("jumlah");

    if (idStr != null && nama != null && hargaStr != null && jumlahStr != null) {
        int id = Integer.parseInt(idStr);
        double harga = Double.parseDouble(hargaStr);
        int jumlah = Integer.parseInt(jumlahStr);

        boolean ditemukan = false;
        for (ItemKeranjang item : keranjang) {
            if (item.getId() == id) {
                item.setJumlah(item.getJumlah() + jumlah);
                ditemukan = true;
                break;
            }
        }

        if (!ditemukan) {
            keranjang.add(new ItemKeranjang(id, nama, harga, jumlah));
        }

        session.setAttribute("keranjang", keranjang);
        response.sendRedirect("keranjang.jsp");
        return;
    }

    double total = 0;
    int totalItems = 0;
    boolean keranjangKosong = keranjang.isEmpty();
    
    for (ItemKeranjang item : keranjang) {
        total += item.getSubtotal();
        totalItems += item.getJumlah();
    }
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Keranjang Belanja</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
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
            max-width: 1200px;
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
        }

        .cart-summary {
            background: linear-gradient(135deg, var(--primary-color), var(--accent-green));
            color: white;
            padding: 15px 20px;
            border-radius: 15px;
            text-align: center;
            min-width: 200px;
        }

        .btn-custom { 
            background: var(--primary-color); 
            color: white; 
            border-radius: 25px;
            border: none;
            padding: 10px 20px;
            transition: all 0.3s ease;
        }
        
        .btn-custom:hover { 
            background: var(--primary-hover); 
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(45,90,39,0.3);
        }

        .table {
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
        }

        .table th {
            background: var(--secondary-color);
            border: none;
            font-weight: 600;
            color: var(--primary-color);
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
        }

        .table td {
            border: none;
            border-bottom: 1px solid #e9ecef;
            vertical-align: middle;
            padding: 15px;
        }

        .quantity-controls {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .quantity-btn {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            border: 2px solid var(--accent-green);
            background: white;
            color: var(--accent-green);
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .quantity-btn:hover {
            background: var(--accent-green);
            color: white;
        }

        .quantity-input {
            width: 60px;
            text-align: center;
            border: 2px solid var(--light-green);
            border-radius: 8px;
            padding: 5px;
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

        .checkout-section {
            margin-top: 30px;
            padding: 25px;
            background: linear-gradient(135deg, var(--secondary-color), #e8f5e8);
            border-radius: 15px;
            border: 2px solid var(--light-green);
        }

        .total-display {
            font-size: 1.5rem;
            font-weight: bold;
            color: var(--primary-color);
            text-align: right;
            background: white;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            border: 2px solid var(--light-green);
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
        }

        .btn-danger-outline {
            background: white;
            color: var(--danger-color);
            border: 2px solid var(--danger-color);
            border-radius: 25px;
            padding: 8px 15px;
            transition: all 0.3s ease;
        }

        .btn-danger-outline:hover {
            background: var(--danger-color);
            color: white;
        }

        .loading {
            opacity: 0.6;
            pointer-events: none;
        }

        @media (max-width: 768px) {
            .page-header {
                flex-direction: column;
                gap: 15px;
            }
            
            .action-buttons {
                flex-direction: column;
                align-items: stretch;
            }
            
            .quantity-controls {
                flex-direction: column;
                gap: 5px;
            }
        }

        .fade-in {
            animation: fadeIn 0.5s ease-in;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
<div class="main-container mt-3 fade-in">
    <div class="page-header">
        <div>
            <h2 class="mb-0">
                <i class="fas fa-shopping-cart me-2"></i>Keranjang Belanja
            </h2>
            <small class="text-muted">Kelola item belanja Anda</small>
        </div>
        <% if (!keranjangKosong) { %>
        <div class="cart-summary">
            <div><strong><%= totalItems %></strong> Items</div>
            <div><small>Total: Rp <%= String.format("%,.0f", total) %></small></div>
        </div>
        <% } %>
    </div>

    <div class="table-responsive">
        <table class="table">
            <thead>
                <tr>
                    <th><i class="fas fa-box me-1"></i>Nama Barang</th>
                    <th><i class="fas fa-tag me-1"></i>Harga</th>
                    <th><i class="fas fa-sort-numeric-up me-1"></i>Jumlah</th>
                    <th><i class="fas fa-calculator me-1"></i>Subtotal</th>
                    <th><i class="fas fa-cogs me-1"></i>Aksi</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if (keranjangKosong) {
                %>
                    <tr>
                        <td colspan="5" class="empty-state">
                            <i class="fas fa-shopping-cart"></i>
                            <h4>Keranjang Kosong</h4>
                            <p class="mb-0">Belum ada barang yang ditambahkan ke keranjang</p>
                        </td>
                    </tr>
                <%
                    } else {
                        for (ItemKeranjang item : keranjang) {
                            double subtotal = item.getSubtotal();
                %>
                    <tr class="cart-item" data-id="<%= item.getId() %>">
                        <td>
                            <strong><%= item.getNama() %></strong>
                        </td>
                        <td>
                            <span class="text-success fw-bold" style="color: var(--accent-green) !important;">
                                Rp <%= String.format("%,.0f", item.getHarga()) %>
                            </span>
                        </td>
                        <td>
                            <div class="quantity-controls">
                                <button type="button" class="quantity-btn" onclick="updateQuantity(<%= item.getId() %>, <%= item.getJumlah() - 1 %>)">
                                    <i class="fas fa-minus"></i>
                                </button>
                                <input type="number" class="quantity-input" value="<%= item.getJumlah() %>" 
                                       min="1" max="99" 
                                       onchange="updateQuantity(<%= item.getId() %>, this.value)">
                                <button type="button" class="quantity-btn" onclick="updateQuantity(<%= item.getId() %>, <%= item.getJumlah() + 1 %>)">
                                    <i class="fas fa-plus"></i>
                                </button>
                            </div>
                        </td>
                        <td>
                            <strong style="color: var(--primary-color);">
                                Rp <%= String.format("%,.0f", subtotal) %>
                            </strong>
                        </td>
                        <td>
                            <button type="button" class="btn btn-danger btn-sm" 
                                    onclick="removeItem(<%= item.getId() %>, '<%= item.getNama() %>')">
                                <i class="fas fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                <%
                        }
                    }
                %>
            </tbody>
            <% if (!keranjangKosong) { %>
            <tfoot>
                <tr class="table-light">
                    <th colspan="4" class="text-end">
                        <i class="fas fa-calculator me-2"></i>Total Keseluruhan
                    </th>
                    <th class="text-primary">
                        Rp <%= String.format("%,.0f", total) %>
                    </th>
                </tr>
            </tfoot>
            <% } %>
        </table>
    </div>

    <div class="checkout-section">
        <% if (!keranjangKosong) { %>
            <div class="total-display">
                <i class="fas fa-receipt me-2"></i>
                Total Pembayaran: Rp <%= String.format("%,.0f", total) %>
            </div>
        <% } %>
        
        <div class="action-buttons">
            <div>
                <a href="dashboard_user.jsp" class="btn btn-secondary">
                    <i class="fas fa-arrow-left me-1"></i> Lanjut Belanja
                </a>
                <% if (!keranjangKosong) { %>
                <button type="button" class="btn btn-danger-outline ms-2" onclick="clearCart()">
                    <i class="fas fa-trash-alt me-1"></i> Kosongkan Keranjang
                </button>
                <% } %>
            </div>
            
            <div>
                <form action="checkout.jsp" method="post" id="checkoutForm" class="d-inline">
                    <input type="hidden" name="total" value="<%= total %>">
                    <button type="submit" class="btn btn-success btn-lg" 
                            <%= keranjangKosong ? "disabled" : "" %>>
                        <i class="fas fa-credit-card me-2"></i>
                        <%= keranjangKosong ? "Keranjang Kosong" : "Checkout Sekarang" %>
                    </button>
                </form>
            </div>
        </div>
        
        <% if (keranjangKosong) { %>
            <div class="text-center mt-3 text-muted">
                <i class="fas fa-info-circle me-1"></i>
                Tambahkan barang ke keranjang untuk melanjutkan checkout
            </div>
        <% } %>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function updateQuantity(itemId, newQuantity) {
        if (newQuantity < 1) {
            removeItem(itemId, '');
            return;
        }
        
        if (newQuantity > 99) {
            alert('Maksimal jumlah adalah 99 item');
            return;
        }
        
        const form = document.createElement('form');
        form.method = 'POST';
        form.style.display = 'none';
        
        const updateIdInput = document.createElement('input');
        updateIdInput.name = 'updateId';
        updateIdInput.value = itemId;
        form.appendChild(updateIdInput);
        
        const newJumlahInput = document.createElement('input');
        newJumlahInput.name = 'newJumlah';
        newJumlahInput.value = newQuantity;
        form.appendChild(newJumlahInput);
        
        document.body.appendChild(form);
        
        // Add loading state
        const row = document.querySelector(`tr[data-id="${itemId}"]`);
        if (row) row.classList.add('loading');
        
        form.submit();
    }
    
    function removeItem(itemId, itemName) {
        const message = itemName ? 
            `Hapus "${itemName}" dari keranjang?` : 
            'Hapus item ini dari keranjang?';
            
        if (confirm(message)) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.style.display = 'none';
            
            const hapusIdInput = document.createElement('input');
            hapusIdInput.name = 'hapusId';
            hapusIdInput.value = itemId;
            form.appendChild(hapusIdInput);
            
            document.body.appendChild(form);
            
            // Add loading state
            const row = document.querySelector(`tr[data-id="${itemId}"]`);
            if (row) row.classList.add('loading');
            
            form.submit();
        }
    }
    
    function clearCart() {
        if (confirm('Apakah Anda yakin ingin mengosongkan seluruh keranjang?')) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.style.display = 'none';
            
            const clearAllInput = document.createElement('input');
            clearAllInput.name = 'clearAll';
            clearAllInput.value = 'true';
            form.appendChild(clearAllInput);
            
            document.body.appendChild(form);
            
            // Add loading state
            document.querySelector('.main-container').classList.add('loading');
            
            form.submit();
        }
    }
    
    // Checkout form validation
    document.getElementById('checkoutForm').addEventListener('submit', function(e) {
        <% if (keranjangKosong) { %>
            e.preventDefault();
            alert('Keranjang Anda masih kosong! Silakan tambahkan barang terlebih dahulu.');
            return false;
        <% } %>
        
        // Add loading state for checkout
        this.querySelector('button').innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Memproses...';
        this.querySelector('button').disabled = true;
    });
    
    // Prevent double submission
    let isSubmitting = false;
    document.querySelectorAll('form').forEach(form => {
        form.addEventListener('submit', function(e) {
            if (isSubmitting) {
                e.preventDefault();
                return false;
            }
            isSubmitting = true;
        });
    });
    
    // Auto-resize table on mobile
    function adjustTableForMobile() {
        if (window.innerWidth < 768) {
            const table = document.querySelector('.table');
            if (table) {
                table.style.fontSize = '0.85rem';
            }
        }
    }
    
    window.addEventListener('resize', adjustTableForMobile);
    adjustTableForMobile();
</script>
</body>
</html>