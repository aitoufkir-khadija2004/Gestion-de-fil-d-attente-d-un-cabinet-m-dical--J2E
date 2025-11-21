<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - Système de Gestion</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-image: url('<%= request.getContextPath() %>/images/hopital-blur.jpg');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.3);
            overflow: hidden;
        }

        .btn-custom {
            background-color: #1692A6;
            border: 2px solid #1692A6;
            color: white;
            transition: all 0.3s ease;
        }

        .btn-custom:hover {
            background-color: #127a8a;
            border-color: #127a8a;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(22, 146, 166, 0.3);
        }

        .form-control:focus {
            border-color: #1692A6;
            box-shadow: 0 0 0 0.2rem rgba(22, 146, 166, 0.25);
        }

        .text-custom {
            color: #1692A6;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-5">
                <div class="card login-card">
                    <div class="card-body p-4">
                        
                        <!-- Logo et Titre -->
                        <div class="text-center mb-4">
                            <img src="<%= request.getContextPath() %>/images/logo.png"
                                 alt="Logo Clinique"
                                 style="width: 300px; height: auto;"
                                 class="mb-3">
                            <h2 class="text-custom">
                                <i class="bi bi-box-arrow-in-right me-2"></i>
                                Connexion
                            </h2>
                        </div>

                        <!-- Messages d'erreur -->
                        <% if (request.getAttribute("error") != null) { %>
                            <div class="alert alert-danger alert-dismissible fade show">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                <%= request.getAttribute("error") %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        <% } %>

                        <!-- Messages de succès -->
                        <% if (session.getAttribute("success") != null) { %>
                            <div class="alert alert-success alert-dismissible fade show">
                                <i class="bi bi-check-circle-fill me-2"></i>
                                <%= session.getAttribute("success") %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                            <% session.removeAttribute("success"); %>
                        <% } %>

                        <!-- Formulaire de connexion -->
                        <form action="<%= request.getContextPath() %>/login" method="post">
                            
                            <div class="mb-3">
                                <label for="email" class="form-label">
                                    <i class="bi bi-envelope me-1"></i>
                                    Email
                                </label>
                                <input type="email" 
                                       class="form-control" 
                                       id="email" 
                                       name="email"
                                       value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>"
                                       placeholder="votre@email.com"
                                       required>
                            </div>

                            <div class="mb-3">
                                <label for="password" class="form-label">
                                    <i class="bi bi-lock me-1"></i>
                                    Mot de passe
                                </label>
                                <input type="password" 
                                       class="form-control" 
                                       id="password" 
                                       name="password" 
                                       placeholder="••••••••"
                                       required>
                            </div>

                            <button type="submit" class="btn btn-custom w-100 btn-lg">
                                <i class="bi bi-box-arrow-in-right me-2"></i>
                                Se connecter
                            </button>
                        </form>

                       

                    </div>
                </div>
                
                
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>