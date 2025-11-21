<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mon Profil</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light">
    <%
        User user = (User) session.getAttribute("user");
        if (user == null || !"PATIENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        Patient patient = (Patient) request.getAttribute("patient");
        if (patient == null) {
            patient = (Patient) session.getAttribute("patient");
        }
    %>
    
    <!-- Navbar avec Logo -->
    <nav class="navbar navbar-dark" style="background-color: #007bff;">
        <div class="container-fluid">
            <a href="${pageContext.request.contextPath}/patient/dashboard" class="navbar-brand d-flex align-items-center">
                <img src="<%= request.getContextPath() %>/images/logo1.png" 
                     alt="Logo" 
                     style="height: 40px; width: auto; margin-right: 10px;">
                <i class="bi bi-arrow-left-circle me-2"></i>
                <span>Mon Profil</span>
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
        <% if (session.getAttribute("success") != null) { %>
            <div class="alert alert-success alert-dismissible fade show">
                <i class="bi bi-check-circle-fill me-2"></i>
                <%= session.getAttribute("success") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("success"); %>
        <% } %>
        
        <% if (session.getAttribute("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                <%= session.getAttribute("error") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("error"); %>
        <% } %>
        
        <!-- Profil du patient -->
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">
                    <i class="bi bi-person-circle me-2"></i>
                    Mes Informations Personnelles
                </h5>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/patient/update-profil" method="post">
                    
                    <!-- Code Patient (lecture seule) -->
                    <div class="mb-3">
                        <label class="form-label">
                            <i class="bi bi-hash me-1"></i>
                            Code Patient
                        </label>
                        <input type="text" class="form-control" value="<%= patient != null ? patient.getCodeUser() : user.getCodeUser() %>" disabled>
                    </div>
                    
                    <div class="row">
                        <!-- Nom -->
                        <div class="col-md-6 mb-3">
                            <label for="nom" class="form-label">
                                <i class="bi bi-person me-1"></i>
                                Nom <span class="text-danger">*</span>
                            </label>
                            <input type="text" class="form-control" id="nom" name="nom" 
                                   value="<%= patient != null ? patient.getNom() : "" %>" required>
                        </div>
                        
                        <!-- Prénom -->
                        <div class="col-md-6 mb-3">
                            <label for="prenom" class="form-label">
                                <i class="bi bi-person me-1"></i>
                                Prénom <span class="text-danger">*</span>
                            </label>
                            <input type="text" class="form-control" id="prenom" name="prenom" 
                                   value="<%= patient != null ? patient.getPrenom() : "" %>" required>
                        </div>
                    </div>
                    
                    <div class="row">
                        <!-- Email -->
                        <div class="col-md-6 mb-3">
                            <label for="email" class="form-label">
                                <i class="bi bi-envelope me-1"></i>
                                Email <span class="text-danger">*</span>
                            </label>
                            <input type="email" class="form-control" id="email" name="email" 
                                   value="<%= patient != null ? patient.getEmail() : "" %>" required>
                        </div>
                        
                        <!-- Téléphone -->
                        <div class="col-md-6 mb-3">
                            <label for="telephone" class="form-label">
                                <i class="bi bi-telephone me-1"></i>
                                Téléphone
                            </label>
                            <input type="tel" class="form-control" id="telephone" name="telephone" 
                                   value="<%= patient != null && patient.getTelephone() != null ? patient.getTelephone() : "" %>">
                        </div>
                    </div>
                    
                    <div class="row">
                        <!-- Date de naissance -->
                        <div class="col-md-6 mb-3">
                            <label for="dateNaissance" class="form-label">
                                <i class="bi bi-calendar me-1"></i>
                                Date de Naissance
                            </label>
                            <input type="date" class="form-control" id="dateNaissance" name="dateNaissance" 
                                   value="<%= patient != null && patient.getDateNaissance() != null ? patient.getDateNaissance() : "" %>" >
                        </div>
                        
                        <!-- Groupe Sanguin -->
                        <div class="col-md-6 mb-3">
                            <label for="groupeSanguin" class="form-label">
                                <i class="bi bi-droplet-fill me-1"></i>
                                Groupe Sanguin
                            </label>
                            <select class="form-select" id="groupeSanguin" name="groupeSanguin">
                                <option value="">-- Sélectionner --</option>
                                <option value="A+" <%= patient != null && "A+".equals(patient.getGroupeSanguin()) ? "selected" : "" %>>A+</option>
                                <option value="A-" <%= patient != null && "A-".equals(patient.getGroupeSanguin()) ? "selected" : "" %>>A-</option>
                                <option value="B+" <%= patient != null && "B+".equals(patient.getGroupeSanguin()) ? "selected" : "" %>>B+</option>
                                <option value="B-" <%= patient != null && "B-".equals(patient.getGroupeSanguin()) ? "selected" : "" %>>B-</option>
                                <option value="AB+" <%= patient != null && "AB+".equals(patient.getGroupeSanguin()) ? "selected" : "" %>>AB+</option>
                                <option value="AB-" <%= patient != null && "AB-".equals(patient.getGroupeSanguin()) ? "selected" : "" %>>AB-</option>
                                <option value="O+" <%= patient != null && "O+".equals(patient.getGroupeSanguin()) ? "selected" : "" %>>O+</option>
                                <option value="O-" <%= patient != null && "O-".equals(patient.getGroupeSanguin()) ? "selected" : "" %>>O-</option>
                            </select>
                        </div>
                    </div>
                    
                    <!-- Adresse -->
                    <div class="mb-3">
                        <label for="adresse" class="form-label">
                            <i class="bi bi-geo-alt me-1"></i>
                            Adresse
                        </label>
                        <textarea class="form-control" id="adresse" name="adresse" rows="2"><%= patient != null && patient.getAdresse() != null ? patient.getAdresse() : "" %></textarea>
                    </div>
                    
                    <!-- Numéro Sécurité Sociale (lecture seule) -->
                    <div class="mb-3">
                        <label class="form-label">
                            <i class="bi bi-card-text me-1"></i>
                            Numéro de Sécurité Sociale
                        </label>
                        <input type="text" class="form-control" 
                               value="<%= patient != null && patient.getNumeroSecuriteSociale() != null ? patient.getNumeroSecuriteSociale() : "Non renseigné" %>" >
                    </div>
                    
                    <div class="text-end">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-save me-1"></i>
                            Enregistrer les Modifications
                        </button>
                    </div>
                </form>
            </div>
        </div>
        
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>