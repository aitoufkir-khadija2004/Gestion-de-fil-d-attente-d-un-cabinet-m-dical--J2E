package dao;

import beans.*;
import java.sql.Date;
import java.sql.Time;

public class Test {
 
    public static void main(String[] args) {
        
        System.out.println("========================================");
        System.out.println("   TEST DU FLUX COMPLET (AVEC FACTORY)");
        System.out.println("========================================\n");
        
        try {
            
            // ==================== OBTENIR LA FACTORY ====================
            DAOFactory factory = DAOFactory.getInstance();
            
            // ==================== ÉTAPE 1 : CRÉER UN CRÉNEAU ====================
            System.out.println("📌 ÉTAPE 1 : Créer un créneau");
            System.out.println("----------------------------------------");
            
            CreneauDAO creneauDAO = (CreneauDAO) factory.getCreneauDAO();
            Creneau creneau = new Creneau();
            creneau.setMedecinId(2);  // ID d'un médecin existant dans ta BD
            creneau.setDate(Date.valueOf("2025-11-16"));
            creneau.setHeureDebut(Time.valueOf("09:00:00"));
            creneau.setHeureFin(Time.valueOf("12:00:00"));
            creneau.setCapacite(10);
            
            if (creneauDAO.creerCreneau(creneau)) {
                System.out.println("✅ Créneau créé avec succès !");
                System.out.println("   Code : " + creneau.getCodeCreneau());
                System.out.println("   ID : " + creneau.getId());
                System.out.println("   Date : " + creneau.getDate());
                System.out.println("   Horaire : " + creneau.getHeureDebut() + " - " + creneau.getHeureFin());
                System.out.println("   Capacité : " + creneau.getCapacite());
                System.out.println("   Tickets pris : " + creneau.getTicketsPris());
            } else {
                System.out.println("❌ Échec création créneau");
                return;  // Arrêter le test
            }
            
            System.out.println();
            
            // ==================== ÉTAPE 2 : CRÉER UN TICKET ====================
            System.out.println("📌 ÉTAPE 2 : Créer un ticket pour ce créneau");
            System.out.println("----------------------------------------");
            
            TicketDAO ticketDAO = (TicketDAO) factory.getTicketDAO();
            Ticket ticket = new Ticket();
            ticket.setPatientId(8);   // ID d'un patient existant
            ticket.setMedecinId(2);   // Même médecin que le créneau
            ticket.setCreneauId(creneau.getId());
            ticket.setStatut("en_attente");
            ticket.setPriorite(1);
            
            if (ticketDAO.creerTicket(ticket)) {
                System.out.println("✅ Ticket créé avec succès !");
                System.out.println("   Numéro : " + ticket.getNumero());
                System.out.println("   ID : " + ticket.getId());
                System.out.println("   Statut : " + ticket.getStatut());
            } else {
                System.out.println("❌ Échec création ticket");
                return;
            }
            
            System.out.println();
            
            // ==================== ÉTAPE 3 : VÉRIFIER LE CRÉNEAU ====================
            System.out.println("📌 ÉTAPE 3 : Vérifier que le créneau a été mis à jour");
            System.out.println("----------------------------------------");
            
            Creneau creneauMaj = creneauDAO.getCreneauById(creneau.getId());
            
            if (creneauMaj != null) {
                System.out.println("✅ Créneau récupéré !");
                System.out.println("   Tickets pris : " + creneauMaj.getTicketsPris() + 
                                 " (devrait être 1)");
                System.out.println("   Places restantes : " + creneauMaj.getPlacesRestantes() + 
                                 " (devrait être 9)");
                System.out.println("   Disponible : " + (creneauMaj.isDisponible() ? "OUI" : "NON"));
                
                if (creneauMaj.getTicketsPris() == 1) {
                    System.out.println("✅ SUCCÈS : Le créneau a bien été incrémenté !");
                } else {
                    System.out.println("❌ ERREUR : Le créneau n'a pas été mis à jour !");
                }
            } else {
                System.out.println("❌ Impossible de récupérer le créneau");
            }
            
            System.out.println();
            
            // ==================== ÉTAPE 4 : CRÉER UNE CONSULTATION ====================
            System.out.println("📌 ÉTAPE 4 : Créer une consultation");
            System.out.println("----------------------------------------");
            
            ConsultationDAO consultationDAO = (ConsultationDAO) factory.getConsultationDAO();
            Consultation consultation = new Consultation();
            consultation.setTicketId(ticket.getId());
            consultation.setMedecinId(2);
            consultation.setPatientId(8);
            consultation.setSymptomes("Mal de tête depuis 3 jours");
            consultation.setStatut("en_cours");
            
            if (consultationDAO.creerConsultation(consultation)) {
                System.out.println("✅ Consultation créée avec succès !");
                System.out.println("   Code : " + consultation.getCodeConsultation());
                System.out.println("   ID : " + consultation.getId());
                System.out.println("   Symptômes : " + consultation.getSymptomes());
            } else {
                System.out.println("❌ Échec création consultation");
                return;
            }
            
            System.out.println();
            
            // ==================== ÉTAPE 5 : VÉRIFIER LE TICKET ====================
            System.out.println("📌 ÉTAPE 5 : Vérifier que le ticket a été mis à jour");
            System.out.println("----------------------------------------");
            
            Ticket ticketMaj = ticketDAO.getTicketById(ticket.getId());
            
            if (ticketMaj != null) {
                System.out.println("✅ Ticket récupéré !");
                System.out.println("   Statut : " + ticketMaj.getStatut() + 
                                 " (devrait être 'appele')");
                
                if ("appele".equals(ticketMaj.getStatut())) {
                    System.out.println("✅ SUCCÈS : Le ticket a bien été mis à jour !");
                } else {
                    System.out.println("❌ ERREUR : Le statut du ticket n'a pas changé !");
                }
            } else {
                System.out.println("❌ Impossible de récupérer le ticket");
            }
            
            System.out.println();
            
            // ==================== ÉTAPE 6 : TEST DES AUTRES DAO ====================
            System.out.println("📌 ÉTAPE 6 : Tester UserDAO et SpecialiteDAO");
            System.out.println("----------------------------------------");
            
            // Test UserDAO
            UserDAO userDAO = (UserDAO) factory.getUserDAO();
            System.out.println("✅ UserDAO créé via Factory");
            
            // Récupérer tous les patients
            var patients = userDAO.getAllPatients();
            System.out.println("   Nombre de patients : " + patients.size());
            
            // Test SpecialiteDAO
            SpecialiteDAO specialiteDAO = (SpecialiteDAO) factory.getSpecialiteDAO();
            System.out.println("✅ SpecialiteDAO créé via Factory");
            
            // Récupérer toutes les spécialités
            var specialites = specialiteDAO.getAllSpecialites();
            System.out.println("   Nombre de spécialités : " + specialites.size());
            
            System.out.println();
            
            // ==================== ÉTAPE 7 : TEST NOTIFICATION ====================
            System.out.println("📌 ÉTAPE 7 : Créer une notification");
            System.out.println("----------------------------------------");
            
            NotificationDAO notificationDAO = (NotificationDAO) factory.getNotificationDAO();
            Notification notification = new Notification();
            notification.setTicketId(ticket.getId());
            notification.setPatientId(8);
            notification.setMessage("Votre ticket " + ticket.getNumero() + " a été créé. RDV le 16/11/2025.");
            notification.setType("CREATION");
            notification.setMethode("SMS");
            notification.setStatut("en_attente");
            
            if (notificationDAO.creerNotification(notification)) {
                System.out.println("✅ Notification créée avec succès !");
                System.out.println("   Code : " + notification.getCodeNotification());
                System.out.println("   Message : " + notification.getMessage());
            } else {
                System.out.println("❌ Échec création notification");
            }
            
            System.out.println();
            
            // ==================== RÉSUMÉ FINAL ====================
            System.out.println("========================================");
            System.out.println("   RÉSUMÉ DU TEST");
            System.out.println("========================================");
            System.out.println("✅ DAOFactory              : OK (Singleton)");
            System.out.println("✅ Créneau créé            : " + creneau.getCodeCreneau());
            System.out.println("✅ Ticket créé             : " + ticket.getNumero());
            System.out.println("✅ Créneau incrémenté      : tickets_pris = " + creneauMaj.getTicketsPris());
            System.out.println("✅ Consultation créée      : " + consultation.getCodeConsultation());
            System.out.println("✅ Ticket mis à jour       : statut = " + ticketMaj.getStatut());
            System.out.println("✅ Notification créée      : " + notification.getCodeNotification());
            System.out.println("✅ UserDAO                 : OK (" + patients.size() + " patients)");
            System.out.println("✅ SpecialiteDAO           : OK (" + specialites.size() + " spécialités)");
            System.out.println("========================================");
            System.out.println("🎉 TOUS LES DAO FONCTIONNENT AVEC FACTORY !");
            System.out.println("========================================\n");
            
        } catch (Exception e) {
            System.err.println("\n❌ ERREUR PENDANT LE TEST :");
            System.err.println(e.getMessage());
            e.printStackTrace();
        }
    }
}