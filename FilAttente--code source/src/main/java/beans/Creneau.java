package beans;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

public class Creneau {
	   private int id;                    
	    private String codeCreneau;        
	    private int medecinId;             
	    private Date date;                 
	    private Time heureDebut;           
	    private Time heureFin;             
	    private int capacite;              
	    private int ticketsPris;           
	    private boolean disponible;        
	    private Timestamp createdAt;
	    
	    // pour affichage 
	    private String nomMedecin;         
	    private String prenomMedecin;      
	    private String specialite; 
	    
	    public Creneau() {
	        this.capacite = 10;         // par défaut
	        this.ticketsPris = 0;       
	        this.disponible = true;    
	    }
	    
	    public Creneau(int medecinId, Date date, Time heureDebut, Time heureFin, int capacite) {
	        this.medecinId = medecinId;
	        this.date = date;
	        this.heureDebut = heureDebut;
	        this.heureFin = heureFin;
	        this.capacite = capacite;
	        this.ticketsPris = 0;
	        this.disponible = true;
	    }
	    
	    
	    public int getId() {
	        return id;
	    }
	    
	    public String getCodeCreneau() {
	        return codeCreneau;
	    }
	    
	    public int getMedecinId() {
	        return medecinId;
	    }
	    
	    public Date getDate() {
	        return date;
	    }
	    
	    public Time getHeureDebut() {
	        return heureDebut;
	    }
	    
	    public Time getHeureFin() {
	        return heureFin;
	    }
	    
	    public int getCapacite() {
	        return capacite;
	    }
	    
	    public int getTicketsPris() {
	        return ticketsPris;
	    }
	    
	    public boolean isDisponible() {
	        return disponible;
	    }
	    
	    public Timestamp getCreatedAt() {
	        return createdAt;
	    }
	    
	    public String getNomMedecin() {
	        return nomMedecin;
	    }
	    
	    public String getPrenomMedecin() {
	        return prenomMedecin;
	    }
	    
	    public String getSpecialite() {
	        return specialite;
	    }
	    
	    
	    public void setId(int id) {
	        this.id = id;
	    }
	    
	    public void setCodeCreneau(String codeCreneau) {
	        this.codeCreneau = codeCreneau;
	    }
	    
	    public void setMedecinId(int medecinId) {
	        this.medecinId = medecinId;
	    }
	    
	    public void setDate(Date date) {
	        this.date = date;
	    }
	    
	    public void setHeureDebut(Time heureDebut) {
	        this.heureDebut = heureDebut;
	    }
	    
	    public void setHeureFin(Time heureFin) {
	        this.heureFin = heureFin;
	    }
	    
	    public void setCapacite(int capacite) {
	        this.capacite = capacite;
	    }
	    
	    public void setTicketsPris(int ticketsPris) {
	        this.ticketsPris = ticketsPris;
	    }
	    
	    public void setDisponible(boolean disponible) {
	        this.disponible = disponible;
	    }
	    
	    public void setCreatedAt(Timestamp createdAt) {
	        this.createdAt = createdAt;
	    }
	    
	    public void setNomMedecin(String nomMedecin) {
	        this.nomMedecin = nomMedecin;
	    }
	    
	    public void setPrenomMedecin(String prenomMedecin) {
	        this.prenomMedecin = prenomMedecin;
	    }
	    
	    public void setSpecialite(String specialite) {
	        this.specialite = specialite;
	    } 
	    
	    public int getPlacesRestantes() {
	        return capacite - ticketsPris;
	    }
	    
	    public boolean estComplet() {
	        return ticketsPris >= capacite;
	    }
	    
	    @Override
	    public String toString() {
	        return "Creneau{" +
	                "id=" + id +
	                ", codeCreneau='" + codeCreneau + '\'' +
	                ", date=" + date +
	                ", heureDebut=" + heureDebut +
	                ", heureFin=" + heureFin +
	                ", capacite=" + capacite +
	                ", ticketsPris=" + ticketsPris +
	                ", placesRestantes=" + getPlacesRestantes() +
	                ", medecin='Dr. " + prenomMedecin + " " + nomMedecin + '\'' +
	                '}';
	    }
	    
	    
	    
	    
	    
	    
	    
	    
	   

}
