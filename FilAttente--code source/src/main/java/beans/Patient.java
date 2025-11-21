package beans;

import java.sql.Date;

public class Patient extends User {
    
    private String numeroSecuriteSociale;
    private Date dateNaissance;
    private String adresse;
    private String groupeSanguin;
    
    
    public Patient() {
        super();
        this.role = "PATIENT";
    }
    
 
    public Patient(String nom, String prenom, String email, String telephone,
                   String nss, Date dateNaissance, String adresse, String groupeSanguin) {
        super(nom, prenom, email, telephone, "PATIENT");
        this.numeroSecuriteSociale = nss;
        this.dateNaissance = dateNaissance;
        this.adresse = adresse;
        this.groupeSanguin = groupeSanguin;
    }
    
    
    public String getNumeroSecuriteSociale() {
        return numeroSecuriteSociale;
    }
    
    public Date getDateNaissance() {
        return dateNaissance;
    }
    
    public String getAdresse() {
        return adresse;
    }
    
    public String getGroupeSanguin() {
        return groupeSanguin;
    }
    
    
    public void setNumeroSecuriteSociale(String numeroSecuriteSociale) {
        this.numeroSecuriteSociale = numeroSecuriteSociale;
    }
    
    public void setDateNaissance(Date dateNaissance) {
        this.dateNaissance = dateNaissance;
    }
    
    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }
    
    public void setGroupeSanguin(String groupeSanguin) {
        this.groupeSanguin = groupeSanguin;
    }

    public int calculerAge() {
        if (dateNaissance == null) return 0;
        
        java.util.Calendar aujourdhui = java.util.Calendar.getInstance();
        java.util.Calendar naissance = java.util.Calendar.getInstance();
        naissance.setTime(dateNaissance);
        
        int age = aujourdhui.get(java.util.Calendar.YEAR) - 
                  naissance.get(java.util.Calendar.YEAR);
        
        // Ajuster si l'anniversaire n'est pas encore passé cette année
        if (aujourdhui.get(java.util.Calendar.DAY_OF_YEAR) < 
            naissance.get(java.util.Calendar.DAY_OF_YEAR)) {
            age--;
        }
        
        return age;
    }
    
    @Override
    public String toString() {
        return "Patient{"  +
                ", codeUser='" + codeUser + '\'' +
                ", nom='" + nom + '\'' +
                ", prenom='" + prenom + '\'' +
                ", email='" + email + '\'' +
                ", nss='" + numeroSecuriteSociale + '\'' +
                ", age=" + calculerAge() + " ans" +
                '}';
    }
}