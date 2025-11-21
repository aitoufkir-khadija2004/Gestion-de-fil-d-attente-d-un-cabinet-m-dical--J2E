<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Patients</title>
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
        List<Patient> patients = (List<Patient>) request.getAttribute("patients");
        
        @SuppressWarnings("unchecked")
        List<Ticket> ticketsAujourdhui = (List<Ticket>) request.getAttribute("ticketsAujourdhui");
    %>
    
    <!-- Navbar avec Logo -->
    <nav class="navbar navbar-dark" style="background-color: #1692A6;">
        <div class="container-fluid">
            <a href="${pageContext.request.contextPath}/secretaire/dashboard" class="navbar-brand d-flex align-items-center">
                <img src="<%= request.getContextPath() %>/images/logo1.png" 
                     alt="Logo" 
                     style="height: 40px; width: auto; margin-right: 10px;">
                <i class="bi bi-arrow-left-circle me-2"></i>
                <span>Liste des Patients</span>
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
        
        <!-- Carte Principale -->
        <div class="card border-0 shadow-sm">
            <div class="card-header text-white d-flex justify-content-between align-items-center" 
                 style="background-color: #1692A6;">
                <h5 class="mb-0">
                    <i class="bi bi-people-fill me-2"></i>
                    Liste des Patients
                </h5>
                <a href="${pageContext.request.contextPath}/secretaire/nouveau-patient" 
                   class="btn btn-light btn-sm">
                    <i class="bi bi-person-plus-fill me-1"></i>
                    Nouveau Patient
                </a>
            </div>
            <div class="card-body">
                <% if (patients != null && patients.size() > 0) { %>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th><i class="bi bi-hash me-1"></i> Code</th>
                                    <th><i class="bi bi-person me-1"></i> Nom</th>
                                    <th><i class="bi bi-person me-1"></i> Prénom</th>
                                    <th><i class="bi bi-envelope me-1"></i> Email</th>
                                    <th><i class="bi bi-telephone me-1"></i> Téléphone</th>
                                    <th><i class="bi bi-activity me-1"></i> Statut</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                for (Patient patient : patients) { 
                                %>
                                <tr>
                                    <td><strong><%= patient.getCodeUser() != null ? patient.getCodeUser() : "N/A" %></strong></td>
                                    <td><%= patient.getNom() != null ? patient.getNom() : "-" %></td>
                                    <td><%= patient.getPrenom() != null ? patient.getPrenom() : "-" %></td>
                                    <td><%= patient.getEmail() != null ? patient.getEmail() : "-" %></td>
                                    <td><%= patient.getTelephone() != null ? patient.getTelephone() : "-" %></td>
                                    
                                    <!-- COLONNE STATUT AVEC TOUS LES TICKETS -->
                                    <td>
                                        <% 
                                        // Récupérer TOUS les tickets du patient
                                        List<Ticket> tousLesTickets = new ArrayList<>();
                                        if (ticketsAujourdhui != null) {
                                            for (Ticket t : ticketsAujourdhui) {
                                                if (t.getPatientId() == patient.getId()) {
                                                    tousLesTickets.add(t);
                                                }
                                            }
                                        }
                                        
                                        if (tousLesTickets.size() > 0) {
                                            // Afficher le dernier ticket (le plus récent)
                                            Ticket dernierTicket = tousLesTickets.get(tousLesTickets.size() - 1);
                                            
                                            String badgeClass = "bg-secondary";
                                            String statutText = "Aucun RDV";
                                            
                                            if ("en_attente".equals(dernierTicket.getStatut())) {
                                                badgeClass = "bg-warning text-dark";
                                                statutText = "En attente";
                                            } else if ("appele".equals(dernierTicket.getStatut())) {
                                                badgeClass = "bg-info";
                                                statutText = "Appelé";
                                            } else if ("present".equals(dernierTicket.getStatut())) {
                                                badgeClass = "bg-primary";
                                                statutText = "Présent";
                                            } else if ("en_consultation".equals(dernierTicket.getStatut())) {
                                                badgeClass = "bg-success";
                                                statutText = "En consultation";
                                            } else if ("termine".equals(dernierTicket.getStatut())) {
                                                badgeClass = "bg-secondary";
                                                statutText = "Terminé";
                                            } else if ("annule".equals(dernierTicket.getStatut())) {
                                                badgeClass = "bg-danger";
                                                statutText = "Annulé";
                                            }
                                        %>
                                            <span class="badge <%= badgeClass %>"><%= statutText %></span>
                                            <br>
                                            <small class="text-muted">
                                                Total: <%= tousLesTickets.size() %> ticket(s)
                                            </small>
                                        <% } else { %>
                                            <span class="badge bg-secondary">Aucun RDV</span>
                                        <% } %>
                                    </td>
                                    
                                
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } else { %>
                    <div class="text-center py-5">
                        <i class="bi bi-inbox fs-1 text-muted"></i>
                        <h5 class="mt-3">Aucun patient</h5>
                        <p class="text-muted">Aucun patient enregistré dans le système.</p>
                        <a href="${pageContext.request.contextPath}/secretaire/nouveau-patient" 
                           class="btn btn-primary">
                            <i class="bi bi-person-plus-fill me-1"></i>
                            Créer un Patient
                        </a>
                    </div>
                <% } %>
            </div>
        </div>
        
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>