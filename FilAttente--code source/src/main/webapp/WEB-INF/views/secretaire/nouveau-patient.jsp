<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nouveau Patient</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light">
    <%
        User user = (User) session.getAttribute("user");
        if (user == null || !"SECRETAIRE".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
    %>
    
    <!-- Navbar avec Logo -->
    <nav class="navbar navbar-dark" style="background-color: #1692A6;">
        <div class="container-fluid">
            <a href="${pageContext.request.contextPath}/secretaire/patients" class="navbar-brand d-flex align-items-center">
                <img src="<%= request.getContextPath() %>/images/logo1.png" 
                     alt="Logo" 
                     style="height: 40px; width: auto; margin-right: 10px;">
                <i class="bi bi-arrow-left-circle me-2"></i>
                <span>Nouveau Patient</span>
            </a>
            <div class="d-flex align-items-center text-white">
                <span class="me-3">
                    <i class="bi bi-person-circle me-1"></i>
                    <%= user.getPrenom() %> <%= user.getNom() %>
                </span>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-light btn-sm">
                    <i class="bi bi-box-arrow-right me-1"></i>
                    Déconnexion
                </a>
            </div>
        </div>
    </nav>
    
    <div class="container mt-4">
        
        <!-- Messages -->
        <% if (session.getAttribute("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                <%= session.getAttribute("error") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("error"); %>
        <% } %>
        
        <!-- Formulaire -->
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card border-0 shadow-sm">
                    <div class="card-header text-white" style="background-color: #1692A6;">
                        <h5 class="mb-0">
                            <i class="bi bi-person-plus-fill me-2"></i>
                            Créer un Nouveau Patient
                        </h5>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/secretaire/nouveau-patient" method="post">
                            
                            
                            
                            <!-- Nom -->
                            <div class="mb-3">
                                <label for="nom" class="form-label">
                                    <i class="bi bi-person me-1"></i>
                                    Nom <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control" id="nom" name="nom" 
                                       placeholder="Entrez le nom" required>
                            </div>
                            
                            <!-- Prénom -->
                            <div class="mb-3">
                                <label for="prenom" class="form-label">
                                    <i class="bi bi-person me-1"></i>
                                    Prénom <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control" id="prenom" name="prenom" 
                                       placeholder="Entrez le prénom" required>
                            </div>
                            
                            <!-- Email -->
                            <div class="mb-3">
                                <label for="email" class="form-label">
                                    <i class="bi bi-envelope me-1"></i>
                                    Email <span class="text-danger">*</span>
                                </label>
                                <input type="email" class="form-control" id="email" name="email" 
                                       placeholder="exemple@gmail.com" required>
                            </div>
                            
                            <!-- Téléphone -->
                            <div class="mb-3">
                                <label for="telephone" class="form-label">
                                    <i class="bi bi-telephone me-1"></i>
                                    Téléphone <span class="text-danger">*</span>
                                </label>
                                <input type="tel" class="form-control" id="telephone" name="telephone" 
                                       placeholder="0612345678" pattern="[0-9]{10}" required>
                                <small class="text-muted">Format: 10 chiffres (ex: 0612345678)</small>
                            </div>
                            
                            <!-- Date de naissance -->
                            <div class="mb-3">
                                <label for="dateNaissance" class="form-label">
                                    <i class="bi bi-calendar me-1"></i>
                                    Date de Naissance
                                </label>
                                <input type="date" class="form-control" id="dateNaissance" name="dateNaissance">
                            </div>
                            
                            <!-- Adresse -->
                            <div class="mb-3">
                                <label for="adresse" class="form-label">
                                    <i class="bi bi-geo-alt me-1"></i>
                                    Adresse
                                </label>
                                <textarea class="form-control" id="adresse" name="adresse" 
                                          rows="2" placeholder="Adresse complète"></textarea>
                            </div>
                            
                            <!-- Mot de passe -->
                            <div class="mb-3">
                                <label for="password" class="form-label">
                                    <i class="bi bi-lock me-1"></i>
                                    Mot de passe <span class="text-danger">*</span>
                                </label>
                                <input type="password" class="form-control" id="password" name="password" 
                                       placeholder="Mot de passe" minlength="4" required>
                                <small class="text-muted">Minimum 4 caractères</small>
                            </div>
                            
                            <!-- Boutons -->
                            <div class="d-flex justify-content-between mt-4">
                                <a href="${pageContext.request.contextPath}/secretaire/patients" 
                                   class="btn btn-secondary">
                                    <i class="bi bi-x-circle me-1"></i>
                                    Annuler
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-save me-1"></i>
                                    Enregistrer le Patient
                                </button>
                            </div>
                            
                        </form>
                    </div>
                </div>
            </div>
        </div>
        
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
