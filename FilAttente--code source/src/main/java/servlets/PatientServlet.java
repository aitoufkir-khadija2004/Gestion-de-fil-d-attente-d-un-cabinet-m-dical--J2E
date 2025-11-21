package servlets;

import dao.DAOFactory;
import dao.*;
import beans.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/patient/*")
public class PatientServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UserDAO userDAO;
    private TicketDAO ticketDAO;
    private CreneauDAO creneauDAO;
    private ConsultationDAO consultationDAO;
    private SpecialiteDAO specialiteDAO;
    
    public PatientServlet() {
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
        if (!"PATIENT".equals(user.getRole())) {
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
            case "/tickets":
                afficherTickets(request, response, user.getId());
                break;
            case "/creneaux-disponibles":
                afficherCreneauxDisponibles(request, response);
                break;
            case "/consultations":
                afficherConsultations(request, response, user.getId());
                break;
            case "/profil":
                afficherProfil(request, response, user.getId());
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        if ("/prendre-rdv".equals(pathInfo)) {
            prendreRendezVous(request, response);
        } else if ("/annuler-ticket".equals(pathInfo)) {
            annulerTicket(request, response);
        } else if ("/update-profil".equals(pathInfo)) {
            updateProfil(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    // get
    
    private void afficherDashboard(HttpServletRequest request, HttpServletResponse response, int patientId) 
            throws ServletException, IOException {
        
        // Récupérer les tickets du patient
        List<Ticket> allTickets = ticketDAO.getTicketsByPatient(patientId);
        
        // Filtrer les tickets actifs (non terminés, non annulés)
        List<Ticket> ticketsActifs = new java.util.ArrayList<>();
        for (Ticket t : allTickets) {
            if (!"termine".equals(t.getStatut()) && !"annule".equals(t.getStatut())) {
                ticketsActifs.add(t);
            }
        }
        
        // Récupérer les consultations
        List<Consultation> consultations = consultationDAO.getConsultationsByPatient(patientId);
        
        request.setAttribute("ticketsActifs", ticketsActifs);
        request.setAttribute("nbTickets", allTickets.size());
        request.setAttribute("nbConsultations", consultations.size());
        
        request.getRequestDispatcher("/WEB-INF/views/patient/dashboard.jsp").forward(request, response);
    }
    
    private void afficherTickets(HttpServletRequest request, HttpServletResponse response, int patientId) 
            throws ServletException, IOException {
        
        // Récupérer tous les tickets
        List<Ticket> tickets = ticketDAO.getTicketsByPatient(patientId);
        
        // Créer les maps pour médecins et créneaux
        Map<Integer, Medecin> medecinsMap = new HashMap<>();
        Map<Integer, Creneau> creneauxMap = new HashMap<>();
        
        List<Medecin> allMedecins = userDAO.getAllMedecins();
        for (Medecin m : allMedecins) {
            medecinsMap.put(m.getId(), m);
        }
        
        List<Creneau> allCreneaux = creneauDAO.getAllCreneaux();
        for (Creneau c : allCreneaux) {
            creneauxMap.put(c.getId(), c);
        }
        
        request.setAttribute("tickets", tickets);
        request.setAttribute("medecinsMap", medecinsMap);
        request.setAttribute("creneauxMap", creneauxMap);
        
        request.getRequestDispatcher("/WEB-INF/views/patient/mes-tickets.jsp").forward(request, response);
    }
    
    private void afficherCreneauxDisponibles(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Récupérer les créneaux disponibles
        List<Creneau> creneaux = creneauDAO.getCreneauxDisponibles();
        
        // Créer une map des médecins
        Map<Integer, Medecin> medecinsMap = new HashMap<>();
        List<Medecin> allMedecins = userDAO.getAllMedecins();
        for (Medecin m : allMedecins) {
            medecinsMap.put(m.getId(), m);
        }
        
        request.setAttribute("creneaux", creneaux);
        request.setAttribute("medecinsMap", medecinsMap);
        
        request.getRequestDispatcher("/WEB-INF/views/patient/prendre-ticket.jsp").forward(request, response);
    }
    
    private void afficherConsultations(HttpServletRequest request, HttpServletResponse response, int patientId) 
            throws ServletException, IOException {
        
        // Récupérer les consultations
        List<Consultation> consultations = consultationDAO.getConsultationsByPatient(patientId);
        
        // Créer une map des médecins
        Map<Integer, Medecin> medecinsMap = new HashMap<>();
        List<Medecin> allMedecins = userDAO.getAllMedecins();
        for (Medecin m : allMedecins) {
            medecinsMap.put(m.getId(), m);
        }
        
        request.setAttribute("consultations", consultations);
        request.setAttribute("medecinsMap", medecinsMap);
        
        request.getRequestDispatcher("/WEB-INF/views/patient/mes-consultations.jsp").forward(request, response);
    }
    
    private void afficherProfil(HttpServletRequest request, HttpServletResponse response, int patientId) 
            throws ServletException, IOException {
        
        Patient patient = userDAO.getPatientById(patientId);
        request.setAttribute("patient", patient);
        
        request.getRequestDispatcher("/WEB-INF/views/patient/profil.jsp").forward(request, response);
    }
    
    // post
    
    private void prendreRendezVous(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        try {
            int creneauId = Integer.parseInt(request.getParameter("creneauId"));
            
            // Récupérer le créneau pour obtenir le médecin
            Creneau creneau = creneauDAO.getCreneauById(creneauId);
            
            if (creneau == null) {
                session.setAttribute("error", "Créneau introuvable");
                response.sendRedirect(request.getContextPath() + "/patient/creneaux-disponibles");
                return;
            }
            
            // ✅ VÉRIFICATION 1 : Le créneau est-il encore disponible ?
            if (creneau.getTicketsPris() >= creneau.getCapacite()) {
                session.setAttribute("error", "⚠️ Ce créneau est complet !");
                response.sendRedirect(request.getContextPath() + "/patient/creneaux-disponibles");
                return;
            }
            
            // ✅ VÉRIFICATION 2 : Le patient n'a-t-il pas déjà réservé ce créneau ?
            if (ticketDAO.patientADejaReserveCreneau(user.getId(), creneauId)) {
                session.setAttribute("error", "❌ Vous avez déjà réservé ce créneau !");
                response.sendRedirect(request.getContextPath() + "/patient/creneaux-disponibles");
                return;
            }
            
            // Créer le ticket
            Ticket ticket = new Ticket();
            ticket.setPatientId(user.getId());
            ticket.setMedecinId(creneau.getMedecinId());
            ticket.setCreneauId(creneauId);
            ticket.setStatut("en_attente");
            ticket.setPriorite(2); // Normal par défaut
            
            // Le trigger va automatiquement incrémenter tickets_pris ✅
            if (ticketDAO.creerTicket(ticket)) {
                session.setAttribute("success", "✅ Rendez-vous réservé avec succès ! Ticket : " + ticket.getNumero());
                response.sendRedirect(request.getContextPath() + "/patient/tickets");
            } else {
                session.setAttribute("error", "❌ Erreur lors de la réservation");
                response.sendRedirect(request.getContextPath() + "/patient/creneaux-disponibles");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "❌ Erreur : " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/patient/creneaux-disponibles");
        }
    }
    
    private void annulerTicket(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        try {
            int ticketId = Integer.parseInt(request.getParameter("ticketId"));
            
            // ✅ Vérifier que le ticket appartient bien au patient connecté
            Ticket ticket = ticketDAO.getTicketById(ticketId);
            
            if (ticket == null) {
                session.setAttribute("error", "Ticket introuvable");
                response.sendRedirect(request.getContextPath() + "/patient/tickets");
                return;
            }
            
            if (ticket.getPatientId() != user.getId()) {
                session.setAttribute("error", "❌ Vous n'êtes pas autorisé à annuler ce ticket");
                response.sendRedirect(request.getContextPath() + "/patient/tickets");
                return;
            }
            
            // Annuler le ticket (le trigger va décrémenter tickets_pris automatiquement)
            if (ticketDAO.annulerTicket(ticketId)) {
                session.setAttribute("success", "Rendez-vous annulé avec succès");
            } else {
                session.setAttribute("error", " Impossible d'annuler ce ticket (peut-être déjà en consultation ou terminé)");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", " Erreur : " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/patient/tickets");
    }
    
    private void updateProfil(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        Patient patient = userDAO.getPatientById(user.getId());
        
        patient.setNom(request.getParameter("nom"));
        patient.setPrenom(request.getParameter("prenom"));
        patient.setEmail(request.getParameter("email"));
        patient.setTelephone(request.getParameter("telephone"));
        patient.setAdresse(request.getParameter("adresse"));
        patient.setGroupeSanguin(request.getParameter("groupeSanguin"));
        
        if (userDAO.updatePatient(patient)) {
            session.setAttribute("success", "Profil mis à jour avec succès");
            session.setAttribute("user", patient);
        } else {
            session.setAttribute("error", "Erreur lors de la mise à jour du profil");
        }
        
        response.sendRedirect(request.getContextPath() + "/patient/profil");
    }
}