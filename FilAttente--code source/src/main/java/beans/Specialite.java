package beans;
import java.sql.Timestamp;


public class Specialite {
	    private int id;                    
	    private String codeSpecialite;    
	    private String nom;                
	    private String description;        
	    private boolean actif;            
	    private Timestamp createdAt; 
	    
	    public Specialite() {
	        this.actif = true; }
	    
	    public Specialite(String nom, String description) {
	        this.nom = nom;
	        this.description = description;
	        this.actif = true;
	    }
	    
	    public int getId() {
	        return id;
	    }
	    
	    public String getCodeSpecialite() {
	        return codeSpecialite;
	    }
	    
	    public String getNom() {
	        return nom;
	    }
	    
	    public String getDescription() {
	        return description;
	    }
	    
	    public boolean isActif() {
	        return actif;
	    }
	    
	    public Timestamp getCreatedAt() {
	        return createdAt;
	    }
	    
	    
	    
	    public void setId(int id) {
	        this.id = id;
	    }
	    
	    public void setCodeSpecialite(String codeSpecialite) {
	        this.codeSpecialite = codeSpecialite;
	    }
	    
	    public void setNom(String nom) {
	        this.nom = nom;
	    }
	    
	    public void setDescription(String description) {
	        this.description = description;
	    }
	    
	    public void setActif(boolean actif) {
	        this.actif = actif;
	    }
	    
	    public void setCreatedAt(Timestamp createdAt) {
	        this.createdAt = createdAt;
	    }
	    
	    @Override
	    public String toString() {
	        return "Specialite{" +
	                "id=" + id +
	                ", codeSpecialite='" + codeSpecialite + '\'' +
	                ", nom='" + nom + '\'' +
	                ", description='" + description + '\'' +
	                ", actif=" + actif +
	                '}';
	    }

	    
	    
	    
	    
	    
	    
	    
 
}
