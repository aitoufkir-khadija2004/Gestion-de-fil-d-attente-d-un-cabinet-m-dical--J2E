package beans;

public class Administrateur extends User {
	private String niveau;
	public Administrateur() {
        super();
        this.role = "ADMIN";
    }
	public Administrateur(String nom, String prenom, String email, String telephone, String niveau) {
        super(nom, prenom, email, telephone, "ADMIN");
        this.niveau = niveau;
    }
	public String getNiveau() {
        return niveau;
	}
	 public void setNiveau(String niveau) {
	        this.niveau = niveau;
	    }
	 
	  @Override
	    public String toString() {
	        return "Administrateur{" +
	                "id=" + id +
	                ", codeUser='" + codeUser + '\'' +
	                ", nom='" + nom + '\'' +
	                ", prenom='" + prenom + '\'' +
	                ", email='" + email + '\'' +
	                ", niveau='" + niveau + '\'' +
	                '}';
	    }
	 
        
	

}
