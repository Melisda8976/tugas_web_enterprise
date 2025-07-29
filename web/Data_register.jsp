<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.cj.jdbc.Driver" %>
<%
  request.setCharacterEncoding("UTF-8");

  // Load Driver hanya sekali
  try {
    Class.forName("com.mysql.cj.jdbc.Driver");
  } catch (ClassNotFoundException e) {
    out.println("<script>alert('Driver tidak ditemukan: " + e.getMessage() + "');</script>");
  }

  // Proses Update
  if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("update") != null) {
    String nama = request.getParameter("nama");
    String emailBaru = request.getParameter("email");
    String password = request.getParameter("password");
    String role = request.getParameter("role"); 
    String emailLama = request.getParameter("email_lama");

    try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/user", "root", "");
         PreparedStatement pstmt = conn.prepareStatement("UPDATE users SET nama_lengkap=?, email=?, password=?, role=? WHERE email=?")) {

      pstmt.setString(1, nama);
      pstmt.setString(2, emailBaru);
      pstmt.setString(3, password);
      pstmt.setString(4, role);
      pstmt.setString(5, emailLama);

      pstmt.executeUpdate();
    } catch (Exception e) {
      out.println("<script>alert('Gagal update: " + e.getMessage() + "');</script>");
    }
  }

  // Proses Delete
  if (request.getParameter("delete_email") != null) {
    String emailHapus = request.getParameter("delete_email");

    try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/user", "root", "");
         PreparedStatement pstmt = conn.prepareStatement("DELETE FROM users WHERE email=?")) {

      pstmt.setString(1, emailHapus);
      pstmt.executeUpdate();
    } catch (Exception e) {
      out.println("<script>alert('Gagal hapus: " + e.getMessage() + "');</script>");
    }
  }
%>

