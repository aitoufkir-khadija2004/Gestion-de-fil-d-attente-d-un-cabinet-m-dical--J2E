<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Patients</title>
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
        List<Patient> patients = (List<Patient>) request.getAttribute("patients");
        
        @SuppressWarnings("unchecked")
        Map<Integer, Integer> consultationsCountMap = (Map<Integer, Integer>) request.getAttribute("consultationsCountMap");
    %>
    
    <!-- Navbar avec Logo -->
    <nav class="navbar navbar-dark" style="background-color: #28a745;">
        <div class="container-fluid">
            <a href="${pageContext.request.contextPath}/medecin/dashboard" class="navbar-brand d-flex align-items-center">
                <img src="<%= request.getContextPath() %>/images/logo1.png" 
                     alt="Logo" 
                     style="height: 40px; width: auto; margin-right: 10px;">
                <i class="bi bi-arrow-left-circle me-2"></i>
                <span>Mes Patients</span>
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
        
        <!-- Statistique rapide -->
        <div class="row mb-4">
            <div class="col-md-12">
                <div class="card border-0 shadow-sm">
                    <div class="card-body text-center">
                        <i class="bi bi-people-fill fs-1 text-success"></i>
                        <h3 class="mt-2 mb-0"><%= patients != null ? patients.size() : 0 %></h3>
                        <p class="text-muted mb-0">Patients suivis</p>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Liste des patients -->
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-success text-white">
                <h5 class="mb-0">
                    <i class="bi bi-person-lines-fill me-2"></i>
                    Liste de mes Patients
                </h5>
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
                                    <th><i class="bi bi-telephone me-1"></i> Téléphone</th>
                                    <th><i class="bi bi-calendar me-1"></i> Date de naissance</th>
                                    <th><i class="bi bi-droplet-fill me-1"></i> Groupe sanguin</th>
                                    <th><i class="bi bi-clipboard-check me-1"></i> Consultations</th>
                                    <th><i class="bi bi-gear me-1"></i> Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Patient patient : patients) { 
                                    int nbConsultations = 0;
                                    if (consultationsCountMap != null && consultationsCountMap.containsKey(patient.getId())) {
                                        nbConsultations = consultationsCountMap.get(patient.getId());
                                    }
                                %>
                                <tr>
                                    <td><strong><%= patient.getCodeUser() %></strong></td>
                                    <td><%= patient.getNom() != null ? patient.getNom() : "-" %></td>
                                    <td><%= patient.getPrenom() != null ? patient.getPrenom() : "-" %></td>
                                    <td>
                                        <% if (patient.getTelephone() != null && !patient.getTelephone().isEmpty()) { %>
                                            <i class="bi bi-telephone-fill text-success me-1"></i>
                                            <%= patient.getTelephone() %>
                                        <% } else { %>
                                            <span class="text-muted">-</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <%= patient.getDateNaissance() != null ? patient.getDateNaissance().toString() : "-" %>
                                    </td>
                                    <td>
                                        <% if (patient.getGroupeSanguin() != null && !patient.getGroupeSanguin().isEmpty()) { %>
                                            <span class="badge bg-danger">
                                                <i class="bi bi-droplet-fill me-1"></i>
                                                <%= patient.getGroupeSanguin() %>
                                            </span>
                                        <% } else { %>
                                            <span class="text-muted">-</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <span class="badge bg-info">
                                            <i class="bi bi-clipboard-check me-1"></i>
                                            <%= nbConsultations %> consultation(s)
                                        </span>
                                    </td>
                                    <td>
                                        <button type="button" class="btn btn-primary btn-sm" 
                                                data-bs-toggle="modal" 
                                                data-bs-target="#modalPatient<%= patient.getId() %>">
                                            <i class="bi bi-eye-fill"></i> Détails
                                        </button>
                                    </td>
                                </tr>
                                
                                <!-- Modal détails patient -->
                                <div class="modal fade" id="modalPatient<%= patient.getId() %>" tabindex="-1">
                                    <div class="modal-dialog modal-lg">
                                        <div class="modal-content">
                                            <div class="modal-header bg-success text-white">
                                                <h5 class="modal-title">
                                                    <i class="bi bi-person-badge me-2"></i>
                                                    Dossier Patient - <%= patient.getCodeUser() %>
                                                </h5>
                                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                            </div>
                                            <div class="modal-body">
                                                <h6 class="text-success mb-3">
                                                    <i class="bi bi-person-fill me-2"></i>
                                                    Informations Personnelles
                                                </h6>
                                                <div class="row mb-3">
                                                    <div class="col-md-6">
                                                        <p class="mb-2">
                                                            <strong>Nom complet :</strong><br>
                                                            <%= patient.getPrenom() %> <%= patient.getNom() %>
                                                        </p>
                                                        <p class="mb-2">
                                                            <strong>Date de naissance :</strong><br>
                                                            <%= patient.getDateNaissance() != null ? patient.getDateNaissance().toString() : "Non renseignée" %>
                                                        </p>
                                                        <p class="mb-2">
                                                            <strong>Groupe sanguin :</strong><br>
                                                            <% if (patient.getGroupeSanguin() != null && !patient.getGroupeSanguin().isEmpty()) { %>
                                                                <span class="badge bg-danger">
                                                                    <i class="bi bi-droplet-fill me-1"></i>
                                                                    <%= patient.getGroupeSanguin() %>
                                                                </span>
                                                            <% } else { %>
                                                                Non renseigné
                                                            <% } %>
                                                        </p>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <p class="mb-2">
                                                            <strong>Email :</strong><br>
                                                            <%= patient.getEmail() != null ? patient.getEmail() : "Non renseigné" %>
                                                        </p>
                                                        <p class="mb-2">
                                                            <strong>Téléphone :</strong><br>
                                                            <%= patient.getTelephone() != null ? patient.getTelephone() : "Non renseigné" %>
                                                        </p>
                                                        <p class="mb-2">
                                                            <strong>N° Sécurité Sociale :</strong><br>
                                                            <%= patient.getNumeroSecuriteSociale() != null ? patient.getNumeroSecuriteSociale() : "Non renseigné" %>
                                                        </p>
                                                    </div>
                                                </div>
                                                
                                                <% if (patient.getAdresse() != null && !patient.getAdresse().isEmpty()) { %>
                                                <h6 class="text-success mb-3">
                                                    <i class="bi bi-geo-alt-fill me-2"></i>
                                                    Adresse
                                                </h6>
                                                <p class="mb-3"><%= patient.getAdresse() %></p>
                                                <% } %>
                                                
                                                <h6 class="text-success mb-3">
                                                    <i class="bi bi-clipboard-data me-2"></i>
                                                    Historique Médical
                                                </h6>
                                                <div class="alert alert-info">
                                                    <i class="bi bi-info-circle me-2"></i>
                                                    <strong><%= nbConsultations %></strong> consultation(s) effectuée(s) avec vous.
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
                        <h5 class="mt-3">Aucun patient</h5>
                        <p class="text-muted">Vous n'avez pas encore consulté de patients.</p>
                    </div>
                <% } %>
            </div>
        </div>
        
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>