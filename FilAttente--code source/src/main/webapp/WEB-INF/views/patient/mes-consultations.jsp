<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Consultations</title>
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
        
        @SuppressWarnings("unchecked")
        List<Consultation> consultations = (List<Consultation>) request.getAttribute("consultations");
        
        @SuppressWarnings("unchecked")
        Map<Integer, Medecin> medecinsMap = (Map<Integer, Medecin>) request.getAttribute("medecinsMap");
    %>
    
    <!-- Navbar avec Logo -->
    <nav class="navbar navbar-dark" style="background-color: #007bff;">
        <div class="container-fluid">
            <a href="${pageContext.request.contextPath}/patient/dashboard" class="navbar-brand d-flex align-items-center">
                <img src="<%= request.getContextPath() %>/images/logo1.png" 
                     alt="Logo" 
                     style="height: 40px; width: auto; margin-right: 10px;">
                <i class="bi bi-arrow-left-circle me-2"></i>
                <span>Mes Consultations</span>
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
        
        <!-- Historique des consultations -->
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-success text-white">
                <h5 class="mb-0">
                    <i class="bi bi-clipboard-check-fill me-2"></i>
                    Historique de mes Consultations
                </h5>
            </div>
            <div class="card-body">
                <% if (consultations != null && consultations.size() > 0) { %>
                    <div class="row">
                        <% for (Consultation consultation : consultations) { 
                            // Récupérer le médecin
                            Medecin medecin = medecinsMap.get(consultation.getMedecinId());
                            String medecinNom = medecin != null ? "Dr. " + medecin.getPrenom() + " " + medecin.getNom() : "Médecin #" + consultation.getMedecinId();
                            String specialite = medecin != null && medecin.getNomSpecialite() != null ? medecin.getNomSpecialite() : "";
                            
                            // Badge statut
                            String badgeClass = "bg-warning text-dark";
                            String statutText = "En cours";
                            
                            if ("terminee".equals(consultation.getStatut())) {
                                badgeClass = "bg-success";
                                statutText = "Terminée";
                            }
                        %>
                        <div class="col-md-12 mb-3">
                            <div class="card border-success">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <div>
                                            <h5 class="card-title text-success mb-1">
                                                <i class="bi bi-person-badge me-2"></i>
                                                <%= medecinNom %>
                                            </h5>
                                            <% if (!specialite.isEmpty()) { %>
                                                <p class="text-muted mb-0">
                                                    <i class="bi bi-award me-1"></i>
                                                    <%= specialite %>
                                                </p>
                                            <% } %>
                                        </div>
                                        <span class="badge <%= badgeClass %> fs-6"><%= statutText %></span>
                                    </div>
                                    
                                    <hr>
                                    
                                    <!-- Date consultation -->
                                    <p class="mb-2">
                                        <i class="bi bi-calendar-check text-primary me-2"></i>
                                        <strong>Date :</strong> 
                                        <%= consultation.getDateConsultation() != null ? consultation.getDateConsultation().toString() : "-" %>
                                    </p>
                                    
                                    <!-- Durée -->
                                    <% if ( consultation.getDureeConsultation() > 0) { %>
                                    <p class="mb-2">
                                        <i class="bi bi-clock-history text-info me-2"></i>
                                        <strong>Durée :</strong> <%= consultation.getDureeConsultation() %> minutes
                                    </p>
                                    <% } %>
                                    
                                    <% if ("terminee".equals(consultation.getStatut())) { %>
                                        <hr>
                                        
                                        <!-- Symptômes -->
                                        <% if (consultation.getSymptomes() != null && !consultation.getSymptomes().isEmpty()) { %>
                                        <div class="mb-3">
                                            <h6 class="text-success">
                                                <i class="bi bi-file-medical me-2"></i>
                                                Symptômes
                                            </h6>
                                            <p class="mb-0"><%= consultation.getSymptomes() %></p>
                                        </div>
                                        <% } %>
                                        
                                        <!-- Diagnostic -->
                                        <% if (consultation.getDiagnostic() != null && !consultation.getDiagnostic().isEmpty()) { %>
                                        <div class="mb-3">
                                            <h6 class="text-success">
                                                <i class="bi bi-clipboard-pulse me-2"></i>
                                                Diagnostic
                                            </h6>
                                            <p class="mb-0"><%= consultation.getDiagnostic() %></p>
                                        </div>
                                        <% } %>
                                        
                                        <!-- Prescription -->
                                        <% if (consultation.getPrescription() != null && !consultation.getPrescription().isEmpty()) { %>
                                        <div class="mb-3">
                                            <h6 class="text-success">
                                                <i class="bi bi-capsule me-2"></i>
                                                Prescription
                                            </h6>
                                            <p class="mb-0"><%= consultation.getPrescription() %></p>
                                        </div>
                                        <% } %>
                                        
                                        <!-- Notes médicales -->
                                        <% if (consultation.getNotesMedicales() != null && !consultation.getNotesMedicales().isEmpty()) { %>
                                        <div class="mb-3">
                                            <h6 class="text-success">
                                                <i class="bi bi-journal-medical me-2"></i>
                                                Notes Médicales
                                            </h6>
                                            <p class="mb-0"><%= consultation.getNotesMedicales() %></p>
                                        </div>
                                        <% } %>
                                    <% } else { %>
                                        <div class="alert alert-info mt-3 mb-0">
                                            <i class="bi bi-info-circle me-2"></i>
                                            Cette consultation est en cours. Les détails seront disponibles après sa finalisation.
                                        </div>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div class="text-center py-5">
                        <i class="bi bi-inbox fs-1 text-muted"></i>
                        <h5 class="mt-3">Aucune consultation</h5>
                        <p class="text-muted">Vous n'avez pas encore de consultations enregistrées.</p>
                        <a href="${pageContext.request.contextPath}/patient/creneaux-disponibles" 
                           class="btn btn-primary">
                            <i class="bi bi-calendar-plus me-1"></i>
                            Prendre un Rendez-vous
                        </a>
                    </div>
                <% } %>
            </div>
        </div>
        
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>