<!DOCTYPE html>
<html lang="id">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Manajemen Pengguna</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" rel="stylesheet">
  <style>
    :root {
      --primary-color: #4f46e5;
      --primary-dark: #3730a3;
      --success-color: #059669;
      --warning-color: #f59e0b;
      --danger-color: #dc2626;
      --light-bg: #f8fafc;
      --card-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
      --border-radius: 12px;
    }

    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      background: green;
      min-height: 100vh;
      font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
      color: #1f2937;
    }

    .main-container {
      background: var(--light-bg);
      border-radius: var(--border-radius);
      box-shadow: var(--card-shadow);
      margin: 2rem auto;
      max-width: 1200px;
      overflow: hidden;
      animation: fadeInUp 0.6s ease-out;
    }

    .header-section {
      background: linear-gradient(135deg, #00cc00);
      color: white;
      padding: 2rem;
      position: center;
      overflow: hidden;
    }

    .header-section::before {
      content: '';
      position: absolute;
      top: -50%;
      right: -50%;
      width: 200%;
      height: 200%;
      background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
      animation: pulse 4s ease-in-out infinite;
    }

    .header-content {
      position: relative;
      z-index: 1;
    }

    .page-title {
      font-size: 2.5rem;
      font-weight: 700;
      margin-bottom: 0.5rem;
      text-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    .page-subtitle {
      font-size: 1.1rem;
      opacity: 0.9;
      margin-bottom: 2rem;
    }

    .stats-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 1.5rem;
      margin-top: 2rem;
    }

    .stat-card {
      background: green;
      backdrop-filter: blur(10px);
      border: 1px solid rgba(255, 255, 255, 0.2);
      border-radius: var(--border-radius);
      padding: 1.5rem;
      text-align: center;
      transition: transform 0.3s ease;
    }

    .stat-card:hover {
      transform: translateY(-5px);
    }

    .stat-number {
      font-size: 2rem;
      font-weight: 700;
      display: block;
    }

    .stat-label {
      font-size: 0.9rem;
      opacity: 0.8;
    }

    .content-section {
      padding: 2rem;
    }

    .action-bar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 2rem;
      flex-wrap: wrap;
      gap: 1rem;
    }

    .search-box {
      position: relative;
      flex: 1;
      max-width: 300px;
    }

    .search-box input {
      width: 100%;
      padding: 0.75rem 1rem 0.75rem 3rem;
      border: 2px solid #e5e7eb;
      border-radius: var(--border-radius);
      font-size: 0.95rem;
      transition: all 0.3s ease;
    }

    .search-box input:focus {
      outline: none;
      border-color: var(--primary-color);
      box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
    }

    .search-box i {
      position: absolute;
      left: 1rem;
      top: 50%;
      transform: translateY(-50%);
      color: #9ca3af;
    }

    .btn-modern {
      padding: 0.75rem 1.5rem;
      border-radius: var(--border-radius);
      font-weight: 600;
      text-decoration: none;
      transition: all 0.3s ease;
      border: none;
      cursor: pointer;
      display: inline-flex;
      align-items: center;
      gap: 0.5rem;
    }
    
    .btn-primary {
        z-index: 9999;
        position: relative;
      }
    .btn-primary-modern {
      background: #0062cc;
      color: white;
    }
    
    

    .btn-primary-modern:hover {
      background: #0062cc;
      transform: translateY(-2px);
      box-shadow: 0 8px 25px -8px var(--primary-color);
    }

    .btn-success-modern {
        background: green;
      color: white;
    }

    .btn-success-modern:hover {
      background: green;
      transform: translateY(-2px);
      box-shadow: 0 8px 25px -8px var(--success-color);
    }

    .btn-warning-modern {
      background: var(--warning-color);
      color: white;
    }

    .btn-warning-modern:hover {
      background: #d97706;
      transform: translateY(-2px);
      box-shadow: 0 8px 25px -8px var(--warning-color);
    }

    .btn-danger-modern {
      background: var(--danger-color);
      color: white;
    }

    .btn-danger-modern:hover {
      background: #b91c1c;
      transform: translateY(-2px);
      box-shadow: 0 8px 25px -8px var(--danger-color);
    }

    .data-table {
      background: white;
      border-radius: var(--border-radius);
      overflow: hidden;
      box-shadow: var(--card-shadow);
      margin-top: 1rem;
    }

    .table {
      margin-bottom: 0;
    }

    .table thead th {
      background: linear-gradient(135deg, green, lightgreen);
      color: white;
      font-weight: 600;
      border: none;
      padding: 1.25rem 1rem;
      text-transform: uppercase;
      font-size: 0.85rem;
      letter-spacing: 0.5px;
    }

    .table tbody tr {
      transition: all 0.3s ease;
      border-bottom: 1px solid #f1f5f9;
    }

    .table tbody tr:hover {
      background: #f8fafc;
      transform: scale(1.01);
      box-shadow: 0 4px 12px -4px rgba(0, 0, 0, 0.1);
    }

    .table tbody td {
      padding: 1.25rem 1rem;
      vertical-align: middle;
      border: none;
    }

    .user-avatar {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-weight: 600;
      margin-right: 0.75rem;
    }

    .user-info {
      display: flex;
      align-items: center;
    }

    .user-details h6 {
      margin: 0;
      font-weight: 600;
      color: #1f2937;
    }

    .user-details small {
      color: #6b7280;
      font-size: 0.85rem;
    }

    .action-buttons {
      display: flex;
      gap: 0.5rem;
    }

    .btn-sm-modern {
      padding: 0.5rem 1rem;
      font-size: 0.85rem;
    }

    .modal-content {
      border: none;
      border-radius: var(--border-radius);
      box-shadow: var(--card-shadow);
    }

    .modal-header {
      background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
      color: white;
      border-radius: var(--border-radius) var(--border-radius) 0 0;
      padding: 1.5rem;
    }

    .modal-title {
      font-weight: 600;
    }

    .modal-body {
      padding: 2rem;
    }

    .form-floating {
      margin-bottom: 1.5rem;
    }

    .form-floating input {
      border: 2px solid #e5e7eb;
      border-radius: var(--border-radius);
      transition: all 0.3s ease;
    }

    .form-floating input:focus {
      border-color: var(--primary-color);
      box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
    }

    .form-floating label {
      color: #6b7280;
      font-weight: 500;
    }

    .password-field {
      position: relative;
    }

    .password-toggle {
      position: absolute;
      right: 1rem;
      top: 50%;
      transform: translateY(-50%);
      background: none;
      border: none;
      color: #6b7280;
      cursor: pointer;
      z-index: 10;
    }

    .alert-custom {
      position: fixed;
      top: 2rem;
      right: 2rem;
      z-index: 9999;
      min-width: 350px;
      border: none;
      border-radius: var(--border-radius);
      box-shadow: var(--card-shadow);
      animation: slideInRight 0.5s ease-out;
    }

    .loading-spinner {
      display: none;
      position: fixed;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      
    }

    .spinner {
      width: 50px;
      height: 50px;
      border: 5px solid #f3f4f6;
      border-top: 5px solid var(--primary-color);
      border-radius: 50%;
      animation: spin 1s linear infinite;
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

    @keyframes slideInRight {
      from {
        transform: translateX(100%);
        opacity: 0;
      }
      to {
        transform: translateX(0);
        opacity: 1;
      }
    }

    @keyframes spin {
      0% { transform: rotate(0deg); }
      100% { transform: rotate(360deg); }
    }

    @keyframes pulse {
      0%, 100% { opacity: 0.4; }
      50% { opacity: 0.8; }
    }

    @media (max-width: 768px) {
      .main-container {
        margin: 1rem;
      }
      
      .header-section {
        padding: 1.5rem;
      }
      
      .page-title {
        font-size: 2rem;
      }
      
      .content-section {
        padding: 1.5rem;
      }
      
      .action-bar {
        flex-direction: column;
        align-items: stretch;
      }
      
      .search-box {
        max-width: none;
      }
      
      .action-buttons {
        flex-direction: column;
      }
      
      .table-responsive {
        font-size: 0.9rem;
      }
    }
  </style>
</head>
<body>

<div class="main-container">
  <!-- Header Section -->
  <div class="header-section">
    <div class="header-content">
      <h1 class="page-title">
        <i class="fas fa-users me-3"></i>
        Manajemen Pengguna
      </h1>
      
      
    </div>
  </div>

  <!-- Content Section -->
  <div class="content-section">
    <!-- Action Bar -->
    <div class="action-bar">
      <div class="search-box">
        <i class="fas fa-search"></i>
        <input type="text" id="searchInput" placeholder="Cari pengguna..." class="form-control">
      </div>
      <div class="d-flex gap-2">
                 <a href="dashboard_admin.jsp" class="btn btn-primary">
        <i class="fas fa-arrow-left"></i> Kembali
      </a>
      </div>
    </div>
    <!-- Data Table -->
    <div class="data-table">
      <div class="table-responsive">
        <table class="table" id="userTable">
          <thead>
            <tr>
              <th><i class="fas fa-hashtag me-2"></i>No</th>
              <th><i class="fas fa-user me-2"></i>Pengguna</th>
              <th><i class="fas fa-envelope me-2"></i>Email</th>
              <th><i class="fas fa-key me-2"></i>Password</th>
              <th><i class="fas fa-user-tag me-2"></i>Role</th>
              <th><i class="fas fa-cog me-2"></i>Aksi</th>
            </tr>
          </thead>
          <tbody>
<%
  Connection conn = null;
  Statement stmt = null;
  ResultSet rs = null;
  int no = 1;
  int totalUsers = 0;

  try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/user", "root", "");
    stmt = conn.createStatement();
    rs = stmt.executeQuery("SELECT * FROM users ORDER BY nama_lengkap DESC");

    while(rs.next()) {
      String nama = rs.getString("nama_lengkap"); 
      String email = rs.getString("email");
      String password = rs.getString("password");
      String role = rs.getString("role");
      totalUsers++;

      String initials = "";
      if (nama != null && !nama.isEmpty()) {
        String[] words = nama.split(" ");
        for (String word : words) {
          if (!word.isEmpty()) {
            initials += word.charAt(0);
          }
        }
      }

%>
            <tr>
              <td><%= no++ %></td>
              <td>
                <div class="user-info">
                  <div class="user-avatar">
                    <%= initials.toUpperCase() %>
                  </div>
                  <div class="user-details">
                    <h6><%= nama %></h6>
                    <small>Member sejak 2024</small>
                  </div>
                </div>
              </td>
              <td>
                <div class="d-flex align-items-center">
                  <i class="fas fa-at text-muted me-2"></i>
                  <%= email %>
                </div>
              </td>
              <td>
                <div class="password-field">
                  <span class="password-text">••••••••</span>
                  <button class="password-toggle" onclick="togglePassword(this, '<%= password %>')">
                    <i class="fas fa-eye"></i>
                  </button>
                </div>
              </td>
              <td>
                <div class="d-flex align-items-center">
                  <i class="fas fa-at text-muted me-2"></i>
                  <%= role %>
                </div>
              </td>
              <td>
                <div class="action-buttons">
                  <button class="btn-modern btn-warning-modern btn-sm-modern" 
                          data-bs-toggle="modal" 
                          data-bs-target="#editModal"
                          onclick="setEditValues('<%= nama %>', '<%= email %>', '<%= password %>', '<%= role %>')">
                    <i class="fas fa-edit"></i>
                    Edit
                  </button>
                  <button class="btn-modern btn-danger-modern btn-sm-modern" 
                          onclick="confirmDelete('<%= email %>', '<%= nama %>')">
                    <i class="fas fa-trash"></i>
                    Hapus
                  </button>
                </div>
              </td>
            </tr>
<%
    }
  } catch(Exception e) {
    out.println("<tr><td colspan='5' class='text-center text-danger'>Error: " + e.getMessage() + "</td></tr>");
  } finally {
    if (rs != null) rs.close();
    if (stmt != null) stmt.close();
    if (conn != null) conn.close();
  }
