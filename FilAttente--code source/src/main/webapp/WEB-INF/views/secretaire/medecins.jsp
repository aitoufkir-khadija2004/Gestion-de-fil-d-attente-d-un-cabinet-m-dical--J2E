<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.*" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Médecins</title>
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
        
        @SuppressWarnings("unchecked")
        List<Medecin> medecins = (List<Medecin>) request.getAttribute("medecins");
    %>
    
    <!-- Navbar avec Logo -->
    <nav class="navbar navbar-dark" style="background-color: #1692A6;">
        <div class="container-fluid">
            <a href="${pageContext.request.contextPath}/secretaire/dashboard" class="navbar-brand d-flex align-items-center">
                <img src="<%= request.getContextPath() %>/images/logo1.png" 
                     alt="Logo" 
                     style="height: 40px; width: auto; margin-right: 10px;">
                <i class="bi bi-arrow-left-circle me-2"></i>
                <span>Liste des Médecins</span>
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
        
        <!-- Carte Principale -->
        <div class="card border-0 shadow-sm">
            <div class="card-header text-white" style="background-color: #1692A6;">
                <h5 class="mb-0">
                    <i class="bi bi-heart-pulse-fill me-2"></i>
                    Liste des Médecins
                </h5>
            </div>
            <div class="card-body">
                <% if (medecins != null && medecins.size() > 0) { %>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th><i class="bi bi-hash me-1"></i> Code</th>
                                    <th><i class="bi bi-person me-1"></i> Nom</th>
                                    <th><i class="bi bi-person me-1"></i> Prénom</th>
                                    <th><i class="bi bi-award me-1"></i> Spécialité</th>
                                    <th><i class="bi bi-envelope me-1"></i> Email</th>
                                    <th><i class="bi bi-telephone me-1"></i> Téléphone</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Medecin medecin : medecins) { %>
                                <tr>
                                    <td><strong><%= medecin.getCodeUser() != null ? medecin.getCodeUser() : "N/A" %></strong></td>
                                    <td><%= medecin.getNom() != null ? medecin.getNom() : "-" %></td>
                                    <td><%= medecin.getPrenom() != null ? medecin.getPrenom() : "-" %></td>
                                    <td>
    <% if (medecin.getNomSpecialite() != null && !medecin.getNomSpecialite().isEmpty()) { %>
        <i class="bi bi-award text-primary me-1"></i>
        <span class="text-dark"><%= medecin.getNomSpecialite() %></span>
    <% } else { %>
        <span class="text-muted fst-italic">Non spécifié</span>
    <% } %>
</td>
                                    <td><%= medecin.getEmail() != null ? medecin.getEmail() : "-" %></td>
                                    <td><%= medecin.getTelephone() != null ? medecin.getTelephone() : "-" %></td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } else { %>
                    <div class="text-center py-5">
                        <i class="bi bi-inbox fs-1 text-muted"></i>
                        <h5 class="mt-3">Aucun médecin</h5>
                        <p class="text-muted">Aucun médecin enregistré dans le système.</p>
                    </div>
                <% } %>
            </div>
        </div>
        
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
