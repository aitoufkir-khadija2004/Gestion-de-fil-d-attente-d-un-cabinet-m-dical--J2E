package servlets;
import java.util.Map;
import java.util.HashMap;

import dao.DAOFactory;
import dao.*;
import beans.*;
import services.WhatsAppService;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/secretaire/*")
public class SecretaireServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    private TicketDAO ticketDAO;
    private CreneauDAO creneauDAO;
    private ConsultationDAO consultationDAO;
    private SpecialiteDAO specialiteDAO;
    private NotificationDAO notificationDAO;
    
    @Override
    public void init() throws ServletException {
        DAOFactory factory = DAOFactory.getInstance();
        userDAO = factory.getUserDAO();
        ticketDAO = factory.getTicketDAO();
        creneauDAO = factory.getCreneauDAO();
        consultationDAO = factory.getConsultationDAO();
        specialiteDAO = factory.getSpecialiteDAO();
        notificationDAO = factory.getNotificationDAO();
    }
    
    public SecretaireServlet() {
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
        if (!"SECRETAIRE".equals(user.getRole())) {
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
            case "/patients":
                afficherPatients(request, response);
                break;
            case "/nouveau-patient":
                afficherNouveauPatient(request, response);
                break;
            case "/tickets":
                afficherTickets(request, response);
                break;
            case "/nouveau-ticket":
                afficherNouveauTicket(request, response);
                break;
            case "/creneaux":
                afficherCreneaux(request, response);
                break;
            case "/nouveau-creneau":
                afficherNouveauCreneau(request, response);
                break;
            case "/medecins":
                afficherMedecins(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        System.out.println("DEBUG - pathInfo reçu : " + pathInfo); 
        
        if ("/creer-patient".equals(pathInfo)) {
            creerPatient(request, response);
        } else if ("/creer-ticket".equals(pathInfo)) {
            creerTicket(request, response);
        } else if ("/creer-creneau".equals(pathInfo)) {
            creerCreneau(request, response);
        } else if ("/annuler-ticket".equals(pathInfo)) {
            annulerTicket(request, response);
        } else if ("/appeler-patient".equals(pathInfo)) {
            appellerPatient(request, response);
        } else if ("/valider-arrivee".equals(pathInfo)) {
            validerArrivee(request, response);
        } else {
            System.out.println("Aucun match trouvé pour : " + pathInfo); 
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    //get
    
    private void afficherDashboard(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Patient> patients = userDAO.getAllPatients();
        List<Medecin> medecins = userDAO.getAllMedecins();
        List<Creneau> creneaux = creneauDAO.getCreneauxDisponibles();
        
        request.setAttribute("nbPatients", patients != null ? patients.size() : 0);
        request.setAttribute("nbMedecins", medecins != null ? medecins.size() : 0);
        request.setAttribute("nbCreneaux", creneaux != null ? creneaux.size() : 0);
        
        request.getRequestDispatcher("/WEB-INF/views/secretaire/dashboard.jsp").forward(request, response);
    }
    
    private void afficherPatients(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Patient> patients = userDAO.getAllPatients();
        
        List<Ticket> ticketsAujourdhui = ticketDAO.getAllTickets();
        
        request.setAttribute("patients", patients);
        request.setAttribute("ticketsAujourdhui", ticketsAujourdhui);
        
        request.getRequestDispatcher("/WEB-INF/views/secretaire/patients.jsp").forward(request, response);
    }
    private void afficherNouveauPatient(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.getRequestDispatcher("/WEB-INF/views/secretaire/nouveau-patient.jsp").forward(request, response);
    }
    
    private void afficherTickets(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Ticket> tickets = ticketDAO.getAllTickets();
        
        // Créer des Maps pour stocker les infos des patients, médecins et créneaux
        Map<Integer, Patient> patientsMap = new HashMap<>();
        Map<Integer, Medecin> medecinsMap = new HashMap<>();
        Map<Integer, Creneau> creneauxMap = new HashMap<>();
        
        // Récupérer tous les patients
        List<Patient> allPatients = userDAO.getAllPatients();
        for (Patient p : allPatients) {
            patientsMap.put(p.getId(), p);
        }
        
        // Récupérer tous les médecins
        List<Medecin> allMedecins = userDAO.getAllMedecins();
        for (Medecin m : allMedecins) {
            medecinsMap.put(m.getId(), m);
        }
        
        // Récupérer tous les créneaux
        List<Creneau> allCreneaux = creneauDAO.getAllCreneaux();
        for (Creneau c : allCreneaux) {
            creneauxMap.put(c.getId(), c);
        }
        
        request.setAttribute("tickets", tickets);
        request.setAttribute("patientsMap", patientsMap);
        request.setAttribute("medecinsMap", medecinsMap);
        request.setAttribute("creneauxMap", creneauxMap);
        
        request.getRequestDispatcher("/WEB-INF/views/secretaire/tickets.jsp").forward(request, response);
    }
    
    private void afficherNouveauTicket(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Patient> patients = userDAO.getAllPatients();
        List<Medecin> medecins = userDAO.getAllMedecins();
        List<Creneau> creneaux = creneauDAO.getCreneauxDisponibles();
        
        request.setAttribute("patients", patients);
        request.setAttribute("medecins", medecins);
        request.setAttribute("creneaux", creneaux);
        
        request.getRequestDispatcher("/WEB-INF/views/secretaire/nouveau-ticket.jsp").forward(request, response);
    }
    
    private void afficherCreneaux(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Récupérer tous les créneaux
            List<Creneau> creneaux = creneauDAO.getAllCreneaux();
            
            // Créer une map des médecins pour affichage
            Map<Integer, Medecin> medecinsMap = new HashMap<>();
            List<Medecin> medecins = userDAO.getAllMedecins(); 
            
            for (Medecin medecin : medecins) {
                medecinsMap.put(medecin.getId(), medecin);
            }
            
            // Passer les données à la JSP
            request.setAttribute("creneaux", creneaux);
            request.setAttribute("medecinsMap", medecinsMap);
            
            // Afficher la page
            request.getRequestDispatcher("/WEB-INF/views/secretaire/creneaux.jsp")
                   .forward(request, response);
                   
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Erreur lors du chargement des créneaux: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/secretaire/dashboard");
        }
    }
    
    private void afficherNouveauCreneau(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Medecin> medecins = userDAO.getAllMedecins();
        request.setAttribute("medecins", medecins);
        
        request.getRequestDispatcher("/WEB-INF/views/secretaire/nouveau-creneau.jsp").forward(request, response);
    }
    
    private void afficherMedecins(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Medecin> medecins = userDAO.getAllMedecins();
        request.setAttribute("medecins", medecins);
        
        request.getRequestDispatcher("/WEB-INF/views/secretaire/medecins.jsp").forward(request, response);
    }
    
//post     
    private void creerPatient(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String telephone = request.getParameter("telephone");
        String nss = request.getParameter("numeroSecuriteSociale");
        String dateNaissanceStr = request.getParameter("dateNaissance");
        String adresse = request.getParameter("adresse");
        String groupeSanguin = request.getParameter("groupeSanguin");
        
        if (nom == null || nom.trim().isEmpty() || 
            prenom == null || prenom.trim().isEmpty() ||
            email == null || email.trim().isEmpty()) {
            session.setAttribute("error", "Les champs nom, prenom et email sont obligatoires");
            response.sendRedirect(request.getContextPath() + "/secretaire/nouveau-patient");
            return;
        }
        
        Patient patient = new Patient();
        patient.setNom(nom.trim());
        patient.setPrenom(prenom.trim());
        patient.setEmail(email.trim());
        patient.setPassword(password != null && !password.isEmpty() ? password : "patient123");
        patient.setTelephone(telephone);
        patient.setNumeroSecuriteSociale(nss);
        
        if (dateNaissanceStr != null && !dateNaissanceStr.isEmpty()) {
            patient.setDateNaissance(Date.valueOf(dateNaissanceStr));
        }
        
        patient.setAdresse(adresse);
        patient.setGroupeSanguin(groupeSanguin);
        
        if (userDAO.creerPatient(patient)) {
            session.setAttribute("success", "Patient cree avec succes : " + patient.getCodeUser());
            response.sendRedirect(request.getContextPath() + "/secretaire/patients");
        } else {
            session.setAttribute("error", "Erreur lors de la creation du patient");
            response.sendRedirect(request.getContextPath() + "/secretaire/nouveau-patient");
        }
    }
    
    private void creerTicket(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        int patientId = Integer.parseInt(request.getParameter("patientId"));
        int medecinId = Integer.parseInt(request.getParameter("medecinId"));
        int creneauId = Integer.parseInt(request.getParameter("creneauId"));
        int priorite = request.getParameter("priorite") != null ? 
                       Integer.parseInt(request.getParameter("priorite")) : 1;
        
        Ticket ticket = new Ticket();
        ticket.setPatientId(patientId);
        ticket.setMedecinId(medecinId);
        ticket.setCreneauId(creneauId);
        ticket.setStatut("en_attente");
        ticket.setPriorite(priorite);
        
        if (ticketDAO.creerTicket(ticket)) {
            
            // Recuperer les infos pour WhatsApp
            Patient patient = (Patient) userDAO.getUserById(patientId);
            Medecin medecin = (Medecin) userDAO.getUserById(medecinId);
            Creneau creneau = creneauDAO.getCreneauById(creneauId);
            
            // Envoyer confirmation WhatsApp
            if (patient != null && patient.getTelephone() != null && !patient.getTelephone().isEmpty()) {
                WhatsAppService.confirmerTicket(
                    patient.getTelephone(),
                    ticket.getNumero(),
                    medecin.getNom() + " " + medecin.getPrenom(),
                    creneau.getDate().toString(),
                    creneau.getHeureDebut().toString()
                );
            }
            
            session.setAttribute("success", "Ticket cree avec succes : " + ticket.getNumero());
            response.sendRedirect(request.getContextPath() + "/secretaire/tickets");
        } else {
            session.setAttribute("error", "Erreur lors de la creation du ticket");
            response.sendRedirect(request.getContextPath() + "/secretaire/nouveau-ticket");
        }
    }
    
    private void creerCreneau(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        int medecinId = Integer.parseInt(request.getParameter("medecinId"));
        String dateStr = request.getParameter("date");
        String heureDebutStr = request.getParameter("heureDebut");
        String heureFinStr = request.getParameter("heureFin");
        int capacite = Integer.parseInt(request.getParameter("capacite"));
        
        Creneau creneau = new Creneau();
        creneau.setMedecinId(medecinId);
        creneau.setDate(Date.valueOf(dateStr));
        creneau.setHeureDebut(Time.valueOf(heureDebutStr + ":00"));
        creneau.setHeureFin(Time.valueOf(heureFinStr + ":00"));
        creneau.setCapacite(capacite);
        
        if (creneauDAO.creerCreneau(creneau)) {
            session.setAttribute("success", "Creneau cree avec succes");
            response.sendRedirect(request.getContextPath() + "/secretaire/creneaux");
        } else {
            session.setAttribute("error", "Erreur lors de la creation du creneau");
            response.sendRedirect(request.getContextPath() + "/secretaire/nouveau-creneau");
        }
    }
    
    private void annulerTicket(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        int ticketId = Integer.parseInt(request.getParameter("ticketId"));
        
        if (ticketDAO.annulerTicket(ticketId)) {
            session.setAttribute("success", "Ticket annule avec succes");
        } else {
            session.setAttribute("error", "Erreur lors de l'annulation du ticket");
        }
        
        response.sendRedirect(request.getContextPath() + "/secretaire/tickets");
    }
    
    private void appellerPatient(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        int ticketId = Integer.parseInt(request.getParameter("ticketId"));
        
        Ticket ticket = ticketDAO.getTicketById(ticketId);
        Patient patient = (Patient) userDAO.getUserById(ticket.getPatientId());
        Medecin medecin = (Medecin) userDAO.getUserById(ticket.getMedecinId());
        
        if (ticketDAO.updateStatut(ticketId, "appele")) {
            
            // Envoyer message WhatsApp
            if (patient != null && patient.getTelephone() != null && !patient.getTelephone().isEmpty()) {
                boolean whatsappEnvoye = WhatsAppService.appellerPatient(
                    patient.getTelephone(),
                    ticket.getNumero(),
                    medecin.getNom() + " " + medecin.getPrenom()
                );
                
                if (whatsappEnvoye) {
                    session.setAttribute("success", "Patient appele avec succes (WhatsApp envoye)");
                } else {
                    session.setAttribute("success", "Patient appele (erreur WhatsApp)");
                }
            } else {
                session.setAttribute("success", "Patient appele (pas de numero)");
            }
            
        } else {
            session.setAttribute("error", "Erreur lors de l'appel du patient");
        }
        
        response.sendRedirect(request.getContextPath() + "/secretaire/tickets");
    }

    private void validerArrivee(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        try {
            String ticketIdStr = request.getParameter("ticketId");
            
            if (ticketIdStr == null || ticketIdStr.isEmpty()) {
                session.setAttribute("error", "ID du ticket manquant");
                response.sendRedirect(request.getContextPath() + "/secretaire/tickets");
                return;
            }
            
            int ticketId = Integer.parseInt(ticketIdStr);
            
            // Vérifier que le ticket existe et est en statut "appele"
            Ticket ticket = ticketDAO.getTicketById(ticketId);
            
            if (ticket == null) {
                session.setAttribute("error", "Ticket introuvable");
                response.sendRedirect(request.getContextPath() + "/secretaire/tickets");
                return;
            }
            
            if (!"appele".equals(ticket.getStatut())) {
                session.setAttribute("error", "Le patient n'a pas encore été appelé (statut actuel : " + ticket.getStatut() + ")");
                response.sendRedirect(request.getContextPath() + "/secretaire/tickets");
                return;
            }
            
            // Mettre à jour le statut
            boolean success = ticketDAO.updateStatut(ticketId, "present");
            
            if (success) {
                session.setAttribute("success", "Arrivée du patient validée avec succès !");
            } else {
                session.setAttribute("error", "Erreur lors de la mise à jour du statut");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Format d'ID invalide : " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Erreur lors de la validation : " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/secretaire/tickets");
    }
}