%>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<!-- Edit Modal -->
<div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form method="post" id="editForm">
        <input type="hidden" name="update" value="true">
        <div class="modal-header">
          <h5 class="modal-title">
            <i class="fas fa-user-edit me-2"></i>
            Edit Data Pengguna
          </h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <input type="hidden" id="emailLama" name="email_lama">
          
          <div class="form-floating">
            <input type="text" class="form-control" id="editNama" name="nama" placeholder="Nama Lengkap" required>
            <label for="editNama">
              <i class="fas fa-user me-2"></i>Nama Lengkap
            </label>
          </div>
          
          <div class="form-floating">
            <input type="email" class="form-control" id="editEmail" name="email" placeholder="Email" required>
            <label for="editEmail">
              <i class="fas fa-envelope me-2"></i>Alamat Email
            </label>
          </div>
          
          <div class="form-floating">
            <input type="password" class="form-control" id="editPassword" name="password" placeholder="Password" readonly>
            <label for="editPassword">
              <i class="fas fa-lock me-2"></i>Password
            </label>
            <button type="button" class="password-toggle" onclick="togglePasswordField('editPassword')">
              <i class="fas fa-eye"></i>
            </button>
          </div>
           <div class="form-floating">
            <input type="role" class="form-control" id="editRole" name="role" placeholder="Role" required>
            <label for="editRole">
              <i class="fas fa-envelope me-2"></i>Role
            </label>
          </div>
          
          <div class="alert alert-info d-flex align-items-center" role="alert">
            <i class="fas fa-info-circle me-2"></i>
            <div>
              Pastikan data yang dimasukkan sudah benar sebelum menyimpan perubahan.
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn-modern btn-secondary" data-bs-dismiss="modal">
            <i class="fas fa-times me-2"></i>Batal
          </button>
          <button type="submit" class="btn-modern btn-success-modern">
            <i class="fas fa-save me-2"></i>Simpan Perubahan
          </button>
        </div>
      </form>
    </div>
  </div>
