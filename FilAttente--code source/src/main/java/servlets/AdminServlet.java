package servlets;

import dao.DAOFactory;
import dao.*;
import beans.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UserDAO userDAO;
    private TicketDAO ticketDAO;
    private CreneauDAO creneauDAO;
    private ConsultationDAO consultationDAO;
    private SpecialiteDAO specialiteDAO;
    
    public AdminServlet() {
        super();
    }
    
    @Override
    public void init() throws ServletException {
        DAOFactory factory = DAOFactory.getInstance();
        userDAO = factory.getUserDAO();
        ticketDAO = factory.getTicketDAO();
        creneauDAO = factory.getCreneauDAO();
        consultationDAO = factory.getConsultationDAO();
        specialiteDAO = factory.getSpecialiteDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            pathInfo = "/dashboard";
        }
        
        switch (pathInfo) {
            case "/dashboard":
                afficherDashboard(request, response);
                break;
            case "/creer-utilisateur":  // ✅ AJOUTÉ
                afficherCreerUtilisateur(request, response);
                break;
            case "/patients":
                afficherPatients(request, response);
                break;
            case "/medecins":
                afficherMedecins(request, response);
                break;
            case "/secretaires":  // ✅ AJOUTÉ
                afficherSecretaires(request, response);
                break;
            case "/specialites":
                afficherSpecialites(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        if ("/creer-medecin".equals(pathInfo)) {
            creerMedecin(request, response);
        } else if ("/creer-secretaire".equals(pathInfo)) {
            creerSecretaire(request, response);
        } else if ("/creer-patient".equals(pathInfo)) {  
            creerPatient(request, response);
        } else if ("/creer-specialite".equals(pathInfo)) {
            creerSpecialite(request, response);
        } else if ("/supprimer-utilisateur".equals(pathInfo)) {  
            supprimerUtilisateur(request, response);
        } else if ("/modifier-utilisateur".equals(pathInfo)) {  
            modifierUtilisateur(request, response);
        } else if ("/activer-utilisateur".equals(pathInfo)) {  
            activerUtilisateur(request, response);
        } else if ("/desactiver-utilisateur".equals(pathInfo)) {  
            desactiverUtilisateur(request, response);
        } else if ("/modifier-specialite".equals(pathInfo)) {  
            modifierSpecialite(request, response);
        } else if ("/supprimer-specialite".equals(pathInfo)) {  
            supprimerSpecialite(request, response);
        }else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    // ==================== GET ====================
    
    private void afficherDashboard(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Patient> patients = userDAO.getAllPatients();
        List<Medecin> medecins = userDAO.getAllMedecins();
        List<Secretaire> secretaires = userDAO.getAllSecretaires();  
        List<Ticket> tickets = ticketDAO.getAllTickets();  
        List<Consultation> consultations = consultationDAO.getAllConsultations();  
        List<Creneau> creneaux = creneauDAO.getAllCreneaux(); 
        
        request.setAttribute("nbPatients", patients.size());
        request.setAttribute("nbMedecins", medecins.size());
        request.setAttribute("nbSecretaires", secretaires.size());  
        request.setAttribute("nbTickets", tickets.size());  
        request.setAttribute("nbConsultations", consultations.size());  
        request.setAttribute("nbCreneaux", creneaux.size());
        
        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }
    
    private void afficherCreerUtilisateur(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Specialite> specialites = specialiteDAO.getAllSpecialites();
        request.setAttribute("specialites", specialites);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/creer-utilisateur.jsp").forward(request, response);
    }
    
    private void afficherPatients(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Patient> patients = userDAO.getAllPatients();
        request.setAttribute("patients", patients);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/patients.jsp").forward(request, response);
    }
    
    private void afficherMedecins(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Medecin> medecins = userDAO.getAllMedecins();
        List<Specialite> specialites = specialiteDAO.getAllSpecialites();
        request.setAttribute("medecins", medecins);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/medecins.jsp").forward(request, response);
    }
    
    private void afficherSecretaires(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Secretaire> secretaires = userDAO.getAllSecretaires();
        request.setAttribute("secretaires", secretaires);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/secretaires.jsp").forward(request, response);
    }
    
    private void afficherSpecialites(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Specialite> specialites = specialiteDAO.getAllSpecialites();
        request.setAttribute("specialites", specialites);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/specialites.jsp").forward(request, response);
    }
    
    // ==================== POST ====================
    
    private void creerMedecin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        try {
            String nom = request.getParameter("nom");
            String prenom = request.getParameter("prenom");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String telephone = request.getParameter("telephone");
            int specialiteId = Integer.parseInt(request.getParameter("specialiteId"));
            String numeroOrdre = request.getParameter("numeroOrdre");
            
            if (nom == null || nom.trim().isEmpty() || 
                prenom == null || prenom.trim().isEmpty() ||
                email == null || email.trim().isEmpty()) {
                session.setAttribute("error", "Les champs nom, prénom et email sont obligatoires");
                response.sendRedirect(request.getContextPath() + "/admin/creer-utilisateur");
                return;
            }
            
            Medecin medecin = new Medecin();
            medecin.setNom(nom.trim());
            medecin.setPrenom(prenom.trim());
            medecin.setEmail(email.trim());
            medecin.setPassword(password != null && !password.trim().isEmpty() ? password : "medecin123");
            medecin.setTelephone(telephone);
            medecin.setSpecialiteId(specialiteId);
            medecin.setNumeroOrdre(numeroOrdre);
            
            if (userDAO.creerMedecin(medecin)) {
                session.setAttribute("success", " Médecin créé avec succès : " + medecin.getCodeUser());
                response.sendRedirect(request.getContextPath() + "/admin/medecins");
            } else {
                session.setAttribute("error", " Erreur lors de la création du médecin");
                response.sendRedirect(request.getContextPath() + "/admin/creer-utilisateur");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", " Erreur : " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/creer-utilisateur");
        }
    }
    
    private void creerSecretaire(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        try {
            String nom = request.getParameter("nom");
            String prenom = request.getParameter("prenom");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String telephone = request.getParameter("telephone");
            String service = request.getParameter("service");
            
            if (nom == null || nom.trim().isEmpty() || 
                prenom == null || prenom.trim().isEmpty() ||
                email == null || email.trim().isEmpty()) {
                session.setAttribute("error", "Les champs nom, prénom et email sont obligatoires");
                response.sendRedirect(request.getContextPath() + "/admin/creer-utilisateur");
                return;
            }
            
            Secretaire secretaire = new Secretaire();
            secretaire.setNom(nom.trim());
            secretaire.setPrenom(prenom.trim());
            secretaire.setEmail(email.trim());
            secretaire.setPassword(password != null && !password.trim().isEmpty() ? password : "secretaire123");
            secretaire.setTelephone(telephone);
            secretaire.setService(service);
            
            if (userDAO.creerSecretaire(secretaire)) {
                session.setAttribute("success", " Secrétaire créée avec succès : " + secretaire.getCodeUser());
                response.sendRedirect(request.getContextPath() + "/admin/secretaires");
            } else {
                session.setAttribute("error", " Erreur lors de la création de la secrétaire");
                response.sendRedirect(request.getContextPath() + "/admin/creer-utilisateur");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", " Erreur : " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/creer-utilisateur");
        }
    }
    
    private void creerPatient(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        try {
            String nom = request.getParameter("nom");
            String prenom = request.getParameter("prenom");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String telephone = request.getParameter("telephone");
            String dateNaissance = request.getParameter("dateNaissance");
            String groupeSanguin = request.getParameter("groupeSanguin");
            String numeroSecuriteSociale = request.getParameter("numeroSecuriteSociale");
            String adresse = request.getParameter("adresse");
            
            if (nom == null || nom.trim().isEmpty() || 
                prenom == null || prenom.trim().isEmpty() ||
                email == null || email.trim().isEmpty()) {
                session.setAttribute("error", "Les champs nom, prénom et email sont obligatoires");
                response.sendRedirect(request.getContextPath() + "/admin/creer-utilisateur");
                return;
            }
            
            Patient patient = new Patient();
            patient.setNom(nom.trim());
            patient.setPrenom(prenom.trim());
            patient.setEmail(email.trim());
            patient.setPassword(password != null && !password.trim().isEmpty() ? password : "patient123");
            patient.setTelephone(telephone);
            
            if (dateNaissance != null && !dateNaissance.isEmpty()) {
                patient.setDateNaissance(java.sql.Date.valueOf(dateNaissance));
            }
            
            patient.setGroupeSanguin(groupeSanguin);
            patient.setNumeroSecuriteSociale(numeroSecuriteSociale);
            patient.setAdresse(adresse);
            
            if (userDAO.creerPatient(patient)) {
                session.setAttribute("success", " Patient créé avec succès : " + patient.getCodeUser());
                response.sendRedirect(request.getContextPath() + "/admin/patients");
            } else {
                session.setAttribute("error", " Erreur lors de la création du patient");
                response.sendRedirect(request.getContextPath() + "/admin/creer-utilisateur");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", " Erreur : " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/creer-utilisateur");
        }
    }
    
    private void creerSpecialite(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        try {
            String nom = request.getParameter("nom");
            String description = request.getParameter("description");
            
            if (nom == null || nom.trim().isEmpty()) {
                session.setAttribute("error", "Le nom de la spécialité est obligatoire");
                response.sendRedirect(request.getContextPath() + "/admin/specialites");
                return;
            }
            
            Specialite specialite = new Specialite();
            specialite.setNom(nom.trim());
            specialite.setDescription(description);
            
            if (specialiteDAO.creerSpecialite(specialite)) {
                session.setAttribute("success", " Spécialité créée avec succès : " + specialite.getCodeSpecialite());
                response.sendRedirect(request.getContextPath() + "/admin/specialites");
            } else {
                session.setAttribute("error", " Erreur lors de la création de la spécialité");
                response.sendRedirect(request.getContextPath() + "/admin/specialites");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", " Erreur : " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/specialites");
        }
    }
    
    private void supprimerUtilisateur(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String redirectPage = request.getParameter("redirectPage");
            
            if (userDAO.deleteUser(userId)) {
                session.setAttribute("success", " Utilisateur supprimé avec succès");
            } else {
                session.setAttribute("error", " Erreur lors de la suppression de l'utilisateur");
            }
            
            // Rediriger vers la bonne page
            if (redirectPage != null && !redirectPage.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/" + redirectPage);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Erreur : " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }
    
    


private void modifierUtilisateur(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    
    HttpSession session = request.getSession();
    
    try {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String role = request.getParameter("role");
        String redirectPage = request.getParameter("redirectPage");
        
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String telephone = request.getParameter("telephone");
        
        if ("MEDECIN".equals(role)) {
            Medecin medecin = userDAO.getMedecinById(userId);
            medecin.setNom(nom);
            medecin.setPrenom(prenom);
            medecin.setEmail(email);
            medecin.setTelephone(telephone);
            
            String numeroOrdre = request.getParameter("numeroOrdre");
            int specialiteId = Integer.parseInt(request.getParameter("specialiteId"));
            medecin.setNumeroOrdre(numeroOrdre);
            medecin.setSpecialiteId(specialiteId);
            
            if (userDAO.updateMedecin(medecin)) {
                session.setAttribute("success", "Médecin modifié avec succès");
            } else {
                session.setAttribute("error", "Erreur lors de la modification");
            }
            
        } else if ("PATIENT".equals(role)) {
            Patient patient = userDAO.getPatientById(userId);
            patient.setNom(nom);
            patient.setPrenom(prenom);
            patient.setEmail(email);
            patient.setTelephone(telephone);
            
            String dateNaissance = request.getParameter("dateNaissance");
            String groupeSanguin = request.getParameter("groupeSanguin");
            String numeroSecuriteSociale = request.getParameter("numeroSecuriteSociale");
            String adresse = request.getParameter("adresse");
            
            if (dateNaissance != null && !dateNaissance.isEmpty()) {
                patient.setDateNaissance(java.sql.Date.valueOf(dateNaissance));
            }
            patient.setGroupeSanguin(groupeSanguin);
            patient.setNumeroSecuriteSociale(numeroSecuriteSociale);
            patient.setAdresse(adresse);
            
            if (userDAO.updatePatient(patient)) {
                session.setAttribute("success", "Patient modifié avec succès");
            } else {
                session.setAttribute("error", "Erreur lors de la modification");
            }
            
        } else if ("SECRETAIRE".equals(role)) {
            Secretaire secretaire = userDAO.getSecretaireById(userId);
            secretaire.setNom(nom);
            secretaire.setPrenom(prenom);
            secretaire.setEmail(email);
            secretaire.setTelephone(telephone);
            
            String service = request.getParameter("service");
            secretaire.setService(service);
            
            if (userDAO.updateSecretaire(secretaire)) {
                session.setAttribute("success", "Secrétaire modifiée avec succès");
            } else {
                session.setAttribute("error", "Erreur lors de la modification");
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/" + redirectPage);
        
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error", "Erreur : " + e.getMessage());
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }
}

private void activerUtilisateur(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    
    HttpSession session = request.getSession();
    
    try {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String redirectPage = request.getParameter("redirectPage");
        
        if (userDAO.activerUtilisateur(userId)) {
            session.setAttribute("success", "Utilisateur activé avec succès");
        } else {
            session.setAttribute("error", " Erreur lors de l'activation");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/" + redirectPage);
        
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error", "Erreur : " + e.getMessage());
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }
}

private void desactiverUtilisateur(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    
    HttpSession session = request.getSession();
    
    try {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String redirectPage = request.getParameter("redirectPage");
        
        if (userDAO.desactiverUtilisateur(userId)) {
            session.setAttribute("success", "Utilisateur désactivé avec succès");
        } else {
            session.setAttribute("error", "Erreur lors de la désactivation");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/" + redirectPage);
        
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error", "Erreur : " + e.getMessage());
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }
}

private void modifierSpecialite(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    
    HttpSession session = request.getSession();
    
    try {
        int specialiteId = Integer.parseInt(request.getParameter("specialiteId"));
        String nom = request.getParameter("nom");
        String description = request.getParameter("description");
        
        Specialite specialite = specialiteDAO.getSpecialiteById(specialiteId);
        
        if (specialite != null) {
            specialite.setNom(nom);
            specialite.setDescription(description);
            
            if (specialiteDAO.updateSpecialite(specialite)) {
                session.setAttribute("success", "pécialité modifiée avec succès");
            } else {
                session.setAttribute("error", "Erreur lors de la modification");
            }
        } else {
            session.setAttribute("error", " Spécialité introuvable");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/specialites");
        
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error", " Erreur : " + e.getMessage());
        response.sendRedirect(request.getContextPath() + "/admin/specialites");
    }
}

private void supprimerSpecialite(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    
    HttpSession session = request.getSession();
    
    try {
        int specialiteId = Integer.parseInt(request.getParameter("specialiteId"));
        
        if (specialiteDAO.isSpecialiteUsed(specialiteId)) {
            session.setAttribute("error", " Impossible de supprimer : des médecins utilisent cette spécialité");
        } else {
            if (specialiteDAO.deleteSpecialite(specialiteId)) {
                session.setAttribute("success", " Spécialité supprimée avec succès");
            } else {
                session.setAttribute("error", " Erreur lors de la suppression");
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/specialites");
        
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error", "Erreur : " + e.getMessage());
        response.sendRedirect(request.getContextPath() + "/admin/specialites");
    }
}
}