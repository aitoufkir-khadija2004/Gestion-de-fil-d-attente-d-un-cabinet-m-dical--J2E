<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.*" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Médecins</title>
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
        List<Medecin> medecins = (List<Medecin>) request.getAttribute("medecins");
        
        @SuppressWarnings("unchecked")
        List<Specialite> specialites = (List<Specialite>) request.getAttribute("specialites");
        
        // ✅ DEBUG
        System.out.println("🔍 DEBUG medecins.jsp: Nombre de spécialités = " + (specialites != null ? specialites.size() : 0));
        if (specialites != null) {
            for (Specialite s : specialites) {
                System.out.println("  - " + s.getNom() + " (ID: " + s.getId() + ")");
            }
        }
    %>
    
    <!-- Navbar avec Logo -->
    <nav class="navbar navbar-dark" style="background-color: #dc3545;">
        <div class="container-fluid">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="navbar-brand d-flex align-items-center">
                <img src="<%= request.getContextPath() %>/images/logo1.png" 
                     alt="Logo" 
                     style="height: 40px; width: auto; margin-right: 10px;">
                <i class="bi bi-arrow-left-circle me-2"></i>
                <span>Gestion des Médecins</span>
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
        
        <!-- Liste des médecins -->
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-success text-white d-flex justify-content-between align-items-center">
                <h5 class="mb-0">
                    <i class="bi bi-person-fill-gear me-2"></i>
                    Liste des Médecins
                    <span class="badge bg-light text-dark ms-2"><%= medecins != null ? medecins.size() : 0 %></span>
                </h5>
                <a href="${pageContext.request.contextPath}/admin/creer-utilisateur" 
                   class="btn btn-light btn-sm">
                    <i class="bi bi-plus-circle me-1"></i>
                    Nouveau Médecin
                </a>
            </div>
            <div class="card-body">
                <% if (medecins != null && medecins.size() > 0) { %>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th><i class="bi bi-hash me-1"></i> Code</th>
                                    <th><i class="bi bi-person me-1"></i> Nom</th>
                                    <th><i class="bi bi-person me-1"></i> Prénom</th>
                                    <th><i class="bi bi-envelope me-1"></i> Email</th>
                                    <th><i class="bi bi-telephone me-1"></i> Téléphone</th>
                                    <th><i class="bi bi-award me-1"></i> Spécialité</th>
                                    <th><i class="bi bi-activity me-1"></i> Statut</th>
                                    <th><i class="bi bi-gear me-1"></i> Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Medecin medecin : medecins) { %>
                                <tr <%= !medecin.isActif() ? "class='table-secondary'" : "" %>>
                                    <td><strong><%= medecin.getCodeUser() %></strong></td>
                                    <td><%= medecin.getNom() != null ? medecin.getNom() : "-" %></td>
                                    <td><%= medecin.getPrenom() != null ? medecin.getPrenom() : "-" %></td>
                                    <td>
                                        <% if (medecin.getEmail() != null && !medecin.getEmail().isEmpty()) { %>
                                            <i class="bi bi-envelope-fill text-success me-1"></i>
                                            <%= medecin.getEmail() %>
                                        <% } else { %>
                                            <span class="text-muted">-</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <% if (medecin.getTelephone() != null && !medecin.getTelephone().isEmpty()) { %>
                                            <i class="bi bi-telephone-fill text-primary me-1"></i>
                                            <%= medecin.getTelephone() %>
                                        <% } else { %>
                                            <span class="text-muted">-</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <% if (medecin.getNomSpecialite() != null && !medecin.getNomSpecialite().isEmpty()) { %>
                                            <span class="badge bg-info">
                                                <i class="bi bi-award me-1"></i>
                                                <%= medecin.getNomSpecialite() %>
                                            </span>
                                        <% } else { %>
                                            <span class="text-muted">-</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <% if (medecin.isActif()) { %>
                                            <span class="badge bg-success">Actif</span>
                                        <% } else { %>
                                            <span class="badge bg-secondary">Inactif</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <!-- Bouton Modifier -->
                                        <button type="button" class="btn btn-warning btn-sm me-1" 
                                                data-bs-toggle="modal" 
                                                data-bs-target="#modalModifierMedecin<%= medecin.getId() %>">
                                            <i class="bi bi-pencil-fill"></i>
                                        </button>
                                        
                                        <!-- Bouton Activer/Désactiver -->
                                        <% if (medecin.isActif()) { %>
                                            <button type="button" class="btn btn-secondary btn-sm" 
                                                    onclick="confirmerDesactivation(<%= medecin.getId() %>, '<%= medecin.getPrenom() %> <%= medecin.getNom() %>')">
                                                <i class="bi bi-x-circle-fill"></i>
                                            </button>
                                        <% } else { %>
                                            <button type="button" class="btn btn-success btn-sm" 
                                                    onclick="confirmerActivation(<%= medecin.getId() %>, '<%= medecin.getPrenom() %> <%= medecin.getNom() %>')">
                                                <i class="bi bi-check-circle-fill"></i>
                                            </button>
                                        <% } %>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    
                    <!-- ✅ MODALS EN DEHORS DU TABLEAU -->
                    <% for (Medecin medecin : medecins) { %>
                    <!-- Modal MODIFIER médecin -->
                    <div class="modal fade" id="modalModifierMedecin<%= medecin.getId() %>" tabindex="-1">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <div class="modal-header bg-warning">
                                    <h5 class="modal-title">
                                        <i class="bi bi-pencil me-2"></i>
                                        Modifier Médecin - <%= medecin.getCodeUser() %>
                                    </h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <form action="${pageContext.request.contextPath}/admin/modifier-utilisateur" method="post">
                                    <div class="modal-body">
                                        <input type="hidden" name="userId" value="<%= medecin.getId() %>">
                                        <input type="hidden" name="role" value="MEDECIN">
                                        <input type="hidden" name="redirectPage" value="medecins">
                                        
                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label">Nom <span class="text-danger">*</span></label>
                                                <input type="text" class="form-control" name="nom" 
                                                       value="<%= medecin.getNom() %>" required>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label">Prénom <span class="text-danger">*</span></label>
                                                <input type="text" class="form-control" name="prenom" 
                                                       value="<%= medecin.getPrenom() %>" required>
                                            </div>
                                        </div>
                                        
                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label">Email <span class="text-danger">*</span></label>
                                                <input type="email" class="form-control" name="email" 
                                                       value="<%= medecin.getEmail() %>" required>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label">Téléphone</label>
                                                <input type="tel" class="form-control" name="telephone" 
                                                       value="<%= medecin.getTelephone() != null ? medecin.getTelephone() : "" %>">
                                            </div>
                                        </div>
                                        
                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label">
                                                    <i class="bi bi-award me-1"></i>
                                                    Spécialité <span class="text-danger">*</span>
                                                </label>
                                                <select class="form-select" name="specialiteId" required>
                                                    <option value="">-- Sélectionner --</option>
                                                    <% 
                                                    if (specialites != null && specialites.size() > 0) {
                                                        for (Specialite s : specialites) { 
                                                    %>
                                                        <option value="<%= s.getId() %>" 
                                                                <%= medecin.getSpecialiteId() == s.getId() ? "selected" : "" %>>
                                                            <%= s.getNom() %>
                                                        </option>
                                                    <% 
                                                        }
                                                    } else {
                                                    %>
                                                        <option value="">Aucune spécialité disponible</option>
                                                    <%
                                                    }
                                                    %>
                                                </select>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label">N° d'Ordre</label>
                                                <input type="text" class="form-control" name="numeroOrdre" 
                                                       value="<%= medecin.getNumeroOrdre() != null ? medecin.getNumeroOrdre() : "" %>">
                                            </div>
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
                    
                <% } else { %>
                    <div class="text-center py-5">
                        <i class="bi bi-inbox fs-1 text-muted"></i>
                        <h5 class="mt-3">Aucun médecin</h5>
                        <p class="text-muted">Aucun médecin enregistré dans le système.</p>
                        <a href="${pageContext.request.contextPath}/admin/creer-utilisateur" 
                           class="btn btn-success">
                            <i class="bi bi-plus-circle me-1"></i>
                            Créer un Médecin
                        </a>
                    </div>
                <% } %>
            </div>
        </div>
        
    </div>
    
    <!-- Formulaire caché pour Activer -->
    <form id="formActiver" action="${pageContext.request.contextPath}/admin/activer-utilisateur" method="post" style="display: none;">
        <input type="hidden" name="userId" id="userIdToActivate">
        <input type="hidden" name="redirectPage" value="medecins">
    </form>
    
    <!-- Formulaire caché pour Désactiver -->
    <form id="formDesactiver" action="${pageContext.request.contextPath}/admin/desactiver-utilisateur" method="post" style="display: none;">
        <input type="hidden" name="userId" id="userIdToDeactivate">
        <input type="hidden" name="redirectPage" value="medecins">
    </form>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmerActivation(userId, nom) {
            if (confirm('✅ Voulez-vous activer le médecin "' + nom + '" ?')) {
                document.getElementById('userIdToActivate').value = userId;
                document.getElementById('formActiver').submit();
            }
        }
        
        function confirmerDesactivation(userId, nom) {
            if (confirm('⚠ Voulez-vous désactiver le médecin "' + nom + '" ?')) {
                document.getElementById('userIdToDeactivate').value = userId;
                document.getElementById('formDesactiver').submit();
            }
        }
    </script>
</body>
</html>
