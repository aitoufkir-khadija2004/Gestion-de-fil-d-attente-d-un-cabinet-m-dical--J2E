package beans;

public class Secretaire extends User{
	 private String service;
	 public Secretaire() {
		 super();
		 this.role = "SECRETAIRE";
	 }
	 
	 public Secretaire(String nom, String prenom, String email, String telephone, String service) {
	        super(nom, prenom, email, telephone, "SECRETAIRE");
	        this.service = service;
	    } 
	 public String getService() {
	        return service;
	    }
	 public void setService(String service) {
	        this.service = service;
	    }
	 
	 @Override
	    public String toString() {
	        return "Secretaire{" +
	                "id=" + id +
	                ", codeUser='" + codeUser + '\'' +
	                ", nom='" + nom + '\'' +
	                ", prenom='" + prenom + '\'' +
	                ", email='" + email + '\'' +
	                ", service='" + service + '\'' +
	                '}';
	    }

}
