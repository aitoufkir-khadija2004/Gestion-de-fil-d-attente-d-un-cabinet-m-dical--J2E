package beans;
import java.sql.Timestamp;
public class Consultation {
    private int id;                      
    private String codeConsultation;     
    private int ticketId;                
    private int medecinId;               
    private int patientId;               
    private Timestamp dateConsultation;  
    private String symptomes;            
    private String diagnostic;           
    private String prescription;         
    private String notesMedicales;       
    private int dureeConsultation;       
    private String statut;               
    
    //pour affichage 
    private String nomPatient;
    private String prenomPatient;
    private String nomMedecin;
    private String prenomMedecin;
    private String numeroTicket;
   
    public Consultation() {
        this.dureeConsultation = 15;  
        this.statut = "en_cours";     
    }
    
   
    public Consultation(int ticketId, int medecinId, int patientId) {
        this.ticketId = ticketId;
        this.medecinId = medecinId;
        this.patientId = patientId;
        this.dureeConsultation = 15;
        this.statut = "en_cours";
    }
    
    
    public int getId() {
        return id;
    }
    
    public String getCodeConsultation() {
        return codeConsultation;
    }
    
    public int getTicketId() {
        return ticketId;
    }
    
    public int getMedecinId() {
        return medecinId;
    }
    
    public int getPatientId() {
        return patientId;
    }
    
    public Timestamp getDateConsultation() {
        return dateConsultation;
    }
    
    public String getSymptomes() {
        return symptomes;
    }
    
    public String getDiagnostic() {
        return diagnostic;
    }
    
    public String getPrescription() {
        return prescription;
    }
    
    public String getNotesMedicales() {
        return notesMedicales;
    }
    
    public int getDureeConsultation() {
        return dureeConsultation;
    }
    
    public String getStatut() {
        return statut;
    }
    
    public String getNomPatient() {
        return nomPatient;
    }
    
    public String getPrenomPatient() {
        return prenomPatient;
    }
    
    public String getNomMedecin() {
        return nomMedecin;
    }
    
    public String getPrenomMedecin() {
        return prenomMedecin;
    }
    
    public String getNumeroTicket() {
        return numeroTicket;
    }
    
    
    public void setId(int id) {
        this.id = id;
    }
    
    public void setCodeConsultation(String codeConsultation) {
        this.codeConsultation = codeConsultation;
    }
    
    public void setTicketId(int ticketId) {
        this.ticketId = ticketId;
    }
    
    public void setMedecinId(int medecinId) {
        this.medecinId = medecinId;
    }
    
    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }
    
    public void setDateConsultation(Timestamp dateConsultation) {
        this.dateConsultation = dateConsultation;
    }
    
    public void setSymptomes(String symptomes) {
        this.symptomes = symptomes;
    }
    
    public void setDiagnostic(String diagnostic) {
        this.diagnostic = diagnostic;
    }
    
    public void setPrescription(String prescription) {
        this.prescription = prescription;
    }
    
    public void setNotesMedicales(String notesMedicales) {
        this.notesMedicales = notesMedicales;
    }
    
    public void setDureeConsultation(int dureeConsultation) {
        this.dureeConsultation = dureeConsultation;
    }
    
    public void setStatut(String statut) {
        this.statut = statut;
    }
    
    public void setNomPatient(String nomPatient) {
        this.nomPatient = nomPatient;
    }
    
    public void setPrenomPatient(String prenomPatient) {
        this.prenomPatient = prenomPatient;
    }
    
    public void setNomMedecin(String nomMedecin) {
        this.nomMedecin = nomMedecin;
    }
    
    public void setPrenomMedecin(String prenomMedecin) {
        this.prenomMedecin = prenomMedecin;
    }
    
    public void setNumeroTicket(String numeroTicket) {
        this.numeroTicket = numeroTicket;
    }
    
   
    
    public boolean estTerminee() {
        return "terminee".equals(statut);
    }
    
    public boolean estEnCours() {
        return "en_cours".equals(statut);
    }
    
    @Override
    public String toString() {
        return "Consultation{" +
                "id=" + id +
                ", codeConsultation='" + codeConsultation + '\'' +
                ", ticket='" + numeroTicket + '\'' +
                ", patient='" + prenomPatient + " " + nomPatient + '\'' +
                ", medecin='Dr. " + prenomMedecin + " " + nomMedecin + '\'' +
                ", diagnostic='" + diagnostic + '\'' +
                ", statut='" + statut + '\'' +
                '}';
    }
}