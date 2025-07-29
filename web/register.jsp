<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="id">
<head>
  <meta charset="UTF-8">
  <title>Registrasi Pengguna</title>

  <!-- Bootstrap 5 CDN -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

  <!-- Bootstrap Icons (optional) -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

  <!-- Google Fonts -->
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">

  <!-- Custom Styles -->
  <style>
    body {
      background: linear-gradient(45deg, #00cc33,#00cc33);
      font-family: 'Poppins', sans-serif;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      color: #333;
    }

    .card {
      border: none;
      border-radius: 20px;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
    }

    .card-header {
      background: linear-gradient(45deg, #006600);
      color: white;
      font-weight: 600;
      text-align: center;
      font-size: 1.5rem;
      padding: 20px;
      border-top-left-radius: 20px;
      border-top-right-radius: 20px;
    }

    .form-control {
      border-radius: 10px;
    }

    .form-label {
      font-size: 0.95rem;
    }

    .btn-custom {
      background: linear-gradient(45deg, #006600);
      border: none;
      color: white;
      border-radius: 30px;
      padding: 12px;
      font-weight: 500;
      transition: 0.3s;
    }

    .btn-custom:hover {
      background-color: #14532d;
      transform: translateY(-2px);
    }

    .card-footer {
      background-color: #f8f9fa;
      text-align: center;
      border-bottom-left-radius: 20px;
      border-bottom-right-radius: 20px;
      padding: 10px 0;
    }

    .card-footer a {
      color: #007a00;
      text-decoration: none;
      font-weight: 500;
    }

    .card-footer a:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>
  <div class="container px-3">
    <div class="col-md-6 col-lg-5 mx-auto">
      <div class="card">
        <div class="card-header">
          Registrasi Pengguna
        </div>
        <div class="card-body p-4">
          <form action="RegisterServlet" method="post">
            <!-- Nama -->
            <div class="mb-3">
              <label for="nama" class="form-label">Nama Lengkap</label>
              <input type="text" class="form-control" id="nama_lengkap" name="nama_lengkap" required>
            </div>

            <!-- Email -->
            <div class="mb-3">
              <label for="email" class="form-label">Email</label>
              <input type="email" class="form-control" id="email" name="email" required>
            </div>
            <div class="mb-3">
                  <label for="role" class="form-label" >role</label>
                <select name="role" required>
                    <option value="">-- Pilih Role --</option>
                    <option value="costumer">Pelanggan</option>
                    <option value="admin">Admin</option>
                </select>
              <div/>
            <!-- Password -->
            <div class="mb-3">
              <label for="password" class="form-label">Kata Sandi</label>
              <input type="password" class="form-control" id="password" name="password" required>
            </div>

            <!-- Konfirmasi Password -->
            <div class="mb-4">
              <label for="konfirmasi" class="form-label">Konfirmasi Kata Sandi</label>
              <input type="password" class="form-control" id="konfirmasi" name="konfirmasi" required>
            </div>

            <!-- Tombol Submit -->
            <div class="d-grid">
              <button type="submit" class="btn btn-custom">Daftar Sekarang</button>
            </div>
          </form>
        </div>
        <div class="card-footer">
          <small>Sudah punya akun? <a href="login.jsp">Masuk di sini</a></small>
        </div>
      </div>
    </div>
  </div>

  <!-- Bootstrap Bundle JS -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
