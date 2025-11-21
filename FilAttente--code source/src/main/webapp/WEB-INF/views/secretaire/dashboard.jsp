<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Secrétaire</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .navbar-logo {
            height: 40px;
            width: auto;
            margin-right: 10px;
        }
    </style>
</head>
<body class="bg-light">
    <%
        User user = (User) session.getAttribute("user");
        if (user == null || !"SECRETAIRE".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        Integer nbPatients = (Integer) request.getAttribute("nbPatients");
        Integer nbMedecins = (Integer) request.getAttribute("nbMedecins");
        Integer nbCreneaux = (Integer) request.getAttribute("nbCreneaux");
        
        if (nbPatients == null) nbPatients = 0;
        if (nbMedecins == null) nbMedecins = 0;
        if (nbCreneaux == null) nbCreneaux = 0;
    %>
    
    <!-- Navbar avec Logo -->
    <nav class="navbar navbar-dark bg-info">
        <div class="container-fluid">
            <span class="navbar-brand d-flex align-items-center">
                <img src="<%= request.getContextPath() %>/images/logo1.png" 
                     alt="Logo" 
                     class="navbar-logo">
                <span>Dashboard Secrétaire</span>
            </span>
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
        
        <!-- Carte Bienvenue -->
        <div class="card mb-4 border-0 shadow-sm">
            <div class="card-body">
                <h4 class="mb-1">
                    <i class="bi bi-brightness-high text-warning me-2"></i>
                    Bienvenue <%= user.getPrenom() %> <%= user.getNom() %>
                </h4>
                <p class="text-muted mb-0">
                    <i class="bi bi-hash me-1"></i>
                    Code : <%= user.getCodeUser() %>
                </p>
            </div>
        </div>
        
        <!-- Statistiques -->
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="card border-0 shadow-sm">
                    <div class="card-body text-center">
                        <i class="bi bi-people-fill fs-1 text-primary"></i>
                        <h3 class="mt-2 mb-0"><%= nbPatients %></h3>
                        <p class="text-muted mb-2">Patients</p>
                        <a href="${pageContext.request.contextPath}/secretaire/patients" class="btn btn-primary btn-sm">
                            <i class="bi bi-eye me-1"></i> Voir
                        </a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card border-0 shadow-sm">
                    <div class="card-body text-center">
                        <i class="bi bi-heart-pulse-fill fs-1 text-success"></i>
                        <h3 class="mt-2 mb-0"><%= nbMedecins %></h3>
                        <p class="text-muted mb-2">Médecins</p>
                        <a href="${pageContext.request.contextPath}/secretaire/medecins" class="btn btn-success btn-sm">
                            <i class="bi bi-eye me-1"></i> Voir
                        </a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card border-0 shadow-sm">
                    <div class="card-body text-center">
                        <i class="bi bi-calendar-check-fill fs-1 text-info"></i>
                        <h3 class="mt-2 mb-0"><%= nbCreneaux %></h3>
                        <p class="text-muted mb-2">Créneaux</p>
                        <a href="${pageContext.request.contextPath}/secretaire/creneaux" class="btn btn-info btn-sm">
                            <i class="bi bi-eye me-1"></i> Voir
                        </a>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Actions Rapides -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-info text-white">
                <i class="bi bi-lightning-fill me-2"></i>
                <strong>Actions Rapides</strong>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-4 mb-2">
                        <a href="${pageContext.request.contextPath}/secretaire/nouveau-patient" 
                           class="btn btn-primary w-100">
                            <i class="bi bi-person-plus-fill me-2"></i>
                            Nouveau Patient
                        </a>
                    </div>
                    <div class="col-md-4 mb-2">
                        <a href="${pageContext.request.contextPath}/secretaire/nouveau-ticket" 
                           class="btn btn-success w-100">
                            <i class="bi bi-ticket-perforated-fill me-2"></i>
                            Nouveau Ticket
                        </a>
                    </div>
                    <div class="col-md-4 mb-2">
                        <a href="${pageContext.request.contextPath}/secretaire/nouveau-creneau" 
                           class="btn btn-info w-100">
                            <i class="bi bi-calendar-plus-fill me-2"></i>
                            Nouveau Créneau
                        </a>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Navigation -->
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-secondary text-white">
                <i class="bi bi-list-ul me-2"></i>
                <strong>Navigation</strong>
            </div>
            <div class="list-group list-group-flush">
                <a href="${pageContext.request.contextPath}/secretaire/patients" 
                   class="list-group-item list-group-item-action">
                    <i class="bi bi-people me-2"></i> Gestion des Patients
                </a>
                <a href="${pageContext.request.contextPath}/secretaire/medecins" 
                   class="list-group-item list-group-item-action">
                    <i class="bi bi-heart-pulse me-2"></i> Liste des Médecins
                </a>
                <a href="${pageContext.request.contextPath}/secretaire/tickets" 
                   class="list-group-item list-group-item-action">
                    <i class="bi bi-ticket-perforated me-2"></i> Gestion des Tickets
                </a>
                <a href="${pageContext.request.contextPath}/secretaire/creneaux" 
                   class="list-group-item list-group-item-action">
                    <i class="bi bi-calendar-check me-2"></i> Gestion des Créneaux
                </a>
            </div>
        </div>
        
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>