</div>
<!-- Loading Spinner -->
<div class="loading-spinner" id="loadingSpinner">
  <div class="spinner"></div>
</div>

<!-- Delete Form -->
<form id="deleteForm" method="get" style="display: none;">
  <input type="hidden" name="delete_email" id="deleteEmailInput">
</form>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // Initialize page
  document.addEventListener('DOMContentLoaded', function() {
    updateStats();
    initializeSearch();
  });

  function updateStats() {
    const totalUsers = document.querySelectorAll('#userTable tbody tr').length;
    document.getElementById('totalUsers').textContent = totalUsers;
    document.getElementById('activeUsers').textContent = Math.floor(totalUsers * 0.7);
    document.getElementById('newUsers').textContent = Math.floor(totalUsers * 0.2);
  }

  function initializeSearch() {
    const searchInput = document.getElementById('searchInput');
    const table = document.getElementById('userTable');
    const rows = table.getElementsByTagName('tbody')[0].getElementsByTagName('tr');

    searchInput.addEventListener('input', function() {
      const filter = this.value.toLowerCase();
      
      for (let i = 0; i < rows.length; i++) {
        const row = rows[i];
        const cells = row.getElementsByTagName('td');
        let found = false;
        
        for (let j = 0; j < cells.length; j++) {
          if (cells[j].textContent.toLowerCase().indexOf(filter) > -1) {
            found = true;
            break;
          }
        }
        
        row.style.display = found ? '' : 'none';
      }
    });
  }

  function setEditValues(nama, email, password, role) {
    document.getElementById("editNama").value = nama;
    document.getElementById("editEmail").value = email;
    document.getElementById("editPassword").value = password;
    document.getElementById("editRole").value = role;
    document.getElementById("emailLama").value = email;
  }

  function confirmDelete(email, nama) {
    if (confirm(`Apakah Anda yakin ingin menghapus pengguna "${nama}" dengan email: ${email}?\n\nTindakan ini tidak dapat dibatalkan.`)) {
      showLoading();
      document.getElementById("deleteEmailInput").value = email;
      document.getElementById("deleteForm").submit();
    }
  }

  function togglePassword(button, actualPassword) {
    const passwordText = button.parentElement.querySelector('.password-text');
    const icon = button.querySelector('i');
    
    if (passwordText.textContent === '••••••••') {
      passwordText.textContent = actualPassword;
      icon.className = 'fas fa-eye-slash';
    } else {
      passwordText.textContent = '••••••••';
      icon.className = 'fas fa-eye';
    }
  }

  function togglePasswordField(fieldId) {
    const field = document.getElementById(fieldId);
    const button = field.parentElement.querySelector('.password-toggle i');
    
    if (field.type === 'password') {
      field.type = 'text';
      button.className = 'fas fa-eye-slash';
    } else {
      field.type = 'password';
      button.className = 'fas fa-eye';
    }
  }

  function addUser() {
    const form = document.getElementById('addUserForm');
    const formData = new FormData(form);
    
    // Simulate adding user (you would need to implement the actual backend logic)
    showAlert('Fitur tambah pengguna akan segera tersedia!', 'info');
    bootstrap.Modal.getInstance(document.getElementById('addUserModal')).hide();
  }

  function showLoading() {
    document.getElementById('loadingSpinner').style.display = 'block';
  }

  function hideLoading() {
    document.getElementById('loadingSpinner').style.display = 'none';
  }
  

  // Form submission handling
  document.getElementById('editForm').addEventListener('submit', function(e) {
    showLoading();
    // Form akan submit secara normal, loading akan hilang saat page reload
  });

  // Enhanced table interactions
  document.querySelectorAll('#userTable tbody tr').forEach(row => {
    row.addEventListener('mouseenter', function() {
      this.style.transform = 'scale(1.01)';
    });
    
    row.addEventListener('mouseleave', function() {
      this.style.transform = 'scale(1)';
    });
  });

  // Keyboard shortcuts
  document.addEventListener('keydown', function(e) {
    // Ctrl/Cmd + K to focus search
    if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
      e.preventDefault();
      document.getElementById('searchInput').focus();
    }
    
    // Escape to clear search
    if (e.key === 'Escape') {
      const searchInput = document.getElementById('searchInput');
      if (searchInput === document.activeElement) {
        searchInput.value = '';
        searchInput.dispatchEvent(new Event('input'));
        searchInput.blur();
      }
    }
  });

  // Smooth scrolling for better UX
  window.addEventListener('load', function() {
    hideLoading();
    
    // Add entrance animations to table rows
    const rows = document.querySelectorAll('#userTable tbody tr');
    rows.forEach((row, index) => {
      row.style.opacity = '0';
      row.style.transform = 'translateY(20px)';
      
      setTimeout(() => {
        row.style.transition = 'all 0.5s ease';
        row.style.opacity = '1';
        row.style.transform = 'translateY(0)';
      }, index * 100);
    });
  });

  // Enhanced modal interactions
  document.getElementById('editModal').addEventListener('shown.bs.modal', function() {
    document.getElementById('editNama').focus();
  });

  document.getElementById('addUserModal').addEventListener('shown.bs.modal', function() {
    document.getElementById('newNama').focus();
  });

  // Form validation enhancements
  function validateForm(formId) {
    const form = document.getElementById(formId);
    const inputs = form.querySelectorAll('input[required]');
    let isValid = true;
    
    inputs.forEach(input => {
      if (!input.value.trim()) {
        input.classList.add('is-invalid');
        isValid = false;
      } else {
        input.classList.remove('is-invalid');
      }
    });
    
    return isValid;
  }

  // Email validation
  function validateEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
  }

  // Real-time validation
  document.addEventListener('input', function(e) {
    if (e.target.type === 'email') {
      if (e.target.value && !validateEmail(e.target.value)) {
        e.target.classList.add('is-invalid');
      } else {
        e.target.classList.remove('is-invalid');
      }
    }
    
    if (e.target.hasAttribute('required')) {
      if (e.target.value.trim()) {
        e.target.classList.remove('is-invalid');
      }
    }
  });

  // Advanced search with filters
  function setupAdvancedSearch() {
    const searchInput = document.getElementById('searchInput');
    let searchTimeout;
    
    searchInput.addEventListener('input', function() {
      clearTimeout(searchTimeout);
      searchTimeout = setTimeout(() => {
        performSearch(this.value);
      }, 300); // Debounce search
    });
  }

  function performSearch(query) {
    const table = document.getElementById('userTable');
    const rows = table.getElementsByTagName('tbody')[0].getElementsByTagName('tr');
    const filter = query.toLowerCase();
    let visibleCount = 0;
    
    for (let i = 0; i < rows.length; i++) {
      const row = rows[i];
      const cells = row.getElementsByTagName('td');
      let found = false;
      
      // Search in name, email columns only
      for (let j = 1; j <= 2; j++) {
        if (cells[j] && cells[j].textContent.toLowerCase().indexOf(filter) > -1) {
          found = true;
          break;
        }
      }
      
      if (found) {
        row.style.display = '';
        row.style.animation = 'fadeInUp 0.3s ease';
        visibleCount++;
      } else {
        row.style.display = 'none';
      }
    }
    
    // Update search results indicator
    updateSearchResults(visibleCount, rows.length);
  }

  function updateSearchResults(visible, total) {
    let indicator = document.getElementById('searchIndicator');
    if (!indicator) {
      indicator = document.createElement('div');
      indicator.id = 'searchIndicator';
      indicator.className = 'text-muted small mt-2';
      document.querySelector('.search-box').appendChild(indicator);
    }
    
    if (visible < total) {
      indicator.textContent = `Menampilkan ${visible} dari ${total} pengguna`;
      indicator.style.display = 'block';
    } else {
      indicator.style.display = 'none';
    }
  }

  // Initialize advanced features
  setupAdvancedSearch();

  // Export functionality (placeholder)
  function exportData(format) {
    showAlert(`Export ${format.toUpperCase()} akan segera tersedia!`, 'info');
  }

  // Bulk actions (placeholder)
  function toggleBulkActions() {
    showAlert('Fitur bulk actions akan segera tersedia!', 'info');
  }

  // Auto-save draft functionality for edit form
  let draftTimeout;
  function saveDraft() {
    clearTimeout(draftTimeout);
    draftTimeout = setTimeout(() => {
      const formData = {
        nama: document.getElementById('editNama').value,
        email: document.getElementById('editEmail').value,
        timestamp: Date.now()
      };
      // In a real application, you would save this to localStorage or send to server
      console.log('Draft saved:', formData);
    }, 2000);
  }

  // Add draft saving to edit form inputs
  document.querySelectorAll('#editModal input').forEach(input => {
    input.addEventListener('input', saveDraft);
  });

  // Accessibility improvements
  document.addEventListener('keydown', function(e) {
    // Handle Enter key on buttons
    if (e.key === 'Enter' && e.target.classList.contains('btn-modern')) {
      e.target.click();
    }
  });

  // Performance optimization: Lazy load images if any
  if ('IntersectionObserver' in window) {
    const imageObserver = new IntersectionObserver((entries, observer) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          const img = entry.target;
          img.src = img.dataset.src;
          img.classList.remove('lazy');
          imageObserver.unobserve(img);
        }
      });
    });

    document.querySelectorAll('img[data-src]').forEach(img => {
      imageObserver.observe(img);
    });
  }
</script>

</body>
</html>