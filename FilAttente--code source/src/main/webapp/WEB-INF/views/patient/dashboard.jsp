<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.*" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Patient</title>
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
        
        Patient patient = (Patient) session.getAttribute("patient");
        
        Integer nbTickets = (Integer) request.getAttribute("nbTickets");
        Integer nbConsultations = (Integer) request.getAttribute("nbConsultations");
        
        @SuppressWarnings("unchecked")
        List<Ticket> ticketsActifs = (List<Ticket>) request.getAttribute("ticketsActifs");
        
        if (nbTickets == null) nbTickets = 0;
        if (nbConsultations == null) nbConsultations = 0;
    %>
    
    <!-- Navbar avec Logo -->
    <nav class="navbar navbar-dark" style="background-color: #007bff;">
        <div class="container-fluid">
            <span class="navbar-brand d-flex align-items-center">
                <img src="<%= request.getContextPath() %>/images/logo1.png" 
                     alt="Logo" 
                     style="height: 40px; width: auto; margin-right: 10px;">
                <span>Mon Espace Patient</span>
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
                    <i class="bi bi-hash me-1"></i> Code Patient : <%= user.getCodeUser() %>
                    <% if (patient != null && patient.getGroupeSanguin() != null) { %>
                        | <i class="bi bi-droplet-fill me-1"></i> Groupe sanguin : 
                        <span class="badge bg-danger"><%= patient.getGroupeSanguin() %></span>
                    <% } %>
                </p>
            </div>
        </div>
        
        <!-- Statistiques -->
        <div class="row mb-4">
            <div class="col-md-6">
                <div class="card border-0 shadow-sm">
                    <div class="card-body text-center">
                        <i class="bi bi-ticket-perforated-fill fs-1 text-primary"></i>
                        <h3 class="mt-2 mb-0"><%= nbTickets %></h3>
                        <p class="text-muted mb-2">Mes Tickets</p>
                        <a href="${pageContext.request.contextPath}/patient/tickets" class="btn btn-primary btn-sm">
                            <i class="bi bi-eye me-1"></i> Voir
                        </a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-6">
                <div class="card border-0 shadow-sm">
                    <div class="card-body text-center">
                        <i class="bi bi-clipboard-check-fill fs-1 text-success"></i>
                        <h3 class="mt-2 mb-0"><%= nbConsultations %></h3>
                        <p class="text-muted mb-2">Mes Consultations</p>
                        <a href="${pageContext.request.contextPath}/patient/consultations" class="btn btn-success btn-sm">
                            <i class="bi bi-eye me-1"></i> Voir
                        </a>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Tickets en cours -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">
                    <i class="bi bi-ticket-perforated-fill me-2"></i>
                    Mes Rendez-vous en Cours
                </h5>
            </div>
            <div class="card-body">
                <% if (ticketsActifs != null && ticketsActifs.size() > 0) { %>
                    <div class="list-group">
                        <% for (Ticket ticket : ticketsActifs) { 
                            String badgeClass = "bg-warning text-dark";
                            String statutText = "En attente";
                            
                            if ("appele".equals(ticket.getStatut())) {
                                badgeClass = "bg-info";
                                statutText = "Appelé - Présentez-vous";
                            } else if ("present".equals(ticket.getStatut())) {
                                badgeClass = "bg-primary";
                                statutText = "Présent - Patientez";
                            } else if ("en_consultation".equals(ticket.getStatut())) {
                                badgeClass = "bg-success";
                                statutText = "En consultation";
                            }
                        %>
                        <div class="list-group-item">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="mb-1">
                                        <i class="bi bi-ticket-perforated me-2"></i>
                                        Ticket : <strong><%= ticket.getNumero() %></strong>
                                    </h6>
                                    <small class="text-muted">
                                        <i class="bi bi-calendar me-1"></i>
                                        <%= ticket.getDateCreation() != null ? ticket.getDateCreation().toString() : "-" %>
                                    </small>
                                </div>
                                <span class="badge <%= badgeClass %> fs-6"><%= statutText %></span>
                            </div>
                        </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div class="text-center py-4">
                        <i class="bi bi-inbox fs-1 text-muted"></i>
                        <p class="text-muted mt-2 mb-0">Aucun rendez-vous en cours</p>
                    </div>
                <% } %>
            </div>
        </div>
        
        <!-- Actions Rapides -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-primary text-white">
                <i class="bi bi-lightning-fill me-2"></i>
                <strong>Actions Rapides</strong>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-4 mb-2">
                        <a href="${pageContext.request.contextPath}/patient/creneaux-disponibles" 
                           class="btn btn-primary w-100">
                            <i class="bi bi-calendar-plus-fill me-2"></i>
                            Prendre Rendez-vous
                        </a>
                    </div>
                    <div class="col-md-4 mb-2">
                        <a href="${pageContext.request.contextPath}/patient/tickets" 
                           class="btn btn-info w-100">
                            <i class="bi bi-ticket-perforated me-2"></i>
                            Mes Tickets
                        </a>
                    </div>
                    <div class="col-md-4 mb-2">
                        <a href="${pageContext.request.contextPath}/patient/consultations" 
                           class="btn btn-success w-100">
                            <i class="bi bi-clipboard-check me-2"></i>
                            Mes Consultations
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
                <a href="${pageContext.request.contextPath}/patient/creneaux-disponibles" 
                   class="list-group-item list-group-item-action">
                    <i class="bi bi-calendar-plus me-2"></i> Créneaux Disponibles
                </a>
                <a href="${pageContext.request.contextPath}/patient/tickets" 
                   class="list-group-item list-group-item-action">
                    <i class="bi bi-ticket-perforated me-2"></i> Mes Tickets
                </a>
                <a href="${pageContext.request.contextPath}/patient/consultations" 
                   class="list-group-item list-group-item-action">
                    <i class="bi bi-clipboard-check me-2"></i> Historique des Consultations
                </a>
                <a href="${pageContext.request.contextPath}/patient/profil" 
                   class="list-group-item list-group-item-action">
                    <i class="bi bi-person-circle me-2"></i> Mon Profil
                </a>
            </div>
        </div>
        
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>