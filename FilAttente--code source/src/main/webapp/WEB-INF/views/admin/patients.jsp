<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.*" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Patients</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light">
    <%
        User user = (User) session.getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        @SuppressWarnings("unchecked")
        List<Patient> patients = (List<Patient>) request.getAttribute("patients");
    %>
    
    <!-- Navbar avec Logo -->
    <nav class="navbar navbar-dark" style="background-color: #dc3545;">
        <div class="container-fluid">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="navbar-brand d-flex align-items-center">
                <img src="<%= request.getContextPath() %>/images/logo1.png" 
                     alt="Logo" 
                     style="height: 40px; width: auto; margin-right: 10px;">
                <i class="bi bi-arrow-left-circle me-2"></i>
                <span>Gestion des Patients</span>
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
        
        <!-- Liste des patients -->
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                <h5 class="mb-0">
                    <i class="bi bi-people-fill me-2"></i>
                    Liste des Patients
                    <span class="badge bg-light text-dark ms-2"><%= patients != null ? patients.size() : 0 %></span>
                </h5>
                <a href="${pageContext.request.contextPath}/admin/creer-utilisateur" 
                   class="btn btn-light btn-sm">
                    <i class="bi bi-plus-circle me-1"></i>
                    Nouveau Patient
                </a>
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
                                    <th><i class="bi bi-envelope me-1"></i> Email</th>
                                    <th><i class="bi bi-telephone me-1"></i> Téléphone</th>
                                    <th><i class="bi bi-droplet-fill me-1"></i> Groupe Sanguin</th>
                                    <th><i class="bi bi-activity me-1"></i> Statut</th>
                                    <th><i class="bi bi-gear me-1"></i> Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Patient patient : patients) { %>
                                <tr <%= !patient.isActif() ? "class='table-secondary'" : "" %>>
                                    <td><strong><%= patient.getCodeUser() %></strong></td>
                                    <td><%= patient.getNom() != null ? patient.getNom() : "-" %></td>
                                    <td><%= patient.getPrenom() != null ? patient.getPrenom() : "-" %></td>
                                    <td>
                                        <% if (patient.getEmail() != null && !patient.getEmail().isEmpty()) { %>
                                            <i class="bi bi-envelope-fill text-primary me-1"></i>
                                            <%= patient.getEmail() %>
                                        <% } else { %>
                                            <span class="text-muted">-</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <% if (patient.getTelephone() != null && !patient.getTelephone().isEmpty()) { %>
                                            <i class="bi bi-telephone-fill text-success me-1"></i>
                                            <%= patient.getTelephone() %>
                                        <% } else { %>
                                            <span class="text-muted">-</span>
                                        <% } %>
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
                                        <% if (patient.isActif()) { %>
                                            <span class="badge bg-success">Actif</span>
                                        <% } else { %>
                                            <span class="badge bg-secondary">Inactif</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <!-- Bouton Modifier -->
                                        <button type="button" class="btn btn-warning btn-sm me-1" 
                                                data-bs-toggle="modal" 
                                                data-bs-target="#modalModifierPatient<%= patient.getId() %>">
                                            <i class="bi bi-pencil-fill"></i>
                                        </button>
                                        
                                        <!-- Bouton Activer/Désactiver -->
                                        <% if (patient.isActif()) { %>
                                            <button type="button" class="btn btn-secondary btn-sm" 
                                                    onclick="confirmerDesactivation(<%= patient.getId() %>, '<%= patient.getPrenom() %> <%= patient.getNom() %>')">
                                                <i class="bi bi-x-circle-fill"></i>
                                            </button>
                                        <% } else { %>
                                            <button type="button" class="btn btn-success btn-sm" 
                                                    onclick="confirmerActivation(<%= patient.getId() %>, '<%= patient.getPrenom() %> <%= patient.getNom() %>')">
                                                <i class="bi bi-check-circle-fill"></i>
                                            </button>
                                        <% } %>
                                    </td>
                                </tr>
                                
                                <!-- Modal MODIFIER patient -->
                                <div class="modal fade" id="modalModifierPatient<%= patient.getId() %>" tabindex="-1">
                                    <div class="modal-dialog modal-lg">
                                        <div class="modal-content">
                                            <div class="modal-header bg-warning">
                                                <h5 class="modal-title">
                                                    <i class="bi bi-pencil me-2"></i>
                                                    Modifier Patient - <%= patient.getCodeUser() %>
                                                </h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                            </div>
                                            <form action="${pageContext.request.contextPath}/admin/modifier-utilisateur" method="post">
                                                <div class="modal-body">
                                                    <input type="hidden" name="userId" value="<%= patient.getId() %>">
                                                    <input type="hidden" name="role" value="PATIENT">
                                                    <input type="hidden" name="redirectPage" value="patients">
                                                    
                                                    <div class="row">
                                                        <div class="col-md-6 mb-3">
                                                            <label class="form-label">Nom <span class="text-danger">*</span></label>
                                                            <input type="text" class="form-control" name="nom" 
                                                                   value="<%= patient.getNom() %>" required>
                                                        </div>
                                                        <div class="col-md-6 mb-3">
                                                            <label class="form-label">Prénom <span class="text-danger">*</span></label>
                                                            <input type="text" class="form-control" name="prenom" 
                                                                   value="<%= patient.getPrenom() %>" required>
                                                        </div>
                                                    </div>
                                                    
                                                    <div class="row">
                                                        <div class="col-md-6 mb-3">
                                                            <label class="form-label">Email <span class="text-danger">*</span></label>
                                                            <input type="email" class="form-control" name="email" 
                                                                   value="<%= patient.getEmail() %>" required>
                                                        </div>
                                                        <div class="col-md-6 mb-3">
                                                            <label class="form-label">Téléphone</label>
                                                            <input type="tel" class="form-control" name="telephone" 
                                                                   value="<%= patient.getTelephone() != null ? patient.getTelephone() : "" %>">
                                                        </div>
                                                    </div>
                                                    
                                                    <div class="row">
                                                        <div class="col-md-6 mb-3">
                                                            <label class="form-label">Date de Naissance</label>
                                                            <input type="date" class="form-control" name="dateNaissance" 
                                                                   value="<%= patient.getDateNaissance() != null ? patient.getDateNaissance().toString() : "" %>">
                                                        </div>
                                                        <div class="col-md-6 mb-3">
                                                            <label class="form-label">Groupe Sanguin</label>
                                                            <select class="form-select" name="groupeSanguin">
                                                                <option value="">-- Sélectionner --</option>
                                                                <option value="A+" <%= "A+".equals(patient.getGroupeSanguin()) ? "selected" : "" %>>A+</option>
                                                                <option value="A-" <%= "A-".equals(patient.getGroupeSanguin()) ? "selected" : "" %>>A-</option>
                                                                <option value="B+" <%= "B+".equals(patient.getGroupeSanguin()) ? "selected" : "" %>>B+</option>
                                                                <option value="B-" <%= "B-".equals(patient.getGroupeSanguin()) ? "selected" : "" %>>B-</option>
                                                                <option value="AB+" <%= "AB+".equals(patient.getGroupeSanguin()) ? "selected" : "" %>>AB+</option>
                                                                <option value="AB-" <%= "AB-".equals(patient.getGroupeSanguin()) ? "selected" : "" %>>AB-</option>
                                                                <option value="O+" <%= "O+".equals(patient.getGroupeSanguin()) ? "selected" : "" %>>O+</option>
                                                                <option value="O-" <%= "O-".equals(patient.getGroupeSanguin()) ? "selected" : "" %>>O-</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    
                                                    <div class="mb-3">
                                                        <label class="form-label">N° Sécurité Sociale</label>
                                                        <input type="text" class="form-control" name="numeroSecuriteSociale" 
                                                               value="<%= patient.getNumeroSecuriteSociale() != null ? patient.getNumeroSecuriteSociale() : "" %>">
                                                    </div>
                                                    
                                                    <div class="mb-3">
                                                        <label class="form-label">Adresse</label>
                                                        <textarea class="form-control" name="adresse" rows="2"><%= patient.getAdresse() != null ? patient.getAdresse() : "" %></textarea>
                                                    </div>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                                                    <button type="submit" class="btn btn-warning">
                                                        <i class="bi bi-save me-1"></i>
                                                        Enregistrer
                                                    </button>
                                                </div>
                                            </form>
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
                        <p class="text-muted">Aucun patient enregistré dans le système.</p>
                        <a href="${pageContext.request.contextPath}/admin/creer-utilisateur" 
                           class="btn btn-primary">
                            <i class="bi bi-plus-circle me-1"></i>
                            Créer un Patient
                        </a>
                    </div>
                <% } %>
            </div>
        </div>
        
    </div>
    
    <!-- Formulaire caché pour Activer -->
    <form id="formActiver" action="${pageContext.request.contextPath}/admin/activer-utilisateur" method="post" style="display: none;">
        <input type="hidden" name="userId" id="userIdToActivate">
        <input type="hidden" name="redirectPage" value="patients">
    </form>
    
    <!-- Formulaire caché pour Désactiver -->
    <form id="formDesactiver" action="${pageContext.request.contextPath}/admin/desactiver-utilisateur" method="post" style="display: none;">
        <input type="hidden" name="userId" id="userIdToDeactivate">
        <input type="hidden" name="redirectPage" value="patients">
    </form>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmerActivation(userId, nom) {
            if (confirm('Voulez-vous activer le patient "' + nom + '" ?')) {
                document.getElementById('userIdToActivate').value = userId;
                document.getElementById('formActiver').submit();
            }
        }
        
        function confirmerDesactivation(userId, nom) {
            if (confirm('Voulez-vous désactiver le patient "' + nom + '" ?')) {
                document.getElementById('userIdToDeactivate').value = userId;
                document.getElementById('formDesactiver').submit();
            }
        }
    </script>
</body>
</html>