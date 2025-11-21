<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.*" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nouveau Créneau</title>
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
        List<Medecin> medecins = (List<Medecin>) request.getAttribute("medecins");
    %>
    
    <!-- Navbar avec Logo -->
    <nav class="navbar navbar-dark" style="background-color: #1692A6;">
        <div class="container-fluid">
            <a href="${pageContext.request.contextPath}/secretaire/creneaux" class="navbar-brand d-flex align-items-center">
                <img src="<%= request.getContextPath() %>/images/logo1.png" 
                     alt="Logo" 
                     style="height: 40px; width: auto; margin-right: 10px;">
                <i class="bi bi-arrow-left-circle me-2"></i>
                <span>Nouveau Créneau</span>
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
                            <i class="bi bi-calendar-plus-fill me-2"></i>
                            Créer un Nouveau Créneau
                        </h5>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/secretaire/nouveau-creneau" method="post">
                            
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
                            
                            <!-- Date -->
                            <div class="mb-3">
                                <label for="date" class="form-label">
                                    <i class="bi bi-calendar me-1"></i>
                                    Date <span class="text-danger">*</span>
                                </label>
                                <input type="date" class="form-control" id="date" name="date" required>
                                <small class="text-muted">Sélectionnez une date à partir d'aujourd'hui</small>
                            </div>
                            
                            <!-- Heure de Début -->
                            <div class="mb-3">
                                <label for="heureDebut" class="form-label">
                                    <i class="bi bi-clock me-1"></i>
                                    Heure de Début <span class="text-danger">*</span>
                                </label>
                                <input type="time" class="form-control" id="heureDebut" name="heureDebut" required>
                            </div>
                            
                            <!-- Heure de Fin -->
                            <div class="mb-3">
                                <label for="heureFin" class="form-label">
                                    <i class="bi bi-clock-fill me-1"></i>
                                    Heure de Fin <span class="text-danger">*</span>
                                </label>
                                <input type="time" class="form-control" id="heureFin" name="heureFin" required>
                            </div>
                            
                            <!-- Capacité -->
                            <div class="mb-3">
                                <label for="capacite" class="form-label">
                                    <i class="bi bi-people me-1"></i>
                                    Capacité (Nombre de patients) <span class="text-danger">*</span>
                                </label>
                                <input type="number" class="form-control" id="capacite" name="capacite" 
                                       value="10" min="1" max="50" required>
                            </div>
                            
                         
                            
                            <!-- Boutons -->
                            <div class="d-flex justify-content-between mt-4">
                                <a href="${pageContext.request.contextPath}/secretaire/creneaux" 
                                   class="btn btn-secondary">
                                    <i class="bi bi-x-circle me-1"></i>
                                    Annuler
                                </a>
                                <button type="submit" class="btn btn-primary"
                                        <%= (medecins == null || medecins.size() == 0) ? "disabled" : "" %>>
                                    <i class="bi bi-save me-1"></i>
                                    Créer le Créneau
                                </button>
                            </div>
                            
                        </form>
                    </div>
                </div>
                
                
            </div>
        </div>
        
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Définir la date minimale à aujourd'hui
        document.getElementById('date').min = new Date().toISOString().split('T')[0];
        
        // Validation: Heure fin > Heure début
        document.querySelector('form').addEventListener('submit', function(e) {
            const heureDebut = document.getElementById('heureDebut').value;
            const heureFin = document.getElementById('heureFin').value;
            
            if (heureDebut && heureFin && heureFin <= heureDebut) {
                e.preventDefault();
                alert('L\'heure de fin doit être après l\'heure de début !');
            }
        });
    </script>
</body>
</html>