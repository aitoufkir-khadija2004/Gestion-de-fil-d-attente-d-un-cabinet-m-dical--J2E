<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.*" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Spécialités</title>
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
        List<Specialite> specialites = (List<Specialite>) request.getAttribute("specialites");
    %>
    
    <!-- Navbar avec Logo -->
    <nav class="navbar navbar-dark" style="background-color: #dc3545;">
        <div class="container-fluid">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="navbar-brand d-flex align-items-center">
                <img src="<%= request.getContextPath() %>/images/logo1.png" 
                     alt="Logo" 
                     style="height: 40px; width: auto; margin-right: 10px;">
                <i class="bi bi-arrow-left-circle me-2"></i>
                <span>Gestion des Spécialités</span>
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
        
        <!-- Formulaire de création -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-warning text-dark">
                <h5 class="mb-0">
                    <i class="bi bi-plus-circle-fill me-2"></i>
                    Créer une Nouvelle Spécialité
                </h5>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin/creer-specialite" method="post">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="nom" class="form-label">
                                <i class="bi bi-bookmark-star me-1"></i>
                                Nom de la Spécialité <span class="text-danger">*</span>
                            </label>
                            <input type="text" class="form-control" id="nom" name="nom" 
                                   placeholder="Ex: Cardiologie, Pédiatrie..." required>
                        </div>
                        
                        <div class="col-md-6 mb-3">
                            <label for="description" class="form-label">
                                <i class="bi bi-card-text me-1"></i>
                                Description
                            </label>
                            <input type="text" class="form-control" id="description" name="description" 
                                   placeholder="Description courte (optionnel)">
                        </div>
                    </div>
                    
                    <div class="text-end">
                        <button type="submit" class="btn btn-warning">
                            <i class="bi bi-save me-1"></i>
                            Créer la Spécialité
                        </button>
                    </div>
                </form>
            </div>
        </div>
        
        <!-- Liste des spécialités -->
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-warning text-dark">
                <h5 class="mb-0">
                    <i class="bi bi-bookmark-star-fill me-2"></i>
                    Liste des Spécialités Médicales
                    <span class="badge bg-dark ms-2"><%= specialites != null ? specialites.size() : 0 %></span>
                </h5>
            </div>
            <div class="card-body">
                <% if (specialites != null && specialites.size() > 0) { %>
                    <div class="row">
                        <% for (Specialite specialite : specialites) { %>
                        <div class="col-md-6 col-lg-4 mb-3">
                            <div class="card h-100 border-warning">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <h5 class="card-title text-warning mb-0">
                                            <i class="bi bi-bookmark-star-fill me-2"></i>
                                            <%= specialite.getNom() %>
                                        </h5>
                                    </div>
                                    
                                    <p class="text-muted mb-2">
                                        <small>
                                            <i class="bi bi-hash me-1"></i>
                                            Code: <strong><%= specialite.getCodeSpecialite() %></strong>
                                        </small>
                                    </p>
                                    
                                    <% if (specialite.getDescription() != null && !specialite.getDescription().isEmpty()) { %>
                                        <p class="card-text text-muted small mb-3">
                                            <i class="bi bi-info-circle me-1"></i>
                                            <%= specialite.getDescription() %>
                                        </p>
                                    <% } else { %>
                                        <p class="card-text text-muted small fst-italic mb-3">
                                            <i class="bi bi-info-circle me-1"></i>
                                            Aucune description
                                        </p>
                                    <% } %>
                                    
                                    <!-- Boutons d'action -->
                                    <div class="d-flex gap-2">
                                        <button type="button" class="btn btn-warning btn-sm flex-fill" 
                                                data-bs-toggle="modal" 
                                                data-bs-target="#modalModifier<%= specialite.getId() %>">
                                            <i class="bi bi-pencil-fill me-1"></i>
                                            Modifier
                                        </button>
                                        <button type="button" class="btn btn-danger btn-sm" 
                                                onclick="confirmerSuppression(<%= specialite.getId() %>, '<%= specialite.getNom() %>')">
                                            <i class="bi bi-trash-fill"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Modal MODIFIER spécialité -->
                        <div class="modal fade" id="modalModifier<%= specialite.getId() %>" tabindex="-1">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header bg-warning">
                                        <h5 class="modal-title">
                                            <i class="bi bi-pencil me-2"></i>
                                            Modifier Spécialité
                                        </h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/admin/modifier-specialite" method="post">
                                        <div class="modal-body">
                                            <input type="hidden" name="specialiteId" value="<%= specialite.getId() %>">
                                            
                                            <div class="mb-3">
                                                <label class="form-label">
                                                    <i class="bi bi-hash me-1"></i>
                                                    Code Spécialité
                                                </label>
                                                <input type="text" class="form-control" value="<%= specialite.getCodeSpecialite() %>" disabled>
                                                <small class="text-muted">Le code ne peut pas être modifié</small>
                                            </div>
                                            
                                            <div class="mb-3">
                                                <label class="form-label">
                                                    <i class="bi bi-bookmark-star me-1"></i>
                                                    Nom <span class="text-danger">*</span>
                                                </label>
                                                <input type="text" class="form-control" name="nom" 
                                                       value="<%= specialite.getNom() %>" required>
                                            </div>
                                            
                                            <div class="mb-3">
                                                <label class="form-label">
                                                    <i class="bi bi-card-text me-1"></i>
                                                    Description
                                                </label>
                                                <textarea class="form-control" name="description" rows="3"><%= specialite.getDescription() != null ? specialite.getDescription() : "" %></textarea>
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
                    </div>
                <% } else { %>
                    <div class="text-center py-5">
                        <i class="bi bi-inbox fs-1 text-muted"></i>
                        <h5 class="mt-3">Aucune spécialité</h5>
                        <p class="text-muted">Aucune spécialité médicale enregistrée dans le système.</p>
                        <p class="text-muted">Utilisez le formulaire ci-dessus pour créer la première spécialité.</p>
                    </div>
                <% } %>
            </div>
        </div>
        
    </div>
    
    <!-- Formulaire caché pour suppression -->
    <form id="formSuppression" action="${pageContext.request.contextPath}/admin/supprimer-specialite" method="post" style="display: none;">
        <input type="hidden" name="specialiteId" id="specialiteIdToDelete">
    </form>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmerSuppression(specialiteId, nom) {
            if (confirm(' Êtes-vous sûr de vouloir supprimer la spécialité "' + nom + '" ?\n\nCette action est irréversible !')) {
                document.getElementById('specialiteIdToDelete').value = specialiteId;
                document.getElementById('formSuppression').submit();
            }
        }
    </script>
</body>
</html>