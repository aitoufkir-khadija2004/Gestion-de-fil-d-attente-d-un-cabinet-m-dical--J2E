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
    <title>Liste des Tickets</title>
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
        List<Ticket> tickets = (List<Ticket>) request.getAttribute("tickets");
        
        @SuppressWarnings("unchecked")
        Map<Integer, Patient> patientsMap = (Map<Integer, Patient>) request.getAttribute("patientsMap");
        
        @SuppressWarnings("unchecked")
        Map<Integer, Medecin> medecinsMap = (Map<Integer, Medecin>) request.getAttribute("medecinsMap");
        
        @SuppressWarnings("unchecked")
        Map<Integer, Creneau> creneauxMap = (Map<Integer, Creneau>) request.getAttribute("creneauxMap");
        
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    %>
    
    <!-- Navbar avec Logo -->
    <nav class="navbar navbar-dark" style="background-color: #1692A6;">
        <div class="container-fluid">
            <a href="${pageContext.request.contextPath}/secretaire/dashboard" class="navbar-brand d-flex align-items-center">
                <img src="<%= request.getContextPath() %>/images/logo1.png" 
                     alt="Logo" 
                     style="height: 40px; width: auto; margin-right: 10px;">
                <i class="bi bi-arrow-left-circle me-2"></i>
                <span>Gestion des Tickets</span>
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
                    <i class="bi bi-ticket-perforated-fill me-2"></i>
                    Gestion des Tickets
                </h5>
                <a href="${pageContext.request.contextPath}/secretaire/nouveau-ticket" 
                   class="btn btn-light btn-sm">
                    <i class="bi bi-plus-circle me-1"></i>
                    Nouveau Ticket
                </a>
            </div>
            <div class="card-body">
                <% if (tickets != null && tickets.size() > 0) { %>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th><i class="bi bi-hash me-1"></i> Numéro</th>
                                    <th><i class="bi bi-person me-1"></i> Patient</th>
                                    <th><i class="bi bi-heart-pulse me-1"></i> Médecin</th>
                                    <th><i class="bi bi-calendar me-1"></i> Date</th>
                                    <th><i class="bi bi-flag me-1"></i> Priorité</th>
                                    <th><i class="bi bi-activity me-1"></i> Statut</th>
                                    <th><i class="bi bi-gear me-1"></i> Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Ticket ticket : tickets) { 
                                    // Récupérer le patient
                                    Patient patient = patientsMap.get(ticket.getPatientId());
                                    String patientNom = patient != null ? patient.getPrenom() + " " + patient.getNom() : "Patient #" + ticket.getPatientId();
                                    
                                    // Récupérer le médecin
                                    Medecin medecin = medecinsMap.get(ticket.getMedecinId());
                                    String medecinNom = medecin != null ? "Dr. " + medecin.getPrenom() + " " + medecin.getNom() : "Médecin #" + ticket.getMedecinId();
                                    
                                    // Récupérer le créneau pour la date
                                    Creneau creneau = creneauxMap.get(ticket.getCreneauId());
                                    String dateAffichage = "-";
                                    if (creneau != null && creneau.getDate() != null) {
                                        dateAffichage = creneau.getDate().toString() + " " + creneau.getHeureDebut();
                                    } else if (ticket.getDateCreation() != null) {
                                        dateAffichage = dateFormat.format(ticket.getDateCreation());
                                    }
                                    
                                    // Badge Statut
                                    String badgeClass = "bg-warning text-dark";
                                    String statutText = "En attente";
                                    
                                    if ("appele".equals(ticket.getStatut())) {
                                        badgeClass = "bg-info";
                                        statutText = "Appelé";
                                    } else if ("present".equals(ticket.getStatut())) {
                                        badgeClass = "bg-primary";
                                        statutText = "Présent";
                                    } else if ("en_consultation".equals(ticket.getStatut())) {
                                        badgeClass = "bg-success";
                                        statutText = "En consultation";
                                    } else if ("termine".equals(ticket.getStatut())) {
                                        badgeClass = "bg-secondary";
                                        statutText = "Terminé";
                                    } else if ("annule".equals(ticket.getStatut())) {
                                        badgeClass = "bg-danger";
                                        statutText = "Annulé";
                                    }
                                    
                                    // Badge Priorité
                                    String prioriteClass = "bg-secondary";
                                    String prioriteText = "Faible";
                                    if (ticket.getPriorite() == 2) {
                                        prioriteClass = "bg-warning text-dark";
                                        prioriteText = "Normal";
                                    } else if (ticket.getPriorite() == 3) {
                                        prioriteClass = "bg-danger";
                                        prioriteText = "Urgent";
                                    }
                                %>
                                <tr>
                                    <td><strong><%= ticket.getNumero() %></strong></td>
                                    <td><%= patientNom %></td>
                                    <td><%= medecinNom %></td>
                                    <td><%= dateAffichage %></td>
                                    <td><span class="badge <%= prioriteClass %>"><%= prioriteText %></span></td>
                                    <td><span class="badge <%= badgeClass %>"><%= statutText %></span></td>
                                    <td>
                                        <% if ("en_attente".equals(ticket.getStatut())) { %>
                                            <div class="btn-group" role="group">
                                                <form action="${pageContext.request.contextPath}/secretaire/appeler-patient" 
                                                      method="post" style="display: inline;">
                                                    <input type="hidden" name="ticketId" value="<%= ticket.getId() %>">
                                                    <button type="submit" class="btn btn-warning btn-sm" 
                                                            title="Appeler le patient via WhatsApp">
                                                        <i class="bi bi-telephone-fill"></i> Appeler
                                                    </button>
                                                </form>
                                                <form action="${pageContext.request.contextPath}/secretaire/annuler-ticket" 
                                                      method="post" style="display: inline;">
                                                    <input type="hidden" name="ticketId" value="<%= ticket.getId() %>">
                                                    <button type="submit" class="btn btn-danger btn-sm ms-1" 
                                                            onclick="return confirm('Annuler ce ticket ?')">
                                                        <i class="bi bi-x-circle"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        <% } else if ("appele".equals(ticket.getStatut())) { %>
                                            <form action="${pageContext.request.contextPath}/secretaire/valider-arrivee" 
                                                  method="post" style="display: inline;">
                                                <input type="hidden" name="ticketId" value="<%= ticket.getId() %>">
                                                <button type="submit" class="btn btn-success btn-sm">
                                                    <i class="bi bi-check-circle-fill"></i> Valider Arrivée
                                                </button>
                                            </form>
                                        <% } else if ("present".equals(ticket.getStatut())) { %>
                                            <span class="badge bg-primary">En attente médecin</span>
                                        <% } else if ("en_consultation".equals(ticket.getStatut())) { %>
                                            <span class="badge bg-success">En cours</span>
                                        <% } else if ("termine".equals(ticket.getStatut())) { %>
                                            <span class="badge bg-secondary">Terminé</span>
                                        <% } else if ("annule".equals(ticket.getStatut())) { %>
                                            <span class="badge bg-danger">Annulé</span>
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
                        <h5 class="mt-3">Aucun ticket</h5>
                        <p class="text-muted">Aucun ticket enregistré.</p>
                        <a href="${pageContext.request.contextPath}/secretaire/nouveau-ticket" 
                           class="btn btn-primary">
                            <i class="bi bi-plus-circle me-1"></i>
                            Créer un Ticket
                        </a>
                    </div>
                <% } %>
            </div>
        </div>
        
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>