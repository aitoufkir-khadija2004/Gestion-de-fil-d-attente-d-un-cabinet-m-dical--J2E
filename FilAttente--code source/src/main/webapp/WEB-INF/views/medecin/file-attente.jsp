<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>File d'Attente</title>
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
        List<Ticket> fileAttente = (List<Ticket>) request.getAttribute("fileAttente");
        
        @SuppressWarnings("unchecked")
        Map<Integer, Patient> patientsMap = (Map<Integer, Patient>) request.getAttribute("patientsMap");
    %>
    
    <!-- Navbar avec Logo -->
    <nav class="navbar navbar-dark" style="background-color: #28a745;">
        <div class="container-fluid">
            <a href="${pageContext.request.contextPath}/medecin/dashboard" class="navbar-brand d-flex align-items-center">
                <img src="<%= request.getContextPath() %>/images/logo1.png" 
                     alt="Logo" 
                     style="height: 40px; width: auto; margin-right: 10px;">
                <i class="bi bi-arrow-left-circle me-2"></i>
                <span>File d'Attente</span>
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
        
        <!-- File d'Attente -->
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-success text-white">
                <h5 class="mb-0">
                    <i class="bi bi-people-fill me-2"></i>
                    Patients en Attente
                    <span class="badge bg-light text-dark ms-2">
                        <%= fileAttente != null ? fileAttente.size() : 0 %> patient(s)
                    </span>
                </h5>
            </div>
            <div class="card-body">
                <% if (fileAttente != null && fileAttente.size() > 0) { %>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th><i class="bi bi-list-ol me-1"></i> Position</th>
                                    <th><i class="bi bi-hash me-1"></i> Numéro Ticket</th>
                                    <th><i class="bi bi-person me-1"></i> Patient</th>
                                    <th><i class="bi bi-flag me-1"></i> Priorité</th>
                                    <th><i class="bi bi-activity me-1"></i> Statut</th>
                                    <th><i class="bi bi-gear me-1"></i> Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                int position = 1;
                                for (Ticket ticket : fileAttente) { 
                                    // Récupérer le patient
                                    Patient patient = patientsMap.get(ticket.getPatientId());
                                    String patientNom = patient != null ? patient.getPrenom() + " " + patient.getNom() : "Patient #" + ticket.getPatientId();
                                    
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
                                    
                                    // Badge Statut
                                    String statutClass = "bg-warning text-dark";
                                    String statutText = "En attente";
                                    if ("present".equals(ticket.getStatut())) {
                                        statutClass = "bg-primary";
                                        statutText = "Présent";
                                    }
                                %>
                                <tr <%= position == 1 ? "class='table-success'" : "" %>>
                                    <td>
                                        <strong class="fs-5"><%= position %></strong>
                                        <% if (position == 1) { %>
                                            <span class="badge bg-success ms-1">Suivant</span>
                                        <% } %>
                                    </td>
                                    <td><strong><%= ticket.getNumero() %></strong></td>
                                    <td><%= patientNom %></td>
                                    <td><span class="badge <%= prioriteClass %>"><%= prioriteText %></span></td>
                                    <td><span class="badge <%= statutClass %>"><%= statutText %></span></td>
                                    <td>
                                        <% if (position == 1 && "present".equals(ticket.getStatut())) { %>
                                            <!-- Premier patient présent - Peut être appelé -->
                                            <form action="${pageContext.request.contextPath}/medecin/appeler-patient" 
                                                  method="post" style="display: inline;">
                                                <input type="hidden" name="ticketId" value="<%= ticket.getId() %>">
                                                <button type="submit" class="btn btn-success btn-sm">
                                                    <i class="bi bi-person-check-fill me-1"></i> Appeler en Consultation
                                                </button>
                                            </form>
                                        <% } else if ("present".equals(ticket.getStatut())) { %>
                                            <!-- Patient présent mais pas le premier -->
                                            <span class="badge bg-primary">
                                                <i class="bi bi-hourglass-split me-1"></i> En attente
                                            </span>
                                        <% } else { %>
                                            <!-- Patient pas encore arrivé -->
                                            <span class="badge bg-warning text-dark">
                                                <i class="bi bi-clock me-1"></i> Pas encore arrivé
                                            </span>
                                        <% } %>
                                    </td>
                                </tr>
                                <% 
                                    position++;
                                } 
                                %>
                            </tbody>
                        </table>
                    </div>
                <% } else { %>
                    <div class="text-center py-5">
                        <i class="bi bi-inbox fs-1 text-muted"></i>
                        <h5 class="mt-3">Aucun patient en attente</h5>
                        <p class="text-muted">La file d'attente est vide pour le moment.</p>
                    </div>
                <% } %>
            </div>
        </div>
        
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>