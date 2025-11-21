<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.*" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nouveau Ticket</title>
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
        List<Medecin> medecins = (List<Medecin>) request.getAttribute("medecins");
        
        @SuppressWarnings("unchecked")
        List<Creneau> creneaux = (List<Creneau>) request.getAttribute("creneaux");
    %>
    
    <!-- Navbar avec Logo -->
    <nav class="navbar navbar-dark" style="background-color: #1692A6;">
        <div class="container-fluid">
            <a href="${pageContext.request.contextPath}/secretaire/tickets" class="navbar-brand d-flex align-items-center">
                <img src="<%= request.getContextPath() %>/images/logo1.png" 
                     alt="Logo" 
                     style="height: 40px; width: auto; margin-right: 10px;">
                <i class="bi bi-arrow-left-circle me-2"></i>
                <span>Nouveau Ticket</span>
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
        <% if (session.getAttribute("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                <%= session.getAttribute("error") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("error"); %>
        <% } %>
        
        <!-- Formulaire -->
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card border-0 shadow-sm">
                    <div class="card-header text-white" style="background-color: #1692A6;">
                        <h5 class="mb-0">
                            <i class="bi bi-ticket-perforated-fill me-2"></i>
                            Créer un Nouveau Ticket
                        </h5>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/secretaire/nouveau-ticket" method="post">
                            
                           
                            
                            <!-- Sélection du Patient -->
                            <div class="mb-3">
                                <label for="patientId" class="form-label">
                                    <i class="bi bi-person me-1"></i>
                                    Patient <span class="text-danger">*</span>
                                </label>
                                <% if (patients != null && patients.size() > 0) { %>
                                    <select class="form-select" id="patientId" name="patientId" required>
                                        <option value="">-- Sélectionnez un patient --</option>
                                        <% for (Patient patient : patients) { %>
                                            <option value="<%= patient.getId() %>">
                                                <%= patient.getCodeUser() %> - <%= patient.getPrenom() %> <%= patient.getNom() %>
                                                <% if (patient.getTelephone() != null) { %>
                                                    (Tel: <%= patient.getTelephone() %>)
                                                <% } %>
                                            </option>
                                        <% } %>
                                    </select>
                                <% } else { %>
                                    <input type="text" class="form-control" value="Aucun patient disponible" disabled>
                                    <small class="text-danger">Veuillez d'abord créer un patient.</small>
                                <% } %>
                            </div>
                            
                            <!-- Sélection du Médecin -->
                            <div class="mb-3">
                                <label for="medecinId" class="form-label">
                                    <i class="bi bi-heart-pulse me-1"></i>
                                    Médecin <span class="text-danger">*</span>
                                </label>
                                <% if (medecins != null && medecins.size() > 0) { %>
                                    <select class="form-select" id="medecinId" name="medecinId" required>
                                        <option value="">-- Sélectionnez un médecin --</option>
                                        <% for (Medecin medecin : medecins) { %>
                                            <option value="<%= medecin.getId() %>">
                                                Dr. <%= medecin.getPrenom() %> <%= medecin.getNom() %>
                                                <% if (medecin.getNomSpecialite() != null) { %>
                                                    - <%= medecin.getNomSpecialite() %>
                                                <% } %>
                                            </option>
                                        <% } %>
                                    </select>
                                <% } else { %>
                                    <input type="text" class="form-control" value="Aucun médecin disponible" disabled>
                                    <small class="text-danger">Aucun médecin enregistré dans le système.</small>
                                <% } %>
                            </div>
                            
                            <!-- Sélection du Créneau (Optionnel) -->
                            <div class="mb-3">
                                <label for="creneauId" class="form-label">
                                    <i class="bi bi-calendar-check me-1"></i>
                                    Créneau
                                </label>
                                <% if (creneaux != null && creneaux.size() > 0) { %>
                                    <select class="form-select" id="creneauId" name="creneauId">
                                        <option value="">-- Sans créneau spécifique --</option>
                                        <% for (Creneau creneau : creneaux) { %>
                                            <option value="<%= creneau.getId() %>">
                                                <%= creneau.getDate() %> - <%= creneau.getHeureDebut() %> à <%= creneau.getHeureFin() %>
                                            </option>
                                        <% } %>
                                    </select>
                                    <small class="text-muted">Si non sélectionné, le ticket sera pour aujourd'hui</small>
                                <% } else { %>
                                    <input type="text" class="form-control" value="Aucun créneau disponible" disabled>
                                    <small class="text-muted">Le ticket sera créé pour aujourd'hui sans créneau spécifique</small>
                                <% } %>
                            </div>
                            
                            <!-- Priorité -->
                            <div class="mb-3">
                                <label for="priorite" class="form-label">
                                    <i class="bi bi-flag me-1"></i>
                                    Priorité <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" id="priorite" name="priorite" required>
                                    <option value="1">Faible</option>
                                    <option value="2" selected>Normal</option>
                                    <option value="3">Urgent</option>
                                </select>
                            </div>
                            
                            <!-- Notes (Optionnel) -->
                            <div class="mb-3">
                                <label for="notes" class="form-label">
                                    <i class="bi bi-chat-left-text me-1"></i>
                                    Notes / Remarques
                                </label>
                                <textarea class="form-control" id="notes" name="notes" 
                                          rows="3" placeholder="Ajouter des notes ou remarques (optionnel)"></textarea>
                            </div>
                            
                            <!-- Boutons -->
                            <div class="d-flex justify-content-between mt-4">
                                <a href="${pageContext.request.contextPath}/secretaire/tickets" 
                                   class="btn btn-secondary">
                                    <i class="bi bi-x-circle me-1"></i>
                                    Annuler
                                </a>
                                <button type="submit" class="btn btn-primary" 
                                        <%= (patients == null || patients.size() == 0 || medecins == null || medecins.size() == 0) ? "disabled" : "" %>>
                                    <i class="bi bi-save me-1"></i>
                                    Créer le Ticket
                                </button>
                            </div>
                            
                        </form>
                    </div>
                </div>
            </div>
        </div>
        
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
