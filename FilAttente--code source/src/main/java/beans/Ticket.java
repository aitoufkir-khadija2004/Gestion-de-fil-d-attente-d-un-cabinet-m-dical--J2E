package beans;

import java.sql.Time;
import java.sql.Timestamp;

public class Ticket {
	
    private int id;                   
    private String numero;            
    private int patientId;             
    private int medecinId;             
    private int creneauId;            
    private String statut;            
    private Timestamp dateCreation;    
    private Time heureArrivee;         
    private int priorite;          
    
    //pour affichage
    
    private String nomPatient;         
    private String prenomPatient;      
    private String telPatient;         
    private String nomMedecin;         
    private String prenomMedecin;      
    private String specialiteMedecin;  
    

    public Ticket() {
        this.statut = "en_attente";  
        this.priorite = 1;           
    }
    
    public Ticket(String numero, int patientId, int medecinId, int creneauId) {
        this.numero = numero;
        this.patientId = patientId;
        this.medecinId = medecinId;
        this.creneauId = creneauId;
        this.statut = "en_attente";
        this.priorite = 1;
    }
    
    
    public int getId() {
        return id;
    }
    
    public String getNumero() {
        return numero;
    }
    
    public int getPatientId() {
        return patientId;
    }
    
    public int getMedecinId() {
        return medecinId;
    }
    
    public int getCreneauId() {
        return creneauId;
    }
    
    public String getStatut() {
        return statut;
    }
    
    public Timestamp getDateCreation() {
        return dateCreation;
    }
    
    public Time getHeureArrivee() {
        return heureArrivee;
    }
    
    public int getPriorite() {
        return priorite;
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
    
    public String getNomMedecin() {
        return nomMedecin;
    }
    
    public String getPrenomMedecin() {
        return prenomMedecin;
    }
    
    public String getSpecialiteMedecin() {
        return specialiteMedecin;
    }
        
    public void setId(int id) {
        this.id = id;
    }
    
    public void setNumero(String numero) {
        this.numero = numero;
    }
    
    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }
    
    public void setMedecinId(int medecinId) {
        this.medecinId = medecinId;
    }
    
    public void setCreneauId(int creneauId) {
        this.creneauId = creneauId;
    }
    
    public void setStatut(String statut) {
        this.statut = statut;
    }
    
    public void setDateCreation(Timestamp dateCreation) {
        this.dateCreation = dateCreation;
    }
    
    public void setHeureArrivee(Time heureArrivee) {
        this.heureArrivee = heureArrivee;
    }
    
    public void setPriorite(int priorite) {
        this.priorite = priorite;
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
    
    public void setNomMedecin(String nomMedecin) {
        this.nomMedecin = nomMedecin;
    }
    
    public void setPrenomMedecin(String prenomMedecin) {
        this.prenomMedecin = prenomMedecin;
    }
    
    public void setSpecialiteMedecin(String specialiteMedecin) {
        this.specialiteMedecin = specialiteMedecin;
    }
  
    public boolean estEnAttente() {
        return "en_attente".equals(statut);
    }
    
    public boolean estAppele() {
        return "appele".equals(statut);
    }
  
    public boolean estTermine() {
        return "termine".equals(statut);
    }
   
    public boolean estAnnule() {
        return "annule".equals(statut);
    }
    
    @Override
    public String toString() {
        return "Ticket{" +
                "id=" + id +
                ", numero='" + numero + '\'' +
                ", patient='" + prenomPatient + " " + nomPatient + '\'' +
                ", medecin='Dr. " + prenomMedecin + " " + nomMedecin + '\'' +
                ", specialite='" + specialiteMedecin + '\'' +
                ", statut='" + statut + '\'' +
                ", dateCreation=" + dateCreation +
                '}';
    }
}