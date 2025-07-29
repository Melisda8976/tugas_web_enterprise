<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Data Barang</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
         body {
            background: linear-gradient(135deg, #00c851, #00ff6b);
            font-family: 'Segoe UI', sans-serif;
            padding: 20px;
            
        .main-container {
            background: #fff;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            max-width: 1200px;
            margin: auto;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .product-image {
            max-height: 80px;
            max-width: 100px;
            object-fit: cover;
            border-radius: 5px;
        }

        .btn-custom {
            background-color: #007bff;
            color: white;
        }

        .modal-header-custom {
            background-color: #007bff;
            color: white;
        }

        .empty-state {
            text-align: center;
            font-style: italic;
        }

        .table td {
            vertical-align: middle;
        }
        
        .td, th {
            text-align: center;
            vertical-align: middle;
        }

        

        .btn-group-vertical .btn {
            margin-bottom: 2px;
        }
    </style>
</head>
<body>
<div class="main-container">
    <!-- Header -->
    <div class="page-header">
        <h2>Data Barang</h2>
        <div>
            <button class="btn btn-custom" data-toggle="modal" data-target="#barangModal" onclick="resetForm()">
                <i class="fas fa-plus"></i> Tambah Barang
            </button>
            <button class="btn btn-danger" onclick="clearAllData()">
                <i class="fas fa-trash"></i> Hapus Semua
            </button>
        </div>
    </div>

    <!-- Alert Messages -->
    <% 
        String message = request.getParameter("message");
        String error = request.getParameter("error");
        if (message != null) {
    %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <%= message %>
            <button type="button" class="close" data-dismiss="alert">&times;</button>
        </div>
    <% } if (error != null) { %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <%= error %>
            <button type="button" class="close" data-dismiss="alert">&times;</button>
        </div>
    <% } %>

    <!-- Table -->
    <div class="table-responsive">
        <table class="table table-bordered table-hover">
            <thead class="thead-light">
            <tr>
                <th width="5%">No</th>
                <th width="25%">Nama</th>
                <th width="20%">Gambar</th>
                <th width="10%">Stok</th>
                <th width="20%">Harga</th>
                <th width="20%">Aksi</th>
            </tr>
            </thead>
            <tbody>
            <%
                Connection conn = null;
                Statement stmt = null;
                ResultSet rs = null;
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db_toko", "root", "");
                    stmt = conn.createStatement();
                    rs = stmt.executeQuery("SELECT * FROM barang ORDER BY id_barang ASC");
                    boolean hasData = false;
                    int nomor = 1;
                    while (rs.next()) {
                        hasData = true;
                        int id = rs.getInt("id_barang");
                        String nama = rs.getString("nama_barang");
                        String gambar = rs.getString("gambar");
                        int stok = rs.getInt("stok");
                        double harga = rs.getDouble("harga");
                        
                        // Escape quotes untuk JavaScript
                        String namaEscaped = nama != null ? nama.replace("'", "\\'").replace("\"", "\\\"") : "";
                        String gambarEscaped = gambar != null ? gambar.replace("'", "\\'").replace("\"", "\\\"") : "";
            %>
            <tr>
                <td><%= nomor++ %></td>
                <td><%= nama %></td>
                <td>
                    <% if (gambar != null && !gambar.isEmpty()) { %>
                        <img src="uploads/<%= gambar %>" class="product-image" alt="<%= nama %>" 
                             onerror="this.style.display='none'; this.nextElementSibling.style.display='block';" />
                        <div style="display:none; text-align:center; font-style:italic;">
                            <small>Gambar tidak ditemukan</small>
                        </div>
                    <% } else { %>
                        <div class="text-center">
                            <em class="text-muted">Tanpa Gambar</em>
                        </div>
                    <% } %>
                </td>
                <td>
                    <span class="badge <%= stok <= 5 ? "badge-danger" : "badge-success" %>">
                        <%= stok %>
                    </span>
                </td>
                <td>Rp <%= String.format("%,.0f", harga).replace(',', '.') %></td>
                <td>
                    <div class="btn-group-vertical btn-group-sm" role="group">
                        <button class="btn btn-warning btn-sm" 
                                onclick="editBarang(<%= id %>, '<%= namaEscaped %>', '<%= gambarEscaped %>', <%= stok %>, <%= harga %>)"
                                title="Edit Barang">
                            <i class="fas fa-edit"></i> Edit
                        </button>
                        <button class="btn btn-danger btn-sm" 
                                onclick="deleteBarang(<%= id %>, '<%= namaEscaped %>')"
                                title="Hapus Barang">
                            <i class="fas fa-trash"></i> Hapus
                        </button>
                    </div>
                </td>
            </tr>
            <%
                    }
                    if (!hasData) {
            %>
            <tr>
                <td colspan="6" class="empty-state text-center py-4">
                    <div>
                        <i class="fas fa-box-open fa-3x text-muted mb-3"></i>
                        <p class="text-muted">Belum ada data barang.</p>
                        <button class="btn btn-custom" data-toggle="modal" data-target="#barangModal" onclick="resetForm()">
                            Tambah Barang Pertama
                        </button>
                    </div>
                </td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='6' class='text-danger text-center py-4'>");
                    out.println("<i class='fas fa-exclamation-triangle'></i> Error: " + e.getMessage());
                    out.println("</td></tr>");
                    e.printStackTrace();
                } finally {
                    try { 
                        if (rs != null) rs.close(); 
                        if (stmt != null) stmt.close(); 
                        if (conn != null) conn.close(); 
                    } catch (SQLException ignored) {}
                }
            %>
            </tbody>
        </table>
    </div>

    <!-- Modal Form -->
    <div class="modal fade" id="barangModal" tabindex="-1" role="dialog" aria-labelledby="barangModalLabel">
        <div class="modal-dialog" role="document">
            <form action="BarangServlet" method="post" enctype="multipart/form-data" id="barangForm">
                <div class="modal-content">
                    <div class="modal-header modal-header-custom">
                        <h5 class="modal-title" id="barangModalLabel">Form Barang</h5>
                        <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="id" id="id_barang">
                        <input type="hidden" name="action" id="action" value="save">
                        
                        <div class="form-group">
                            <label for="nama_barang">Nama Barang <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="nama_barang" id="nama_barang" 
                                   required maxlength="100" placeholder="Masukkan nama barang">
                            <div class="invalid-feedback">
                                Nama barang harus diisi.
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="gambar">Gambar</label>
                            <input type="file" class="form-control-file" name="gambar" id="gambar" 
                                   accept="image/jpeg,image/jpg,image/png,image/gif">
                            <small id="gambarLabel" class="form-text text-muted"></small>
                            <small class="form-text text-muted">
                                Format yang didukung: JPG, JPEG, PNG, GIF. Maksimal 10MB.
                            </small>
                        </div>
                        
                        <div class="form-group">
                            <label for="stok">Stok <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" name="stok" id="stok" 
                                   required min="0" max="9999" placeholder="0">
                            <div class="invalid-feedback">
                                Stok harus berupa angka positif.
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="harga">Harga <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <div class="input-group-prepend">
                                    <span class="input-group-text">Rp</span>
                                </div>
                                <input type="number" class="form-control" name="harga" id="harga" 
                                       required min="1" step="1" placeholder="0">
                                <div class="invalid-feedback">
                                    Harga harus berupa angka positif.
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">
                            <i class="fas fa-times"></i> Batal
                        </button>
                        <button type="submit" class="btn btn-custom" id="submitBtn">
                            <i class="fas fa-save"></i> Simpan
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Back to dashboard -->
    <div class="text-center mt-4">
        <button class="btn btn-secondary" onclick="window.location.href='dashboard_admin.jsp'">
            <i class="fas fa-arrow-left"></i> Kembali ke Dashboard
        </button>
    </div>
</div>

<!-- JS -->
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/js/all.min.js"></script>

<script>
    // Function untuk edit barang
    function editBarang(id, nama, gambar, stok, harga) {
        console.log('Edit barang:', {id, nama, gambar, stok, harga}); // Debug log
        
        document.getElementById('id_barang').value = id;
        document.getElementById('nama_barang').value = nama;
        document.getElementById('stok').value = stok;
        document.getElementById('harga').value = harga;
        document.getElementById('action').value = 'update';
        document.getElementById('barangModalLabel').innerText = 'Edit Barang';
        document.getElementById('submitBtn').innerHTML = '<i class="fas fa-save"></i> Update';
        
        // Set info gambar lama
        const gambarLabel = document.getElementById('gambarLabel');
        if (gambar && gambar.trim() !== '') {
            gambarLabel.innerHTML = '<strong>Gambar saat ini:</strong> ' + gambar + '<br><small>Biarkan kosong jika tidak ingin mengubah gambar.</small>';
        } else {
            gambarLabel.innerHTML = '<small>Belum ada gambar. Upload gambar baru jika diperlukan.</small>';
        }
        
        // Reset file input
        document.getElementById('gambar').value = '';
        
        // Show modal
        $('#barangModal').modal('show');
    }

    // Function untuk reset form
    function resetForm() {
        document.getElementById('barangForm').reset();
        document.getElementById('id_barang').value = '';
        document.getElementById('action').value = 'save';
        document.getElementById('barangModalLabel').innerText = 'Tambah Barang';
        document.getElementById('submitBtn').innerHTML = '<i class="fas fa-save"></i> Simpan';
        document.getElementById('gambarLabel').innerHTML = '';
        
        // Remove validation classes
        const form = document.getElementById('barangForm');
        form.classList.remove('was-validated');
    }

    // Function untuk delete barang
    function deleteBarang(id, nama) {
        if (confirm('Yakin ingin menghapus barang "' + nama + '"?\nTindakan ini tidak dapat dibatalkan!')) {
            // Create form for POST request
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = 'BarangServlet';
            
            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'delete';
            
            const idInput = document.createElement('input');
            idInput.type = 'hidden';
            idInput.name = 'id_barang';
            idInput.value = id;
            
            form.appendChild(actionInput);
            form.appendChild(idInput);
            document.body.appendChild(form);
            form.submit();
        }
    }

    // Function untuk clear all data
    function clearAllData() {
        if (confirm("Yakin ingin menghapus SEMUA data barang?\nTindakan ini tidak dapat dibatalkan!")) {
            if (confirm("Konfirmasi sekali lagi: Hapus SEMUA data barang?")) {
                // Create form for POST request
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'BarangServlet';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'clear';
                
                form.appendChild(actionInput);
                document.body.appendChild(form);
                form.submit();
            }
        }
    }

    // Form validation
    document.getElementById('barangForm').addEventListener('submit', function(e) {
        const form = this;
        if (!form.checkValidity()) {
            e.preventDefault();
            e.stopPropagation();
        }
        form.classList.add('was-validated');
    });

    // Auto dismiss alerts
    setTimeout(function() {
        $('.alert').fadeOut('slow');
    }, 5000);

    // File upload validation
    document.getElementById('gambar').addEventListener('change', function() {
        const file = this.files[0];
        if (file) {
            const fileSize = file.size / 1024 / 1024; // MB
            const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'];
            
            if (fileSize > 10) {
                alert('Ukuran file terlalu besar! Maksimal 10MB.');
                this.value = '';
                return;
            }
            
            if (!allowedTypes.includes(file.type)) {
                alert('Format file tidak didukung! Gunakan JPG, JPEG, PNG, atau GIF.');
                this.value = '';
                return;
            }
        }
    });
</script>
</body>
</html>