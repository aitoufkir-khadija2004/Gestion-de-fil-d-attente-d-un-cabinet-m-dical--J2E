package servlets;

import dao.DAOFactory;
import dao.*;
import beans.*;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/medecin/*")
public class MedecinServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    private TicketDAO ticketDAO;
    private CreneauDAO creneauDAO;
    private ConsultationDAO consultationDAO;
    
    @Override
    public void init() throws ServletException {
        DAOFactory factory = DAOFactory.getInstance();
        userDAO = factory.getUserDAO();
        ticketDAO = factory.getTicketDAO();
        creneauDAO = factory.getCreneauDAO();
        consultationDAO = factory.getConsultationDAO();
    }
    
    public MedecinServlet() {
        super();
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
        if (!"MEDECIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            pathInfo = "/dashboard";
        }
        
        switch (pathInfo) {
            case "/dashboard":
                afficherDashboard(request, response, user.getId());
                break;
            case "/file-attente":
                afficherFileAttente(request, response, user.getId());
                break;
            case "/consultations":
                afficherConsultations(request, response);
                break;
            case "/consultation":
                afficherConsultation(request, response);
                break;
            case "/patients":  // ← AJOUTÉ
                afficherPatients(request, response);
                break;
            case "/creneaux":  // ← GARDÉ
                afficherCreneaux(request, response, user.getId());
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        if ("/appeler-patient".equals(pathInfo)) {
            appellerPatient(request, response);
        } else if ("/terminer-consultation".equals(pathInfo)) {
            terminerConsultation(request, response);
        } else if ("/creer-creneau".equals(pathInfo)) {
            creerCreneau(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
//get    
    private void afficherDashboard(HttpServletRequest request, HttpServletResponse response, int medecinId) 
            throws ServletException, IOException {
        
        List<Ticket> fileAttente = ticketDAO.getTicketsByMedecinStatut(medecinId, "present");
        List<Consultation> consultationsAujourdhui = consultationDAO.getConsultationsByMedecin(medecinId);
        
        // Compter les consultations terminées
        int nbTerminees = 0;
        if (consultationsAujourdhui != null) {
            for (Consultation c : consultationsAujourdhui) {
                if ("terminee".equals(c.getStatut())) {
                    nbTerminees++;
                }
            }
        }
        
        request.setAttribute("nbPatientsEnAttente", fileAttente != null ? fileAttente.size() : 0);
        request.setAttribute("nbConsultationsAujourdhui", consultationsAujourdhui != null ? consultationsAujourdhui.size() : 0);
        request.setAttribute("nbConsultationsTerminees", nbTerminees);
        request.setAttribute("fileAttente", fileAttente);
        
        request.getRequestDispatcher("/WEB-INF/views/medecin/dashboard.jsp").forward(request, response);
    }
    
    private void afficherFileAttente(HttpServletRequest request, HttpServletResponse response, int medecinId) 
            throws ServletException, IOException {
        
        // Récupérer les tickets présents
        List<Ticket> fileAttente = ticketDAO.getTicketsByMedecinStatut(medecinId, "present");
        
        // Créer une map des patients
        Map<Integer, Patient> patientsMap = new HashMap<>();
        List<Patient> allPatients = userDAO.getAllPatients();
        for (Patient p : allPatients) {
            patientsMap.put(p.getId(), p);
        }
        
        request.setAttribute("fileAttente", fileAttente);
        request.setAttribute("patientsMap", patientsMap);
        
        request.getRequestDispatcher("/WEB-INF/views/medecin/file-attente.jsp").forward(request, response);
    }
    
    private void afficherConsultations(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            User user = (User) request.getSession().getAttribute("user");
            
            // Récupérer toutes les consultations du médecin
            List<Consultation> consultations = consultationDAO.getConsultationsByMedecinId(user.getId());
            
            // Créer une map des patients pour affichage
            Map<Integer, Patient> patientsMap = new HashMap<>();
            List<Patient> patients = userDAO.getAllPatients();
            
            for (Patient patient : patients) {
                patientsMap.put(patient.getId(), patient);
            }
            
            // Passer les données à la JSP
            request.setAttribute("consultations", consultations);
            request.setAttribute("patientsMap", patientsMap);
            
            // Afficher la page
            request.getRequestDispatcher("/WEB-INF/views/medecin/consultations.jsp")
                   .forward(request, response);
                   
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Erreur lors du chargement des consultations: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/medecin/dashboard");
        }
    }
    
    private void afficherConsultation(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String consultationIdStr = request.getParameter("id");
            
            if (consultationIdStr == null || consultationIdStr.isEmpty()) {
                request.getSession().setAttribute("error", "ID de consultation manquant");
                response.sendRedirect(request.getContextPath() + "/medecin/consultations");
                return;
            }
            
            int consultationId = Integer.parseInt(consultationIdStr);
            
            // Récupérer la consultation
            Consultation consultation = consultationDAO.getConsultationById(consultationId);
            
            if (consultation == null) {
                request.getSession().setAttribute("error", "Consultation introuvable");
                response.sendRedirect(request.getContextPath() + "/medecin/consultations");
                return;
            }
            
            // Récupérer le patient
            Patient patient = userDAO.getPatientById(consultation.getPatientId());
            
            if (patient == null) {
                request.getSession().setAttribute("error", "Patient introuvable");
                response.sendRedirect(request.getContextPath() + "/medecin/consultations");
                return;
            }
            
            // Récupérer le ticket
            Ticket ticket = ticketDAO.getTicketById(consultation.getTicketId());
            
            // Passer les données à la JSP
            request.setAttribute("consultation", consultation);
            request.setAttribute("patient", patient);
            request.setAttribute("ticket", ticket);
            
            // Afficher la page
            request.getRequestDispatcher("/WEB-INF/views/medecin/consultation.jsp")
                   .forward(request, response);
                   
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Format d'ID invalide");
            response.sendRedirect(request.getContextPath() + "/medecin/consultations");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Erreur lors du chargement de la consultation: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/medecin/consultations");
        }
    }
    
    private void afficherPatients(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            User user = (User) request.getSession().getAttribute("user");
            
            // Récupérer tous les patients consultés par ce médecin
            List<Patient> patients = userDAO.getPatientsConsultesByMedecin(user.getId());
            
            // Créer une map pour compter le nombre de consultations par patient
            Map<Integer, Integer> consultationsCountMap = new HashMap<>();
            
            for (Patient patient : patients) {
                int count = consultationDAO.countConsultationsByPatientAndMedecin(patient.getId(), user.getId());
                consultationsCountMap.put(patient.getId(), count);
            }
            
            // Passer les données à la JSP
            request.setAttribute("patients", patients);
            request.setAttribute("consultationsCountMap", consultationsCountMap);
            
            // Afficher la page
            request.getRequestDispatcher("/WEB-INF/views/medecin/patients.jsp")
                   .forward(request, response);
                   
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Erreur lors du chargement des patients: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/medecin/dashboard");
        }
    }
    
    private void afficherCreneaux(HttpServletRequest request, HttpServletResponse response, int medecinId) 
            throws ServletException, IOException {
        
        List<Creneau> creneaux = creneauDAO.getCreneauxByMedecin(medecinId);
        request.setAttribute("creneaux", creneaux);
        
        request.getRequestDispatcher("/WEB-INF/views/medecin/creneaux.jsp").forward(request, response);
    }
    
    // POST 
    
    private void appellerPatient(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        int ticketId = Integer.parseInt(request.getParameter("ticketId"));
        
        Ticket ticket = ticketDAO.getTicketById(ticketId);
        
        if (ticketDAO.updateStatut(ticketId, "en_consultation")) {
            
            Consultation consultation = new Consultation();
            consultation.setTicketId(ticketId);
            consultation.setMedecinId(user.getId());
            consultation.setPatientId(ticket.getPatientId());
            consultation.setStatut("en_cours");
            
            if (consultationDAO.creerConsultation(consultation)) {
                session.setAttribute("success", "Patient en consultation");
                response.sendRedirect(request.getContextPath() + "/medecin/consultation?id=" + consultation.getId());
            } else {
                session.setAttribute("error", "Erreur lors de la creation de la consultation");
                response.sendRedirect(request.getContextPath() + "/medecin/file-attente");
            }
        } else {
            session.setAttribute("error", "Erreur lors de l'appel du patient");
            response.sendRedirect(request.getContextPath() + "/medecin/file-attente");
        }
    }
    
    private void terminerConsultation(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        try {
            String consultationIdStr = request.getParameter("consultationId");
            String ticketIdStr = request.getParameter("ticketId");
            String action = request.getParameter("action");
            
            if (consultationIdStr == null || consultationIdStr.isEmpty()) {
                session.setAttribute("error", "ID de consultation manquant");
                response.sendRedirect(request.getContextPath() + "/medecin/consultations");
                return;
            }
            
            int consultationId = Integer.parseInt(consultationIdStr);
            
            String symptomes = request.getParameter("symptomes");
            String diagnostic = request.getParameter("diagnostic");
            String prescription = request.getParameter("prescription");
            String notesMedicales = request.getParameter("notesMedicales");
            String dureeStr = request.getParameter("dureeConsultation");
            
            int dureeConsultation = 15;
            if (dureeStr != null && !dureeStr.isEmpty()) {
                dureeConsultation = Integer.parseInt(dureeStr);
            }
            
            Consultation consultation = consultationDAO.getConsultationById(consultationId);
            
            if (consultation == null) {
                session.setAttribute("error", "Consultation introuvable");
                response.sendRedirect(request.getContextPath() + "/medecin/consultations");
                return;
            }
            
            consultation.setSymptomes(symptomes);
            consultation.setDiagnostic(diagnostic);
            consultation.setPrescription(prescription);
            consultation.setNotesMedicales(notesMedicales);
            consultation.setDureeConsultation(dureeConsultation);
            
            if ("terminer".equals(action)) {
                consultation.setStatut("terminee");
                
                if (ticketIdStr != null && !ticketIdStr.isEmpty()) {
                    int ticketId = Integer.parseInt(ticketIdStr);
                    ticketDAO.updateStatut(ticketId, "termine");
                }
                
                boolean success = consultationDAO.updateConsultation(consultation);
                
                if (success) {
                    session.setAttribute("success", "Consultation terminée avec succès !");
                    response.sendRedirect(request.getContextPath() + "/medecin/consultations");
                } else {
                    session.setAttribute("error", "Erreur lors de la mise à jour de la consultation");
                    response.sendRedirect(request.getContextPath() + "/medecin/consultation?id=" + consultationId);
                }
                
            } else if ("enregistrer".equals(action)) {
                consultation.setStatut("en_cours");
                
                boolean success = consultationDAO.updateConsultation(consultation);
                
                if (success) {
                    session.setAttribute("success", "Consultation enregistrée. Vous pouvez la continuer plus tard.");
                    response.sendRedirect(request.getContextPath() + "/medecin/consultations");
                } else {
                    session.setAttribute("error", "Erreur lors de l'enregistrement");
                    response.sendRedirect(request.getContextPath() + "/medecin/consultation?id=" + consultationId);
                }
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Format d'ID invalide");
            response.sendRedirect(request.getContextPath() + "/medecin/consultations");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Erreur lors de la mise à jour : " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/medecin/consultations");
        }
    }
    
    private void creerCreneau(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        String date = request.getParameter("date");
        String heureDebut = request.getParameter("heureDebut");
        String heureFin = request.getParameter("heureFin");
        int capacite = Integer.parseInt(request.getParameter("capacite"));
        
        Creneau creneau = new Creneau();
        creneau.setMedecinId(user.getId());
        creneau.setDate(Date.valueOf(date));
        creneau.setHeureDebut(Time.valueOf(heureDebut + ":00"));
        creneau.setHeureFin(Time.valueOf(heureFin + ":00"));
        creneau.setCapacite(capacite);
        creneau.setDisponible(true);
        
        if (creneauDAO.creerCreneau(creneau)) {
            session.setAttribute("success", "Creneau cree avec succes");
        } else {
            session.setAttribute("error", "Erreur lors de la creation du creneau");
        }
        
        response.sendRedirect(request.getContextPath() + "/medecin/creneaux");
    }
}