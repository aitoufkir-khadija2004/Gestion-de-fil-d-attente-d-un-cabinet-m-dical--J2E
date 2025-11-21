<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Administrateur</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light">
    <%
        User user = (User) session.getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        Integer nbMedecins = (Integer) request.getAttribute("nbMedecins");
        Integer nbPatients = (Integer) request.getAttribute("nbPatients");
        Integer nbSecretaires = (Integer) request.getAttribute("nbSecretaires");
        Integer nbTickets = (Integer) request.getAttribute("nbTickets");
        Integer nbConsultations = (Integer) request.getAttribute("nbConsultations");
        Integer nbCreneaux = (Integer) request.getAttribute("nbCreneaux");
        
        if (nbMedecins == null) nbMedecins = 0;
        if (nbPatients == null) nbPatients = 0;
        if (nbSecretaires == null) nbSecretaires = 0;
        if (nbTickets == null) nbTickets = 0;
        if (nbConsultations == null) nbConsultations = 0;
        if (nbCreneaux == null) nbCreneaux = 0;
    %>
    
    <!-- Navbar avec Logo -->
    <nav class="navbar navbar-dark" style="background-color: #dc3545;">
        <div class="container-fluid">
            <span class="navbar-brand d-flex align-items-center">
                <img src="<%= request.getContextPath() %>/images/logo1.png" 
                     alt="Logo" 
                     style="height: 40px; width: auto; margin-right: 10px;">
                <span>Tableau de Bord Administrateur</span>
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
                    <i class="bi bi-shield-check text-danger me-2"></i>
                    Bienvenue Administrateur <%= user.getPrenom() %> <%= user.getNom() %>
                </h4>
                <p class="text-muted mb-0">
                    <i class="bi bi-hash me-1"></i> Code : <%= user.getCodeUser() %>
                </p>
            </div>
        </div>
        
        <!-- Statistiques Globales -->
        <h5 class="mb-3">
            <i class="bi bi-bar-chart-fill me-2"></i>
            Statistiques du Système
        </h5>
        
        <!-- Ligne 1 : Utilisateurs -->
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="card border-0 shadow-sm">
                    <div class="card-body text-center">
                        <i class="bi bi-person-fill-gear fs-1 text-success"></i>
                        <h3 class="mt-2 mb-0"><%= nbMedecins %></h3>
                        <p class="text-muted mb-2">Médecins</p>
                        <a href="${pageContext.request.contextPath}/admin/medecins" class="btn btn-success btn-sm">
                            <i class="bi bi-eye me-1"></i> Voir
                        </a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card border-0 shadow-sm">
                    <div class="card-body text-center">
                        <i class="bi bi-people-fill fs-1 text-primary"></i>
                        <h3 class="mt-2 mb-0"><%= nbPatients %></h3>
                        <p class="text-muted mb-2">Patients</p>
                        <a href="${pageContext.request.contextPath}/admin/patients" class="btn btn-primary btn-sm">
                            <i class="bi bi-eye me-1"></i> Voir
                        </a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card border-0 shadow-sm">
                    <div class="card-body text-center">
                        <i class="bi bi-person-badge-fill fs-1 text-info"></i>
                        <h3 class="mt-2 mb-0"><%= nbSecretaires %></h3>
                        <p class="text-muted mb-2">Secrétaires</p>
                        <a href="${pageContext.request.contextPath}/admin/secretaires" class="btn btn-info btn-sm">
                            <i class="bi bi-eye me-1"></i> Voir
                        </a>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Ligne 2 : Activité -->
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="card border-0 shadow-sm">
                    <div class="card-body text-center">
                        <i class="bi bi-ticket-perforated-fill fs-1 text-warning"></i>
                        <h3 class="mt-2 mb-0"><%= nbTickets %></h3>
                        <p class="text-muted mb-2">Tickets Total</p>
                        <span class="badge bg-warning text-dark">Système</span>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card border-0 shadow-sm">
                    <div class="card-body text-center">
                        <i class="bi bi-clipboard-check-fill fs-1 text-success"></i>
                        <h3 class="mt-2 mb-0"><%= nbConsultations %></h3>
                        <p class="text-muted mb-2">Consultations Total</p>
                        <span class="badge bg-success">Système</span>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card border-0 shadow-sm">
                    <div class="card-body text-center">
                        <i class="bi bi-calendar-check-fill fs-1 text-danger"></i>
                        <h3 class="mt-2 mb-0"><%= nbCreneaux %></h3>
                        <p class="text-muted mb-2">Créneaux Total</p>
                        <span class="badge bg-danger">Système</span>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Actions Rapides -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-danger text-white">
                <i class="bi bi-lightning-fill me-2"></i>
                <strong>Actions Rapides</strong>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-3 mb-2">
                        <a href="${pageContext.request.contextPath}/admin/creer-utilisateur" 
                           class="btn btn-success w-100">
                            <i class="bi bi-person-plus-fill me-2"></i>
                            Créer Utilisateur
                        </a>
                    </div>
                    <div class="col-md-3 mb-2">
                        <a href="${pageContext.request.contextPath}/admin/medecins" 
                           class="btn btn-primary w-100">
                            <i class="bi bi-person-fill-gear me-2"></i>
                            Gérer Médecins
                        </a>
                    </div>
                    <div class="col-md-3 mb-2">
                        <a href="${pageContext.request.contextPath}/admin/patients" 
                           class="btn btn-info w-100">
                            <i class="bi bi-people-fill me-2"></i>
                            Gérer Patients
                        </a>
                    </div>
                    <div class="col-md-3 mb-2">
                        <a href="${pageContext.request.contextPath}/admin/secretaires" 
                           class="btn btn-warning w-100">
                            <i class="bi bi-person-badge-fill me-2"></i>
                            Gérer Secrétaires
                        </a>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Navigation Complète -->
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-secondary text-white">
                <i class="bi bi-list-ul me-2"></i>
                <strong>Navigation</strong>
            </div>
            <div class="list-group list-group-flush">
                <a href="${pageContext.request.contextPath}/admin/creer-utilisateur" 
                   class="list-group-item list-group-item-action">
                    <i class="bi bi-person-plus me-2"></i> Créer un Nouvel Utilisateur
                </a>
                <a href="${pageContext.request.contextPath}/admin/medecins" 
                   class="list-group-item list-group-item-action">
                    <i class="bi bi-person-fill-gear me-2"></i> Liste des Médecins
                </a>
                <a href="${pageContext.request.contextPath}/admin/patients" 
                   class="list-group-item list-group-item-action">
                    <i class="bi bi-people me-2"></i> Liste des Patients
                </a>
                <a href="${pageContext.request.contextPath}/admin/secretaires" 
                   class="list-group-item list-group-item-action">
                    <i class="bi bi-person-badge me-2"></i> Liste des Secrétaires
                </a>
                <a href="${pageContext.request.contextPath}/admin/specialites" 
                   class="list-group-item list-group-item-action">
                    <i class="bi bi-bookmark-star me-2"></i> Gestion des Spécialités
                </a>
            </div>
        </div>
        
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>>