package beans;

import java.sql.Timestamp;
public class Notification {
    private int id;                      
    private String codeNotification;    
    private int ticketId;                
    private int patientId;               
    private String message;             
    private String type;                 
    private String methode;             
    private String statut;               
    private Timestamp dateEnvoi;         
    private Timestamp dateReception;     
    private int tentatives;              
    
    //pour affichage 
    private String numeroTicket;
    private String nomPatient;
    private String prenomPatient;
    private String telPatient;
   
    public Notification() {
        this.methode = "SMS";          
        this.statut = "en_attente";   
        this.tentatives = 0;          
    }
    
    public Notification(int ticketId, int patientId, String message, String type) {
        this.ticketId = ticketId;
        this.patientId = patientId;
        this.message = message;
        this.type = type;
        this.methode = "SMS";
        this.statut = "en_attente";
        this.tentatives = 0;
    }
    
    
    public int getId() {
        return id;
    }
    
    public String getCodeNotification() {
        return codeNotification;
    }
    
    public int getTicketId() {
        return ticketId;
    }
    
    public int getPatientId() {
        return patientId;
    }
    
    public String getMessage() {
        return message;
    }
    
    public String getType() {
        return type;
    }
    
    public String getMethode() {
        return methode;
    }
    
    public String getStatut() {
        return statut;
    }
    
    public Timestamp getDateEnvoi() {
        return dateEnvoi;
    }
    
    public Timestamp getDateReception() {
        return dateReception;
    }
    
    public int getTentatives() {
        return tentatives;
    }
    
    public String getNumeroTicket() {
        return numeroTicket;
    }
    
    public String getNomPatient() {
        return nomPatient;
    }
    
    public String getPrenomPatient() {
        return prenomPatient;
    }
    
    public String getTelPatient() {
        return telPatient;
    }
    
    
    public void setId(int id) {
        this.id = id;
    }
    
    public void setCodeNotification(String codeNotification) {
        this.codeNotification = codeNotification;
    }
    
    public void setTicketId(int ticketId) {
        this.ticketId = ticketId;
    }
    
    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    public void setType(String type) {
        this.type = type;
    }
    
    public void setMethode(String methode) {
        this.methode = methode;
    }
    
    public void setStatut(String statut) {
        this.statut = statut;
    }
    
    public void setDateEnvoi(Timestamp dateEnvoi) {
        this.dateEnvoi = dateEnvoi;
    }
    
    public void setDateReception(Timestamp dateReception) {
        this.dateReception = dateReception;
    }
    
    public void setTentatives(int tentatives) {
        this.tentatives = tentatives;
    }
    
    public void setNumeroTicket(String numeroTicket) {
        this.numeroTicket = numeroTicket;
    }
    
    public void setNomPatient(String nomPatient) {
        this.nomPatient = nomPatient;
    }
    
    public void setPrenomPatient(String prenomPatient) {
        this.prenomPatient = prenomPatient;
    }
    
    public void setTelPatient(String telPatient) {
        this.telPatient = telPatient;
    }
    

  
    public boolean estEnvoyee() {
        return "envoye".equals(statut);
    }
    
    
    public boolean estEnAttente() {
        return "en_attente".equals(statut);
    }
    
   
    public boolean estEnEchec() {
        return "echec".equals(statut);
    }
    
    @Override
    public String toString() {
        return "Notification{" +
                "id=" + id +
                ", codeNotification='" + codeNotification + '\'' +
                ", ticket='" + numeroTicket + '\'' +
                ", patient='" + prenomPatient + " " + nomPatient + '\'' +
                ", type='" + type + '\'' +
                ", methode='" + methode + '\'' +
                ", statut='" + statut + '\'' +
                ", message='" + message + '\'' +
                '}';
    }
}