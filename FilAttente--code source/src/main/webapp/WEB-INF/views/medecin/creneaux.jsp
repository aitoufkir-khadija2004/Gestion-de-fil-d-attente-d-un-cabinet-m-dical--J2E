<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.*" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Créneaux</title>
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
        List<Creneau> creneaux = (List<Creneau>) request.getAttribute("creneaux");
    %>
    
    <!-- Navbar avec Logo -->
    <nav class="navbar navbar-dark" style="background-color: #28a745;">
        <div class="container-fluid">
            <a href="${pageContext.request.contextPath}/medecin/dashboard" class="navbar-brand d-flex align-items-center">
                <img src="<%= request.getContextPath() %>/images/logo1.png" 
                     alt="Logo" 
                     style="height: 40px; width: auto; margin-right: 10px;">
                <i class="bi bi-arrow-left-circle me-2"></i>
                <span>Mes Créneaux</span>
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
        
        <% if (session.getAttribute("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                <%= session.getAttribute("error") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("error"); %>
        <% } %>
        
        <!-- Formulaire de création de créneau -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-success text-white">
                <h5 class="mb-0">
                    <i class="bi bi-calendar-plus-fill me-2"></i>
                    Créer un Nouveau Créneau
                </h5>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/medecin/creer-creneau" method="post">
                    <div class="row">
                        <div class="col-md-3 mb-3">
                            <label for="date" class="form-label">
                                <i class="bi bi-calendar me-1"></i>
                                Date <span class="text-danger">*</span>
                            </label>
                            <input type="date" class="form-control" id="date" name="date" required>
                        </div>
                        
                        <div class="col-md-3 mb-3">
                            <label for="heureDebut" class="form-label">
                                <i class="bi bi-clock me-1"></i>
                                Heure Début <span class="text-danger">*</span>
                            </label>
                            <input type="time" class="form-control" id="heureDebut" name="heureDebut" required>
                        </div>
                        
                        <div class="col-md-3 mb-3">
                            <label for="heureFin" class="form-label">
                                <i class="bi bi-clock-fill me-1"></i>
                                Heure Fin <span class="text-danger">*</span>
                            </label>
                            <input type="time" class="form-control" id="heureFin" name="heureFin" required>
                        </div>
                        
                        <div class="col-md-3 mb-3">
                            <label for="capacite" class="form-label">
                                <i class="bi bi-people me-1"></i>
                                Capacité <span class="text-danger">*</span>
                            </label>
                            <input type="number" class="form-control" id="capacite" name="capacite" 
                                   value="10" min="1" max="50" required>
                        </div>
                    </div>
                    
                    <div class="text-end">
                        <button type="submit" class="btn btn-success">
                            <i class="bi bi-save me-1"></i>
                            Créer le Créneau
                        </button>
                    </div>
                </form>
            </div>
        </div>
        
        <!-- Liste des créneaux -->
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-success text-white">
                <h5 class="mb-0">
                    <i class="bi bi-calendar-check-fill me-2"></i>
                    Mes Créneaux Horaires
                </h5>
            </div>
            <div class="card-body">
                <% if (creneaux != null && creneaux.size() > 0) { %>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th><i class="bi bi-hash me-1"></i> Code</th>
                                    <th><i class="bi bi-calendar me-1"></i> Date</th>
                                    <th><i class="bi bi-clock me-1"></i> Heure Début</th>
                                    <th><i class="bi bi-clock-fill me-1"></i> Heure Fin</th>
                                    <th><i class="bi bi-people me-1"></i> Capacité</th>
                                    <th><i class="bi bi-ticket me-1"></i> Tickets Pris</th>
                                    <th><i class="bi bi-activity me-1"></i> Disponibilité</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Creneau creneau : creneaux) { 
                                    // Badge disponibilité
                                    String badgeClass = "bg-secondary";
                                    String disponibiliteText = "Indisponible";
                                    
                                    if (creneau.isDisponible()) {
                                        if (creneau.getTicketsPris() >= creneau.getCapacite()) {
                                            badgeClass = "bg-danger";
                                            disponibiliteText = "Complet";
                                        } else {
                                            badgeClass = "bg-success";
                                            disponibiliteText = "Disponible";
                                        }
                                    }
                                    
                                    // Pourcentage de remplissage
                                    double pourcentage = 0;
                                    if (creneau.getCapacite() > 0) {
                                        pourcentage = (creneau.getTicketsPris() * 100.0) / creneau.getCapacite();
                                    }
                                %>
                                <tr>
                                    <td><strong><%= creneau.getCodeCreneau() != null ? creneau.getCodeCreneau() : "-" %></strong></td>
                                    <td><%= creneau.getDate() != null ? creneau.getDate().toString() : "-" %></td>
                                    <td><%= creneau.getHeureDebut() != null ? creneau.getHeureDebut() : "-" %></td>
                                    <td><%= creneau.getHeureFin() != null ? creneau.getHeureFin() : "-" %></td>
                                    <td>
                                        <span class="badge bg-info">
                                            <i class="bi bi-people-fill me-1"></i>
                                            <%= creneau.getCapacite() %>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <span class="badge bg-primary me-2">
                                                <%= creneau.getTicketsPris() %> / <%= creneau.getCapacite() %>
                                            </span>
                                            <div class="progress" style="width: 60px; height: 8px;">
                                                <div class="progress-bar <%= pourcentage >= 80 ? "bg-danger" : pourcentage >= 50 ? "bg-warning" : "bg-success" %>" 
                                                     style="width: <%= pourcentage %>%">
                                                </div>
                                            </div>
                                        </div>
                                        <small class="text-muted"><%= String.format("%.0f", pourcentage) %>%</small>
                                    </td>
                                    <td>
                                        <span class="badge <%= badgeClass %>"><%= disponibiliteText %></span>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    
                    
                <% } else { %>
                    <div class="text-center py-5">
                        <i class="bi bi-inbox fs-1 text-muted"></i>
                        <h5 class="mt-3">Aucun créneau</h5>
                        <p class="text-muted">Vous n'avez pas encore créé de créneaux horaires.</p>
                        <small class="text-muted">Utilisez le formulaire ci-dessus pour créer votre premier créneau.</small>
                    </div>
                <% } %>
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