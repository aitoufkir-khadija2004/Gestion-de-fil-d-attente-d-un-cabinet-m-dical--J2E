package beans;

import java.sql.Timestamp;

public abstract class User {
	protected int id;
    protected String codeUser;
    protected String nom;
    protected String prenom;
    protected String email;
    protected String password;
    protected String telephone;
    protected String role;
    protected boolean actif;
    protected Timestamp createdAt;
    
   
    public User() {
    	 this.actif = true;
    }
    
   
    public User(String nom, String prenom, String email, String telephone, String role) {
        this.nom = nom;
        this.prenom = prenom;
        this.email = email;
        this.telephone = telephone;
        this.role = role;
        this.actif = true;
    }
    
    public int getId() { 
    	return id;
    }
   
    public String getCodeUser() {
        return codeUser;
    }
    
    public String getNom() {
        return nom;
    }
    
    public String getPrenom() {
        return prenom;
    }
    
    public String getEmail() {
        return email;
    }
    
    public String getPassword() {
        return password;
    }
    
    public String getTelephone() {
        return telephone;
    }
    
    public String getRole() {
        return role;
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
    public void setCodeUser(String codeUser) {
        this.codeUser = codeUser;
    }
    
    public void setNom(String nom) {
        this.nom = nom;
    }
    
    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }
    
    public void setRole(String role) {
        this.role = role;
    }
    
    public void setActif(boolean actif) {
        this.actif = actif;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
  
    public String getNomComplet() {
        return prenom + " " + nom;
    }
   
    @Override
    public String toString() {
        return "User{" +
                "id =" + id +'\'' +
                ", codeUser='" + codeUser + '\'' +
                ", nom='" + nom + '\'' +
                ", prenom='" + prenom + '\'' +
                ", email='" + email + '\'' +
                ", role='" + role + '\'' +
                ", actif=" + actif +
                '}';
    }
}