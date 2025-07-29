<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | Aplikasi KuyBELI</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Optional Bootstrap Icons (for Google button icon) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Custom Styles -->
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;500;700&display=swap');

        body {
            background: linear-gradient(45deg, #00cc33,#00cc33);
            font-family: 'Poppins', sans-serif;
            color: #333;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .card {
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
        }

        .card-header {
            background: linear-gradient(45deg, #006600);
            color: white;
            font-weight: 600;
            font-size: 1.5rem;
            border-top-left-radius: 20px;
            border-top-right-radius: 20px;
            text-align: center;
            padding: 20px;
        }

        .form-control {
            border-radius: 10px;
        }

        .btn-custom {
            background: linear-gradient(45deg, #006600);
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 30px;
            font-weight: 500;
            transition: all 0.3s ease-in-out;
        }

        .btn-custom:hover {
            background-color: #14532d;
            transform: translateY(-2px);
        }

        .btn-google {
            border-radius: 30px;
            padding: 10px 20px;
            font-weight: 500;
            font-size: 0.95rem;
        }

        .btn-google i {
            margin-right: 8px;
        }

        .card-footer {
            background: #f8f9fa;
            text-align: center;
            border-bottom-left-radius: 20px;
            border-bottom-right-radius: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <!-- Card Login Form -->
                <div class="card">
                    <div class="card-header">
                        Login Pengguna
                    </div>
                    <div class="card-body p-4">
                        <form action="LoginServlet" method="post">
                            <!-- Email -->
                            <div class="mb-3">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" name="email" required>
                            </div>

                            <!-- Password -->
                            <div class="mb-4">
                                <label for="password" class="form-label">Kata Sandi</label>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>

                            <!-- Tombol Login -->
                            <div class="text-center">
                                <button type="submit" class="btn btn-custom w-100">Masuk</button>
                            </div>
                        </form>

                        <!-- Opsi Google -->
                        <div class="text-center mt-4">
                            <small>atau masuk dengan</small><br>
                            <a href="https://accounts.google.com/o/oauth2/auth?scope=email%20profile&redirect_uri=http://localhost:8080/WebApplication3/GoogleLoginServlet&response_type=code&client_id=789019571145-eqlv9vtvmvc0cmtarsi4v1pc02u0nrbu.apps.googleusercontent.com&approval_prompt=force" class="btn btn-danger btn-google mt-2 w-100">
                                <i class="bi bi-google"></i> Masuk dengan Google
                            </a>
                        </div>
                    </div>
                    <div class="card-footer">
                        <small>Belum punya akun? <a href="register.jsp">Daftar di sini</a></small>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
