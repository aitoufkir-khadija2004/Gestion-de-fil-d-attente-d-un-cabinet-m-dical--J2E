package services;

import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.type.PhoneNumber;

public class WhatsAppService {
    
    // Twilio credentials - A REMPLACER PAR TES VRAIES CLES
    private static final String ACCOUNT_SID = "";
    private static final String AUTH_TOKEN = "";
    private static final String WHATSAPP_FROM = "whatsapp:+212716231053";
    
    static {
        Twilio.init(ACCOUNT_SID, AUTH_TOKEN);
    }
    
    public static boolean envoyerMessage(String numeroDestinataire, String message) {
        try {
            if (!numeroDestinataire.startsWith("+")) {
                if (numeroDestinataire.startsWith("0")) {
                    numeroDestinataire = "+212" + numeroDestinataire.substring(1);
                } else {
                    numeroDestinataire = "+212" + numeroDestinataire;
                }
            }
            
            Message twilioMessage = Message.creator(
                new PhoneNumber("whatsapp:" + numeroDestinataire),
                new PhoneNumber(WHATSAPP_FROM),
                message
            ).create();
            
            System.out.println("WhatsApp envoye avec succes : " + twilioMessage.getSid());
            return true;
            
        } catch (Exception e) {
            System.err.println("Erreur envoi WhatsApp : " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public static boolean appellerPatient(String numeroPatient, String numeroTicket, String nomMedecin) {
        String message = "Clinique Al Omrane\n\n" +
                        "Bonjour,\n\n" +
                        "Votre ticket " + numeroTicket + " est appele.\n" +
                        "Veuillez vous presenter au cabinet du Dr. " + nomMedecin + ".\n\n" +
                        "Merci de votre patience.";
        
        return envoyerMessage(numeroPatient, message);
    }
    
    public static boolean confirmerTicket(String numeroPatient, String numeroTicket, 
                                         String nomMedecin, String dateRdv, String heureRdv) {
        String message = "Ticket confirme\n\n" +
                        "Ticket : " + numeroTicket + "\n" +
                        "Medecin : Dr. " + nomMedecin + "\n" +
                        "Date : " + dateRdv + "\n" +
                        "Heure : " + heureRdv + "\n\n" +
                        "Vous recevrez un rappel avant votre rendez-vous.";
        
        return envoyerMessage(numeroPatient, message);
    }
}