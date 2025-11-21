<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.*" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Médecin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light">
    <%
        User user = (User) session.getAttribute("user");
        if (user == null || !"MEDECIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        Medecin medecin = (Medecin) session.getAttribute("medecin");
        
        Integer nbPatientsEnAttente = (Integer) request.getAttribute("nbPatientsEnAttente");
        Integer nbConsultationsAujourdhui = (Integer) request.getAttribute("nbConsultationsAujourdhui");
        Integer nbConsultationsTerminees = (Integer) request.getAttribute("nbConsultationsTerminees");
        
        @SuppressWarnings("unchecked")
        List<Ticket> fileAttente = (List<Ticket>) request.getAttribute("fileAttente");
        
        if (nbPatientsEnAttente == null) nbPatientsEnAttente = 0;
        if (nbConsultationsAujourdhui == null) nbConsultationsAujourdhui = 0;
        if (nbConsultationsTerminees == null) nbConsultationsTerminees = 0;
    %>
    
    <!-- Navbar avec Logo -->
    <nav class="navbar navbar-dark" style="background-color: #28a745;">
        <div class="container-fluid">
            <span class="navbar-brand d-flex align-items-center">
                <img src="<%= request.getContextPath() %>/images/logo1.png" 
                     alt="Logo" 
                     style="height: 40px; width: auto; margin-right: 10px;">
                <span>Dashboard Médecin</span>
            </span>
            <div class="d-flex align-items-center text-white">
                <span class="me-3">
                    <i class="bi bi-person-circle me-1"></i>
                    Dr. <%= user.getPrenom() %> <%= user.getNom() %>
                    <% if (medecin != null && medecin.getNomSpecialite() != null) { %>
                        <small class="d-block text-white-50"><%= medecin.getNomSpecialite() %></small>
                    <% } %>
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
                    Bienvenue Dr. <%= user.getPrenom() %> <%= user.getNom() %>
                </h4>
                <p class="text-muted mb-0">
                    <i class="bi bi-hash me-1"></i> Code : <%= user.getCodeUser() %>
                    <% if (medecin != null && medecin.getNomSpecialite() != null) { %>
                        | <i class="bi bi-award me-1"></i> Spécialité : <%= medecin.getNomSpecialite() %>
                    <% } %>
                </p>
            </div>
        </div>
        
        <!-- Statistiques du jour -->
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="card border-0 shadow-sm">
                    <div class="card-body text-center">
                        <i class="bi bi-hourglass-split fs-1 text-warning"></i>
                        <h3 class="mt-2 mb-0"><%= nbPatientsEnAttente %></h3>
                        <p class="text-muted mb-2">Patients en attente</p>
                        <a href="${pageContext.request.contextPath}/medecin/file-attente" class="btn btn-warning btn-sm">
                            <i class="bi bi-eye me-1"></i> Voir
                        </a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card border-0 shadow-sm">
                    <div class="card-body text-center">
                        <i class="bi bi-calendar-check-fill fs-1 text-primary"></i>
                        <h3 class="mt-2 mb-0"><%= nbConsultationsAujourdhui %></h3>
                        <p class="text-muted mb-2">Consultations aujourd'hui</p>
                        <a href="${pageContext.request.contextPath}/medecin/consultations" class="btn btn-primary btn-sm">
                            <i class="bi bi-eye me-1"></i> Voir
                        </a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card border-0 shadow-sm">
                    <div class="card-body text-center">
                        <i class="bi bi-check-circle-fill fs-1 text-success"></i>
                        <h3 class="mt-2 mb-0"><%= nbConsultationsTerminees %></h3>
                        <p class="text-muted mb-2">Consultations terminées</p>
                        <span class="badge bg-success">Terminé</span>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- File d'attente actuelle -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-success text-white d-flex justify-content-between align-items-center">
                <h5 class="mb-0">
                    <i class="bi bi-people-fill me-2"></i>
                    File d'Attente
                </h5>
                <span class="badge bg-light text-dark"><%= nbPatientsEnAttente %> patient(s)</span>
            </div>
            <div class="card-body">
                <% if (fileAttente != null && fileAttente.size() > 0) { %>
                    <div class="list-group">
                        <% 
                        int position = 1;
                        for (Ticket ticket : fileAttente) { 
                            String badgeClass = "bg-warning text-dark";
                            if ("present".equals(ticket.getStatut())) {
                                badgeClass = "bg-primary";
                            }
                        %>
                        <div class="list-group-item d-flex justify-content-between align-items-center">
                            <div>
                                <span class="badge bg-secondary me-2">Position <%= position %></span>
                                <strong><%= ticket.getNumero() %></strong>
                                <% if (ticket.getPriorite() == 3) { %>
                                    <span class="badge bg-danger ms-2">URGENT</span>
                                <% } %>
                            </div>
                            <div>
                                <span class="badge <%= badgeClass %> me-2">
                                    <%= "present".equals(ticket.getStatut()) ? "Présent" : "En attente" %>
                                </span>
                                <% if (position == 1 && "present".equals(ticket.getStatut())) { %>
                                    <form action="${pageContext.request.contextPath}/medecin/appeler-patient" 
                                          method="post" style="display: inline;">
                                        <input type="hidden" name="ticketId" value="<%= ticket.getId() %>">
                                        <button type="submit" class="btn btn-success btn-sm">
                                            <i class="bi bi-person-check-fill me-1"></i> Appeler
                                        </button>
                                    </form>
                                <% } %>
                            </div>
                        </div>
                        <% 
                            position++;
                        } 
                        %>
                    </div>
                    <div class="mt-3 text-center">
                        <a href="${pageContext.request.contextPath}/medecin/file-attente" class="btn btn-primary">
                            <i class="bi bi-list-ul me-1"></i>
                            Voir toute la file d'attente
                        </a>
                    </div>
                <% } else { %>
                    <div class="text-center py-4">
                        <i class="bi bi-inbox fs-1 text-muted"></i>
                        <p class="text-muted mt-2 mb-0">Aucun patient en attente</p>
                    </div>
                <% } %>
            </div>
        </div>
        
        <!-- Actions Rapides -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-success text-white">
                <i class="bi bi-lightning-fill me-2"></i>
                <strong>Actions Rapides</strong>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-4 mb-2">
                        <a href="${pageContext.request.contextPath}/medecin/creneaux" 
                           class="btn btn-info w-100">
                            <i class="bi bi-calendar-plus-fill me-2"></i>
                            Gérer mes Créneaux
                        </a>
                    </div>
                    <div class="col-md-4 mb-2">
                        <a href="${pageContext.request.contextPath}/medecin/consultations" 
                           class="btn btn-primary w-100">
                            <i class="bi bi-clipboard-check me-2"></i>
                            Mes Consultations
                        </a>
                    </div>
                    <div class="col-md-4 mb-2">
                        <a href="${pageContext.request.contextPath}/medecin/patients" 
                           class="btn btn-warning w-100">
                            <i class="bi bi-people-fill me-2"></i>
                            Mes Patients
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
                <a href="${pageContext.request.contextPath}/medecin/file-attente" 
                   class="list-group-item list-group-item-action">
                    <i class="bi bi-people me-2"></i> File d'Attente
                </a>
                <a href="${pageContext.request.contextPath}/medecin/consultations" 
                   class="list-group-item list-group-item-action">
                    <i class="bi bi-clipboard-check me-2"></i> Mes Consultations
                </a>
                <a href="${pageContext.request.contextPath}/medecin/patients" 
                   class="list-group-item list-group-item-action">
                    <i class="bi bi-person-lines-fill me-2"></i> Mes Patients
                </a>
                <a href="${pageContext.request.contextPath}/medecin/creneaux" 
                   class="list-group-item list-group-item-action">
                    <i class="bi bi-calendar-check me-2"></i> Gestion des Créneaux
                </a>
            </div>
        </div>
        
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>