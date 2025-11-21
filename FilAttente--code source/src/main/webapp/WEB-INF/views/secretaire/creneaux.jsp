<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Créneaux</title>
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
        List<Creneau> creneaux = (List<Creneau>) request.getAttribute("creneaux");
        
        @SuppressWarnings("unchecked")
        Map<Integer, Medecin> medecinsMap = (Map<Integer, Medecin>) request.getAttribute("medecinsMap");
    %>
    
    <!-- Navbar avec Logo -->
    <nav class="navbar navbar-dark" style="background-color: #1692A6;">
        <div class="container-fluid">
            <a href="${pageContext.request.contextPath}/secretaire/dashboard" class="navbar-brand d-flex align-items-center">
                <img src="<%= request.getContextPath() %>/images/logo1.png" 
                     alt="Logo" 
                     style="height: 40px; width: auto; margin-right: 10px;">
                <i class="bi bi-arrow-left-circle me-2"></i>
                <span>Liste des Créneaux</span>
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
                    <i class="bi bi-calendar-check-fill me-2"></i>
                    Gestion des Créneaux
                </h5>
                <a href="${pageContext.request.contextPath}/secretaire/nouveau-creneau" 
                   class="btn btn-light btn-sm">
                    <i class="bi bi-plus-circle me-1"></i>
                    Nouveau Créneau
                </a>
            </div>
            <div class="card-body">
                <% if (creneaux != null && creneaux.size() > 0) { %>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th><i class="bi bi-hash me-1"></i> Code</th>
                                    <th><i class="bi bi-heart-pulse me-1"></i> Médecin</th>
                                    <th><i class="bi bi-calendar me-1"></i> Date</th>
                                    <th><i class="bi bi-clock me-1"></i> Heure Début</th>
                                    <th><i class="bi bi-clock-fill me-1"></i> Heure Fin</th>
                                    <th><i class="bi bi-people me-1"></i> Capacité</th>
                                    <th><i class="bi bi-ticket me-1"></i> Tickets Pris</th>
                                    <th><i class="bi bi-activity me-1"></i> Disponibilité</th>
                                    <th><i class="bi bi-gear me-1"></i> Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Creneau creneau : creneaux) { 
                                    // Récupérer le médecin
                                    Medecin medecin = medecinsMap.get(creneau.getMedecinId());
                                    String medecinNom = medecin != null ? "Dr. " + medecin.getPrenom() + " " + medecin.getNom() : "Médecin #" + creneau.getMedecinId();
                                    
                                    // Badge disponibilité
                                    String badgeClass = "bg-secondary";
                                    String disponibiliteText = "Indisponible";
                                    
                                    if (creneau.isDisponible()) {
                                        // Vérifier si le créneau est plein
                                        if (creneau.getTicketsPris() >= creneau.getCapacite()) {
                                            badgeClass = "bg-danger";
                                            disponibiliteText = "Complet";
                                        } else {
                                            badgeClass = "bg-success";
                                            disponibiliteText = "Disponible";
                                        }
                                    } else {
                                        badgeClass = "bg-secondary";
                                        disponibiliteText = "Indisponible";
                                    }
                                    
                                    // Pourcentage de remplissage
                                    double pourcentage = 0;
                                    if (creneau.getCapacite() > 0) {
                                        pourcentage = (creneau.getTicketsPris() * 100.0) / creneau.getCapacite();
                                    }
                                %>
                                <tr>
                                    <td><strong><%= creneau.getCodeCreneau() != null ? creneau.getCodeCreneau() : "-" %></strong></td>
                                    <td><%= medecinNom %></td>
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
                                    <td>
                                        <div class="btn-group" role="group">
                                            <% if (creneau.isDisponible()) { %>
                                                <!-- Marquer comme indisponible -->
                                                <form action="${pageContext.request.contextPath}/secretaire/marquer-creneau-indisponible" 
                                                      method="post" style="display: inline;">
                                                    <input type="hidden" name="creneauId" value="<%= creneau.getId() %>">
                                                    <button type="submit" class="btn btn-warning btn-sm" 
                                                            title="Marquer comme indisponible">
                                                        <i class="bi bi-x-circle"></i>
                                                    </button>
                                                </form>
                                            <% } else { %>
                                                <!-- Marquer comme disponible -->
                                                <form action="${pageContext.request.contextPath}/secretaire/marquer-creneau-disponible" 
                                                      method="post" style="display: inline;">
                                                    <input type="hidden" name="creneauId" value="<%= creneau.getId() %>">
                                                    <button type="submit" class="btn btn-success btn-sm" 
                                                            title="Marquer comme disponible">
                                                        <i class="bi bi-check-circle"></i>
                                                    </button>
                                                </form>
                                            <% } %>
                                            
                                            <!-- Supprimer le créneau -->
                                            <form action="${pageContext.request.contextPath}/secretaire/supprimer-creneau" 
                                                  method="post" style="display: inline;">
                                                <input type="hidden" name="creneauId" value="<%= creneau.getId() %>">
                                                <button type="submit" class="btn btn-danger btn-sm" 
                                                        onclick="return confirm('Supprimer ce créneau ?\n\nAttention : Tous les tickets associés seront également supprimés !')" 
                                                        title="Supprimer le créneau">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </form>
                                        </div>
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
                        <p class="text-muted">Aucun créneau horaire enregistré.</p>
                        <a href="${pageContext.request.contextPath}/secretaire/nouveau-creneau" 
                           class="btn btn-primary">
                            <i class="bi bi-plus-circle me-1"></i>
                            Créer un Créneau
                        </a>
                    </div>
                <% } %>
            </div>
        </div>
        
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>