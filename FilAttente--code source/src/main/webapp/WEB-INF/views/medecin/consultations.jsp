<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
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
        if (user == null || !"MEDECIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        @SuppressWarnings("unchecked")
        List<Consultation> consultations = (List<Consultation>) request.getAttribute("consultations");
        
        @SuppressWarnings("unchecked")
        Map<Integer, Patient> patientsMap = (Map<Integer, Patient>) request.getAttribute("patientsMap");
        
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    %>
    
    <!-- Navbar avec Logo -->
    <nav class="navbar navbar-dark" style="background-color: #28a745;">
        <div class="container-fluid">
            <a href="${pageContext.request.contextPath}/medecin/dashboard" class="navbar-brand d-flex align-items-center">
                <img src="<%= request.getContextPath() %>/images/logo1.png" 
                     alt="Logo" 
                     style="height: 40px; width: auto; margin-right: 10px;">
                <i class="bi bi-arrow-left-circle me-2"></i>
                <span>Mes Consultations</span>
            </a>
            <div class="d-flex align-items-center text-white">
                <span class="me-3">
                    <i class="bi bi-person-circle me-1"></i>
                    Dr. <%= user.getPrenom() %> <%= user.getNom() %>
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
        
        <!-- Statistiques rapides -->
        <div class="row mb-4">
            <div class="col-md-6">
                <div class="card border-0 shadow-sm">
                    <div class="card-body text-center">
                        <i class="bi bi-calendar-check-fill fs-1 text-primary"></i>
                        <h3 class="mt-2 mb-0"><%= consultations != null ? consultations.size() : 0 %></h3>
                        <p class="text-muted mb-0">Total Consultations</p>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card border-0 shadow-sm">
                    <div class="card-body text-center">
                        <i class="bi bi-check-circle-fill fs-1 text-success"></i>
                        <h3 class="mt-2 mb-0">
                            <% 
                            int nbTerminees = 0;
                            if (consultations != null) {
                                for (Consultation c : consultations) {
                                    if ("terminee".equals(c.getStatut())) {
                                        nbTerminees++;
                                    }
                                }
                            }
                            %>
                            <%= nbTerminees %>
                        </h3>
                        <p class="text-muted mb-0">Terminées</p>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Liste des consultations -->
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-success text-white">
                <h5 class="mb-0">
                    <i class="bi bi-clipboard-check-fill me-2"></i>
                    Liste de mes Consultations
                </h5>
            </div>
            <div class="card-body">
                <% if (consultations != null && consultations.size() > 0) { %>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th><i class="bi bi-hash me-1"></i> Code</th>
                                    <th><i class="bi bi-person me-1"></i> Patient</th>
                                    <th><i class="bi bi-calendar me-1"></i> Date</th>
                                    <th><i class="bi bi-thermometer me-1"></i> Symptômes</th>
                                    <th><i class="bi bi-clipboard-check me-1"></i> Diagnostic</th>
                                    <th><i class="bi bi-clock me-1"></i> Durée</th>
                                    <th><i class="bi bi-activity me-1"></i> Statut</th>
                                    <th><i class="bi bi-gear me-1"></i> Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Consultation consultation : consultations) { 
                                    Patient patient = patientsMap.get(consultation.getPatientId());
                                    String patientNom = patient != null ? patient.getPrenom() + " " + patient.getNom() : "Patient #" + consultation.getPatientId();
                                    
                                    String badgeClass = "en_cours".equals(consultation.getStatut()) ? "bg-warning text-dark" : "bg-success";
                                    String statutText = "en_cours".equals(consultation.getStatut()) ? "En cours" : "Terminée";
                                %>
                                <tr>
                                    <td><strong><%= consultation.getCodeConsultation() %></strong></td>
                                    <td><%= patientNom %></td>
                                    <td><%= dateFormat.format(consultation.getDateConsultation()) %></td>
                                    <td>
                                        <% if (consultation.getSymptomes() != null && !consultation.getSymptomes().isEmpty()) { %>
                                            <%= consultation.getSymptomes().length() > 50 ? 
                                                consultation.getSymptomes().substring(0, 50) + "..." : 
                                                consultation.getSymptomes() %>
                                        <% } else { %>
                                            <span class="text-muted">-</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <% if (consultation.getDiagnostic() != null && !consultation.getDiagnostic().isEmpty()) { %>
                                            <%= consultation.getDiagnostic().length() > 50 ? 
                                                consultation.getDiagnostic().substring(0, 50) + "..." : 
                                                consultation.getDiagnostic() %>
                                        <% } else { %>
                                            <span class="text-muted">-</span>
                                        <% } %>
                                    </td>
                                    <td><%= consultation.getDureeConsultation() %> min</td>
                                    <td><span class="badge <%= badgeClass %>"><%= statutText %></span></td>
                                    <td>
                                      <% if ("en_cours".equals(consultation.getStatut())) { %>
    <a href="${pageContext.request.contextPath}/medecin/consultation?id=<%= consultation.getId() %>" 
       class="btn btn-warning btn-sm">
        <i class="bi bi-pencil-fill"></i> Continuer
    </a>
<% }  else { %>
                                            <button type="button" class="btn btn-info btn-sm" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#modalConsultation<%= consultation.getId() %>">
                                                <i class="bi bi-eye-fill"></i> Voir
                                            </button>
                                        <% } %>
                                    </td>
                                </tr>
                                
                                <!-- Modal pour voir les détails -->
                                <div class="modal fade" id="modalConsultation<%= consultation.getId() %>" tabindex="-1">
                                    <div class="modal-dialog modal-lg">
                                        <div class="modal-content">
                                            <div class="modal-header bg-success text-white">
                                                <h5 class="modal-title">
                                                    <i class="bi bi-clipboard-check me-2"></i>
                                                    Consultation <%= consultation.getCodeConsultation() %>
                                                </h5>
                                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                            </div>
                                            <div class="modal-body">
                                                <h6 class="text-muted mb-3">Patient : <%= patientNom %></h6>
                                                
                                                <div class="mb-3">
                                                    <strong><i class="bi bi-thermometer me-2"></i>Symptômes :</strong>
                                                    <p class="mb-0"><%= consultation.getSymptomes() != null ? consultation.getSymptomes() : "-" %></p>
                                                </div>
                                                
                                                <div class="mb-3">
                                                    <strong><i class="bi bi-clipboard-check me-2"></i>Diagnostic :</strong>
                                                    <p class="mb-0"><%= consultation.getDiagnostic() != null ? consultation.getDiagnostic() : "-" %></p>
                                                </div>
                                                
                                                <div class="mb-3">
                                                    <strong><i class="bi bi-capsule me-2"></i>Prescription :</strong>
                                                    <p class="mb-0"><%= consultation.getPrescription() != null ? consultation.getPrescription() : "-" %></p>
                                                </div>
                                                
                                                <% if (consultation.getNotesMedicales() != null && !consultation.getNotesMedicales().isEmpty()) { %>
                                                <div class="mb-3">
                                                    <strong><i class="bi bi-journal-medical me-2"></i>Notes Médicales :</strong>
                                                    <p class="mb-0"><%= consultation.getNotesMedicales() %></p>
                                                </div>
                                                <% } %>
                                                
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <small class="text-muted">
                                                            <i class="bi bi-calendar me-1"></i>
                                                            Date : <%= dateFormat.format(consultation.getDateConsultation()) %>
                                                        </small>
                                                    </div>
                                                    <div class="col-md-6 text-end">
                                                        <small class="text-muted">
                                                            <i class="bi bi-clock me-1"></i>
                                                            Durée : <%= consultation.getDureeConsultation() %> minutes
                                                        </small>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } else { %>
                    <div class="text-center py-5">
                        <i class="bi bi-inbox fs-1 text-muted"></i>
                        <h5 class="mt-3">Aucune consultation</h5>
                        <p class="text-muted">Vous n'avez pas encore de consultations enregistrées.</p>
                    </div>
                <% } %>
            </div>
        </div>
        
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>