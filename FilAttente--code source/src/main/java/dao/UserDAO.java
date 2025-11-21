package dao;

import beans.*;
import java.util.List;

public interface UserDAO {
    User login(String email, String password);
    User getUserById(int id);
    List<Patient> getAllPatients();
    List<Medecin> getAllMedecins();
    List<Medecin> getMedecinsBySpecialite(int specialiteId);
    boolean creerPatient(Patient patient);
    boolean creerMedecin(Medecin medecin);
    boolean creerSecretaire(Secretaire secretaire);
    boolean creerAdministrateur(Administrateur admin);
    boolean updatePatient(Patient patient);
    boolean deleteUser(int userId);
    Patient getPatientById(int id);
    List<Patient> getPatientsConsultesByMedecin(int medecinId);
    List<Secretaire> getAllSecretaires();
    boolean activerUtilisateur(int userId);
    boolean desactiverUtilisateur(int userId);
    Medecin getMedecinById(int id);
    Secretaire getSecretaireById(int id);
    
    boolean updateMedecin(Medecin medecin);
    boolean updateSecretaire(Secretaire secretaire);



}