<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.*" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Créer un Utilisateur</title>
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
                <span>Créer un Utilisateur</span>
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
        
        <!-- Sélection du type d'utilisateur -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-danger text-white">
                <h5 class="mb-0">
                    <i class="bi bi-person-plus-fill me-2"></i>
                    Choisir le Type d'Utilisateur
                </h5>
            </div>
            <div class="card-body">
                <div class="btn-group w-100" role="group">
                    <input type="radio" class="btn-check" name="typeUtilisateur" id="typeMedecin" value="medecin" checked>
                    <label class="btn btn-outline-success" for="typeMedecin">
                        <i class="bi bi-person-fill-gear me-2"></i>
                        Médecin
                    </label>
                    
                    <input type="radio" class="btn-check" name="typeUtilisateur" id="typePatient" value="patient">
                    <label class="btn btn-outline-primary" for="typePatient">
                        <i class="bi bi-person-fill me-2"></i>
                        Patient
                    </label>
                    
                    <input type="radio" class="btn-check" name="typeUtilisateur" id="typeSecretaire" value="secretaire">
                    <label class="btn btn-outline-info" for="typeSecretaire">
                        <i class="bi bi-person-badge-fill me-2"></i>
                        Secrétaire
                    </label>
                </div>
            </div>
        </div>
        
        <!-- FORMULAIRE MÉDECIN -->
        <div id="formMedecin" class="card border-0 shadow-sm">
            <div class="card-header bg-success text-white">
                <h5 class="mb-0">
                    <i class="bi bi-person-fill-gear me-2"></i>
                    Créer un Médecin
                </h5>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin/creer-medecin" method="post">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="medecinNom" class="form-label">
                                <i class="bi bi-person me-1"></i>
                                Nom <span class="text-danger">*</span>
                            </label>
                            <input type="text" class="form-control" id="medecinNom" name="nom" required>
                        </div>
                        
                        <div class="col-md-6 mb-3">
                            <label for="medecinPrenom" class="form-label">
                                <i class="bi bi-person me-1"></i>
                                Prénom <span class="text-danger">*</span>
                            </label>
                            <input type="text" class="form-control" id="medecinPrenom" name="prenom" required>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="medecinEmail" class="form-label">
                                <i class="bi bi-envelope me-1"></i>
                                Email <span class="text-danger">*</span>
                            </label>
                            <input type="email" class="form-control" id="medecinEmail" name="email" required>
                        </div>
                        
                        <div class="col-md-6 mb-3">
                            <label for="medecinPassword" class="form-label">
                                <i class="bi bi-key me-1"></i>
                                Mot de passe
                            </label>
                            <input type="password" class="form-control" id="medecinPassword" name="password" 
                                   placeholder="Laisser vide pour 'medecin123'">
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="medecinTelephone" class="form-label">
                                <i class="bi bi-telephone me-1"></i>
                                Téléphone
                            </label>
                            <input type="tel" class="form-control" id="medecinTelephone" name="telephone">
                        </div>
                        
                        <div class="col-md-6 mb-3">
                            <label for="medecinSpecialite" class="form-label">
                                <i class="bi bi-award me-1"></i>
                                Spécialité <span class="text-danger">*</span>
                            </label>
                            <select class="form-select" id="medecinSpecialite" name="specialiteId" required>
                                <option value="">-- Sélectionner --</option>
                                <% if (specialites != null) {
                                    for (Specialite s : specialites) { %>
                                        <option value="<%= s.getId() %>"><%= s.getNom() %></option>
                                <% }
                                } %>
                            </select>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="medecinNumeroOrdre" class="form-label">
                            <i class="bi bi-card-text me-1"></i>
                            Numéro d'Ordre
                        </label>
                        <input type="text" class="form-control" id="medecinNumeroOrdre" name="numeroOrdre">
                    </div>
                    
                    <div class="text-end">
                        <button type="submit" class="btn btn-success">
                            <i class="bi bi-save me-1"></i>
                            Créer le Médecin
                        </button>
                    </div>
                </form>
            </div>
        </div>
        
        <!-- FORMULAIRE PATIENT -->
        <div id="formPatient" class="card border-0 shadow-sm" style="display: none;">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">
                    <i class="bi bi-person-fill me-2"></i>
                    Créer un Patient
                </h5>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin/creer-patient" method="post">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="patientNom" class="form-label">
                                <i class="bi bi-person me-1"></i>
                                Nom <span class="text-danger">*</span>
                            </label>
                            <input type="text" class="form-control" id="patientNom" name="nom" required>
                        </div>
                        
                        <div class="col-md-6 mb-3">
                            <label for="patientPrenom" class="form-label">
                                <i class="bi bi-person me-1"></i>
                                Prénom <span class="text-danger">*</span>
                            </label>
                            <input type="text" class="form-control" id="patientPrenom" name="prenom" required>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="patientEmail" class="form-label">
                                <i class="bi bi-envelope me-1"></i>
                                Email <span class="text-danger">*</span>
                            </label>
                            <input type="email" class="form-control" id="patientEmail" name="email" required>
                        </div>
                        
                        <div class="col-md-6 mb-3">
                            <label for="patientPassword" class="form-label">
                                <i class="bi bi-key me-1"></i>
                                Mot de passe
                            </label>
                            <input type="password" class="form-control" id="patientPassword" name="password" 
                                   placeholder="Laisser vide pour 'patient123'">
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="patientTelephone" class="form-label">
                                <i class="bi bi-telephone me-1"></i>
                                Téléphone
                            </label>
                            <input type="tel" class="form-control" id="patientTelephone" name="telephone">
                        </div>
                        
                        <div class="col-md-6 mb-3">
                            <label for="patientDateNaissance" class="form-label">
                                <i class="bi bi-calendar me-1"></i>
                                Date de Naissance
                            </label>
                            <input type="date" class="form-control" id="patientDateNaissance" name="dateNaissance">
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="patientGroupeSanguin" class="form-label">
                                <i class="bi bi-droplet-fill me-1"></i>
                                Groupe Sanguin
                            </label>
                            <select class="form-select" id="patientGroupeSanguin" name="groupeSanguin">
                                <option value="">-- Sélectionner --</option>
                                <option value="A+">A+</option>
                                <option value="A-">A-</option>
                                <option value="B+">B+</option>
                                <option value="B-">B-</option>
                                <option value="AB+">AB+</option>
                                <option value="AB-">AB-</option>
                                <option value="O+">O+</option>
                                <option value="O-">O-</option>
                            </select>
                        </div>
                        
                        <div class="col-md-6 mb-3">
                            <label for="patientNumeroSecurite" class="form-label">
                                <i class="bi bi-card-text me-1"></i>
                                N° Sécurité Sociale
                            </label>
                            <input type="text" class="form-control" id="patientNumeroSecurite" name="numeroSecuriteSociale">
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="patientAdresse" class="form-label">
                            <i class="bi bi-geo-alt me-1"></i>
                            Adresse
                        </label>
                        <textarea class="form-control" id="patientAdresse" name="adresse" rows="2"></textarea>
                    </div>
                    
                    <div class="text-end">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-save me-1"></i>
                            Créer le Patient
                        </button>
                    </div>
                </form>
            </div>
        </div>
        
        <!-- FORMULAIRE SECRÉTAIRE -->
        <div id="formSecretaire" class="card border-0 shadow-sm" style="display: none;">
            <div class="card-header bg-info text-white">
                <h5 class="mb-0">
                    <i class="bi bi-person-badge-fill me-2"></i>
                    Créer une Secrétaire
                </h5>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin/creer-secretaire" method="post">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="secretaireNom" class="form-label">
                                <i class="bi bi-person me-1"></i>
                                Nom <span class="text-danger">*</span>
                            </label>
                            <input type="text" class="form-control" id="secretaireNom" name="nom" required>
                        </div>
                        
                        <div class="col-md-6 mb-3">
                            <label for="secretairePrenom" class="form-label">
                                <i class="bi bi-person me-1"></i>
                                Prénom <span class="text-danger">*</span>
                            </label>
                            <input type="text" class="form-control" id="secretairePrenom" name="prenom" required>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="secretaireEmail" class="form-label">
                                <i class="bi bi-envelope me-1"></i>
                                Email <span class="text-danger">*</span>
                            </label>
                            <input type="email" class="form-control" id="secretaireEmail" name="email" required>
                        </div>
                        
                        <div class="col-md-6 mb-3">
                            <label for="secretairePassword" class="form-label">
                                <i class="bi bi-key me-1"></i>
                                Mot de passe
                            </label>
                            <input type="password" class="form-control" id="secretairePassword" name="password" 
                                   placeholder="Laisser vide pour 'secretaire123'">
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="secretaireTelephone" class="form-label">
                                <i class="bi bi-telephone me-1"></i>
                                Téléphone
                            </label>
                            <input type="tel" class="form-control" id="secretaireTelephone" name="telephone">
                        </div>
                        
                        <div class="col-md-6 mb-3">
                            <label for="secretaireService" class="form-label">
                                <i class="bi bi-building me-1"></i>
                                Service
                            </label>
                            <input type="text" class="form-control" id="secretaireService" name="service" 
                                   placeholder="Ex: Accueil, Administration...">
                        </div>
                    </div>
                    
                    <div class="text-end">
                        <button type="submit" class="btn btn-info">
                            <i class="bi bi-save me-1"></i>
                            Créer la Secrétaire
                        </button>
                    </div>
                </form>
            </div>
        </div>
        
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Gestion de l'affichage des formulaires
        document.querySelectorAll('input[name="typeUtilisateur"]').forEach(radio => {
            radio.addEventListener('change', function() {
                // Cacher tous les formulaires
                document.getElementById('formMedecin').style.display = 'none';
                document.getElementById('formPatient').style.display = 'none';
                document.getElementById('formSecretaire').style.display = 'none';
                
                // Afficher le formulaire sélectionné
                if (this.value === 'medecin') {
                    document.getElementById('formMedecin').style.display = 'block';
                } else if (this.value === 'patient') {
                    document.getElementById('formPatient').style.display = 'block';
                } else if (this.value === 'secretaire') {
                    document.getElementById('formSecretaire').style.display = 'block';
                }
            });
        });
    </script>
</body>
</html>