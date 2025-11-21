<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Prendre Rendez-vous</title>
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
        List<Creneau> creneaux = (List<Creneau>) request.getAttribute("creneaux");
        
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
                <span>Prendre Rendez-vous</span>
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
        
        <!-- Créneaux disponibles -->
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">
                    <i class="bi bi-calendar-check-fill me-2"></i>
                    Créneaux Disponibles
                </h5>
            </div>
            <div class="card-body">
                <% if (creneaux != null && creneaux.size() > 0) { %>
                    <div class="row">
                        <% for (Creneau creneau : creneaux) { 
                            // Récupérer le médecin
                            Medecin medecin = medecinsMap.get(creneau.getMedecinId());
                            String medecinNom = medecin != null ? "Dr. " + medecin.getPrenom() + " " + medecin.getNom() : "Médecin #" + creneau.getMedecinId();
                            String specialite = medecin != null && medecin.getNomSpecialite() != null ? medecin.getNomSpecialite() : "Médecine Générale";
                            
                            // Calculer les places restantes
                            int placesRestantes = creneau.getCapacite() - creneau.getTicketsPris();
                            double pourcentage = (creneau.getTicketsPris() * 100.0) / creneau.getCapacite();
                        %>
                        <div class="col-md-6 mb-3">
                            <div class="card h-100 border-primary">
                                <div class="card-body">
                                    <h5 class="card-title text-primary">
                                        <i class="bi bi-person-badge me-2"></i>
                                        <%= medecinNom %>
                                    </h5>
                                    <p class="text-muted mb-3">
                                        <i class="bi bi-award me-1"></i>
                                        <%= specialite %>
                                    </p>
                                    
                                    <p class="mb-2">
                                        <i class="bi bi-calendar me-2 text-primary"></i>
                                        <strong>Date :</strong> <%= creneau.getDate() != null ? creneau.getDate().toString() : "-" %>
                                    </p>
                                    <p class="mb-2">
                                        <i class="bi bi-clock me-2 text-primary"></i>
                                        <strong>Horaire :</strong> <%= creneau.getHeureDebut() %> - <%= creneau.getHeureFin() %>
                                    </p>
                                    <p class="mb-3">
                                        <i class="bi bi-people me-2 text-primary"></i>
                                        <strong>Places :</strong> 
                                        <span class="badge <%= placesRestantes <= 3 ? "bg-danger" : "bg-success" %>">
                                            <%= placesRestantes %> / <%= creneau.getCapacite() %> disponibles
                                        </span>
                                    </p>
                                    
                                    <!-- Barre de progression -->
                                    <div class="progress mb-3" style="height: 10px;">
                                        <div class="progress-bar <%= pourcentage >= 80 ? "bg-danger" : pourcentage >= 50 ? "bg-warning" : "bg-success" %>" 
                                             style="width: <%= pourcentage %>%">
                                        </div>
                                    </div>
                                    
                                    <form action="${pageContext.request.contextPath}/patient/prendre-rdv" method="post">
                                        <input type="hidden" name="creneauId" value="<%= creneau.getId() %>">
                                        <button type="submit" class="btn btn-primary w-100">
                                            <i class="bi bi-calendar-plus me-1"></i>
                                            Réserver ce Créneau
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div class="text-center py-5">
                        <i class="bi bi-inbox fs-1 text-muted"></i>
                        <h5 class="mt-3">Aucun créneau disponible</h5>
                        <p class="text-muted">Il n'y a pas de créneaux disponibles pour le moment. Veuillez réessayer plus tard.</p>
                    </div>
                <% } %>
            </div>
        </div>
        
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>