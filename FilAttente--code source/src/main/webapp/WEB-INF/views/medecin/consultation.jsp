<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Consultation en cours</title>
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
        
        Consultation consultation = (Consultation) request.getAttribute("consultation");
        Patient patient = (Patient) request.getAttribute("patient");
        Ticket ticket = (Ticket) request.getAttribute("ticket");
        
        if (consultation == null || patient == null) {
            response.sendRedirect(request.getContextPath() + "/medecin/file-attente");
            return;
        }
    %>
    
    <!-- Navbar avec Logo -->
    <nav class="navbar navbar-dark" style="background-color: #28a745;">
        <div class="container-fluid">
            <a href="${pageContext.request.contextPath}/medecin/file-attente" class="navbar-brand d-flex align-items-center">
                <img src="<%= request.getContextPath() %>/images/logo1.png" 
                     alt="Logo" 
                     style="height: 40px; width: auto; margin-right: 10px;">
                <i class="bi bi-arrow-left-circle me-2"></i>
                <span>Consultation en cours</span>
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
        
        <!-- Informations Patient -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">
                    <i class="bi bi-person-badge-fill me-2"></i>
                    Informations Patient
                </h5>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <p class="mb-2">
                            <strong><i class="bi bi-hash me-2"></i>Code Patient :</strong>
                            <span class="badge bg-secondary"><%= patient.getCodeUser() %></span>
                        </p>
                        <p class="mb-2">
                            <strong><i class="bi bi-person me-2"></i>Nom :</strong>
                            <%= patient.getNom() %> <%= patient.getPrenom() %>
                        </p>
                        <p class="mb-2">
                            <strong><i class="bi bi-telephone me-2"></i>Téléphone :</strong>
                            <%= patient.getTelephone() != null ? patient.getTelephone() : "-" %>
                        </p>
                    </div>
                    <div class="col-md-6">
                        <p class="mb-2">
                            <strong><i class="bi bi-calendar me-2"></i>Date de naissance :</strong>
                            <%= patient.getDateNaissance() != null ? patient.getDateNaissance().toString() : "-" %>
                        </p>
                        <p class="mb-2">
                            <strong><i class="bi bi-droplet-fill me-2"></i>Groupe sanguin :</strong>
                            <%= patient.getGroupeSanguin() != null ? patient.getGroupeSanguin() : "-" %>
                        </p>
                        <% if (ticket != null) { %>
                        <p class="mb-2">
                            <strong><i class="bi bi-ticket-perforated me-2"></i>Numéro Ticket :</strong>
                            <span class="badge bg-info"><%= ticket.getNumero() %></span>
                        </p>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Formulaire de Consultation -->
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-success text-white">
                <h5 class="mb-0">
                    <i class="bi bi-clipboard2-pulse-fill me-2"></i>
                    Dossier de Consultation
                </h5>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/medecin/terminer-consultation" method="post">
                    <input type="hidden" name="consultationId" value="<%= consultation.getId() %>">
                    <input type="hidden" name="ticketId" value="<%= ticket != null ? ticket.getId() : "" %>">
                    
                    <!-- Symptômes -->
                    <div class="mb-3">
                        <label for="symptomes" class="form-label">
                            <i class="bi bi-thermometer-half me-1"></i>
                            Symptômes <span class="text-danger">*</span>
                        </label>
                        <textarea class="form-control" id="symptomes" name="symptomes" 
                                  rows="3" placeholder="Décrivez les symptômes du patient..." required><%= consultation.getSymptomes() != null ? consultation.getSymptomes() : "" %></textarea>
                    </div>
                    
                    <!-- Diagnostic -->
                    <div class="mb-3">
                        <label for="diagnostic" class="form-label">
                            <i class="bi bi-clipboard-check me-1"></i>
                            Diagnostic <span class="text-danger">*</span>
                        </label>
                        <textarea class="form-control" id="diagnostic" name="diagnostic" 
                                  rows="3" placeholder="Entrez le diagnostic..." required><%= consultation.getDiagnostic() != null ? consultation.getDiagnostic() : "" %></textarea>
                    </div>
                    
                    <!-- Prescription -->
                    <div class="mb-3">
                        <label for="prescription" class="form-label">
                            <i class="bi bi-capsule me-1"></i>
                            Prescription / Ordonnance <span class="text-danger">*</span>
                        </label>
                        <textarea class="form-control" id="prescription" name="prescription" 
                                  rows="4" placeholder="Médicaments et posologie..." required><%= consultation.getPrescription() != null ? consultation.getPrescription() : "" %></textarea>
                        <small class="text-muted">
                            <i class="bi bi-info-circle me-1"></i>
                            Exemple: Doliprane 1000mg, 3 fois par jour pendant 7 jours
                        </small>
                    </div>
                    
                    <!-- Notes médicales -->
                    <div class="mb-3">
                        <label for="notesMedicales" class="form-label">
                            <i class="bi bi-journal-medical me-1"></i>
                            Notes Médicales (Optionnel)
                        </label>
                        <textarea class="form-control" id="notesMedicales" name="notesMedicales" 
                                  rows="3" placeholder="Notes complémentaires, observations..."><%= consultation.getNotesMedicales() != null ? consultation.getNotesMedicales() : "" %></textarea>
                    </div>
                    
                    <!-- Durée de la consultation -->
                    <div class="mb-3">
                        <label for="dureeConsultation" class="form-label">
                            <i class="bi bi-clock me-1"></i>
                            Durée de la consultation (minutes)
                        </label>
                        <input type="number" class="form-control" id="dureeConsultation" 
                               name="dureeConsultation" value="<%= consultation.getDureeConsultation() %>" 
                               min="5" max="120" step="5">
                    </div>
                    
                    <!-- Boutons -->
                    <div class="d-flex justify-content-between mt-4">
                        <a href="${pageContext.request.contextPath}/medecin/file-attente" 
                           class="btn btn-secondary">
                            <i class="bi bi-x-circle me-1"></i>
                            Annuler
                        </a>
                        <div>
                            <button type="submit" name="action" value="enregistrer" class="btn btn-warning me-2">
                                <i class="bi bi-save me-1"></i>
                                Enregistrer (continuer plus tard)
                            </button>
                            <button type="submit" name="action" value="terminer" class="btn btn-success">
                                <i class="bi bi-check-circle-fill me-1"></i>
                                Terminer la Consultation
                            </button>
                        </div>
                    </div>
                    
                </form>
            </div>
        </div>
        
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>