package dao;

import beans.*;
import com.JDBC.MYSQL.TestConnectionJDBC;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAOImpl implements UserDAO {
    
    @Override
    public User login(String email, String password) {
        String sql = "SELECT * FROM user WHERE email = ? AND password = ? AND actif = TRUE";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ps.setString(2, password);
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                String role = rs.getString("role");
                
                if ("PATIENT".equals(role)) {
                    return createPatientFromResultSet(rs);
                } else if ("MEDECIN".equals(role)) {
                    return createMedecinFromResultSet(rs);
                } else if ("SECRETAIRE".equals(role)) {
                    return createSecretaireFromResultSet(rs);
                } else if ("ADMIN".equals(role)) {
                    return createAdministrateurFromResultSet(rs);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Erreur login : " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;  
    }
  
    @Override
    public User getUserById(int id) {
        String sql = "SELECT * FROM user WHERE id = ?";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                String role = rs.getString("role");
                
                if ("PATIENT".equals(role)) {
                    return createPatientFromResultSet(rs);
                } else if ("MEDECIN".equals(role)) {
                    return createMedecinFromResultSet(rs);
                } else if ("SECRETAIRE".equals(role)) {
                    return createSecretaireFromResultSet(rs);
                } else if ("ADMIN".equals(role)) {
                    return createAdministrateurFromResultSet(rs);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Erreur getUserById : " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    @Override
    public List<Patient> getAllPatients() {
        List<Patient> patients = new ArrayList<>();
        
        String sql = "SELECT * FROM user WHERE role = 'PATIENT' ORDER BY actif DESC, nom, prenom";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Patient patient = new Patient();
                patient.setId(rs.getInt("id"));
                patient.setCodeUser(rs.getString("code_user"));
                patient.setNom(rs.getString("nom"));
                patient.setPrenom(rs.getString("prenom"));
                patient.setEmail(rs.getString("email"));
                patient.setTelephone(rs.getString("telephone"));
                patient.setRole(rs.getString("role"));
                patient.setDateNaissance(rs.getDate("date_naissance"));
                patient.setAdresse(rs.getString("adresse"));
                patient.setNumeroSecuriteSociale(rs.getString("numero_securite_sociale"));
                patient.setGroupeSanguin(rs.getString("groupe_sanguin"));
                patient.setActif(rs.getBoolean("actif"));  
                
                patients.add(patient);
            }
            
            System.out.println(+ patients.size() + " patient(s) trouvé(s) (actifs + inactifs)");
            
        } catch (SQLException e) {
            System.err.println("ERREUR getAllPatients(): " + e.getMessage());
            e.printStackTrace();
        }
        
        return patients;
    }
    
    @Override
    public List<Medecin> getAllMedecins() {
        List<Medecin> medecins = new ArrayList<>();
        
        String sql = "SELECT u.*, s.nom AS nom_specialite " +
                     "FROM user u " +
                     "LEFT JOIN specialite s ON u.specialite_id = s.id " +
                     "WHERE u.role = 'MEDECIN' " +
                     "ORDER BY u.actif DESC, u.nom, u.prenom";  
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Medecin medecin = new Medecin();
                medecin.setId(rs.getInt("id"));
                medecin.setCodeUser(rs.getString("code_user"));
                medecin.setNom(rs.getString("nom"));
                medecin.setPrenom(rs.getString("prenom"));
                medecin.setEmail(rs.getString("email"));
                medecin.setTelephone(rs.getString("telephone"));
                medecin.setRole(rs.getString("role"));
                medecin.setSpecialiteId(rs.getInt("specialite_id"));
                medecin.setNomSpecialite(rs.getString("nom_specialite"));
                medecin.setNumeroOrdre(rs.getString("numero_ordre"));
                medecin.setActif(rs.getBoolean("actif"));  
                
                medecins.add(medecin);
            }
            
            System.out.println(+ medecins.size() + " médecin(s) trouvé(s) (actifs + inactifs)");
            
        } catch (SQLException e) {
            System.err.println("ERREUR getAllMedecins(): " + e.getMessage());
            e.printStackTrace();
        }
        
        return medecins;
    }
    
    @Override
    public List<Medecin> getMedecinsBySpecialite(int specialiteId) {
        List<Medecin> medecins = new ArrayList<>();
        String sql = "SELECT u.*, s.nom AS specialite_nom " +
                     "FROM user u " +
                     "LEFT JOIN specialite s ON u.specialite_id = s.id " +
                     "WHERE u.role = 'MEDECIN' AND u.specialite_id = ? AND u.actif = TRUE " +
                     "ORDER BY u.nom, u.prenom";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, specialiteId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Medecin medecin = createMedecinFromResultSet(rs);
                medecin.setNomSpecialite(rs.getString("specialite_nom"));
                medecins.add(medecin);
            }
            
        } catch (SQLException e) {
            System.err.println("Erreur getMedecinsBySpecialite : " + e.getMessage());
            e.printStackTrace();
        }
        
        return medecins;
    }
    
    @Override
    public boolean creerPatient(Patient patient) {
        String sql = "INSERT INTO user (code_user, nom, prenom, email, password, " +
                     "telephone, role, numero_securite_sociale, date_naissance, " +
                     "adresse, groupe_sanguin) " +
                     "VALUES (?, ?, ?, ?, ?, ?, 'PATIENT', ?, ?, ?, ?)";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            String codePatient = genererCodePatient();
            patient.setCodeUser(codePatient);
            
            ps.setString(1, codePatient);
            ps.setString(2, patient.getNom());
            ps.setString(3, patient.getPrenom());
            ps.setString(4, patient.getEmail());
            ps.setString(5, patient.getPassword());
            ps.setString(6, patient.getTelephone());
            ps.setString(7, patient.getNumeroSecuriteSociale());
            ps.setDate(8, patient.getDateNaissance());
            ps.setString(9, patient.getAdresse());
            ps.setString(10, patient.getGroupeSanguin());
            
            int rows = ps.executeUpdate();
            
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    patient.setId(rs.getInt(1));
                }
                System.out.println("Patient créé : " + codePatient);
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Erreur creerPatient : " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    @Override
    public boolean creerMedecin(Medecin medecin) {
        String sql = "INSERT INTO user (code_user, nom, prenom, email, password, " +
                     "telephone, role, specialite_id, numero_ordre) " +
                     "VALUES (?, ?, ?, ?, ?, ?, 'MEDECIN', ?, ?)";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            String codeMedecin = genererCodeMedecin();
            medecin.setCodeUser(codeMedecin);
            
            ps.setString(1, codeMedecin);
            ps.setString(2, medecin.getNom());
            ps.setString(3, medecin.getPrenom());
            ps.setString(4, medecin.getEmail());
            ps.setString(5, medecin.getPassword());
            ps.setString(6, medecin.getTelephone());
            ps.setInt(7, medecin.getSpecialiteId());
            ps.setString(8, medecin.getNumeroOrdre());
            
            int rows = ps.executeUpdate();
            
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    medecin.setId(rs.getInt(1));
                }
                System.out.println("Médecin créé : " + codeMedecin);
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Erreur creerMedecin : " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    @Override
    public boolean creerSecretaire(Secretaire secretaire) {
        String sql = "INSERT INTO user (code_user, nom, prenom, email, password, " +
                     "telephone, role, service) " +
                     "VALUES (?, ?, ?, ?, ?, ?, 'SECRETAIRE', ?)";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            String codeSecretaire = genererCodeSecretaire();
            secretaire.setCodeUser(codeSecretaire);
            
            ps.setString(1, codeSecretaire);
            ps.setString(2, secretaire.getNom());
            ps.setString(3, secretaire.getPrenom());
            ps.setString(4, secretaire.getEmail());
            ps.setString(5, secretaire.getPassword());
            ps.setString(6, secretaire.getTelephone());
            ps.setString(7, secretaire.getService());
            
            int rows = ps.executeUpdate();
            
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    secretaire.setId(rs.getInt(1));
                }
                System.out.println("Secrétaire creee: " + codeSecretaire);
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Erreur creerSecretaire : " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    @Override
    public boolean creerAdministrateur(Administrateur admin) {
        String sql = "INSERT INTO user (code_user, nom, prenom, email, password, " +
                     "telephone, role, niveau) " +
                     "VALUES (?, ?, ?, ?, ?, ?, 'ADMIN', ?)";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            String codeAdmin = genererCodeAdmin();
            admin.setCodeUser(codeAdmin);           
            ps.setString(1, codeAdmin);
            ps.setString(2, admin.getNom());
            ps.setString(3, admin.getPrenom());
            ps.setString(4, admin.getEmail());
            ps.setString(5, admin.getPassword());
            ps.setString(6, admin.getTelephone());
            ps.setString(7, admin.getNiveau());
            
            int rows = ps.executeUpdate();
            
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    admin.setId(rs.getInt(1));
                }
                System.out.println("Administrateur créé : " + codeAdmin);
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Erreur creerAdministrateur : " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    @Override
    public boolean updatePatient(Patient patient) {
        String sql = "UPDATE user SET nom = ?, prenom = ?, email = ?, telephone = ?, " +
                     "numero_securite_sociale = ?, date_naissance = ?, adresse = ?, " +
                     "groupe_sanguin = ? WHERE id = ?";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, patient.getNom());
            ps.setString(2, patient.getPrenom());
            ps.setString(3, patient.getEmail());
            ps.setString(4, patient.getTelephone());
            ps.setString(5, patient.getNumeroSecuriteSociale());
            ps.setDate(6, patient.getDateNaissance());
            ps.setString(7, patient.getAdresse());
            ps.setString(8, patient.getGroupeSanguin());
            ps.setInt(9, patient.getId());
            
            int rows = ps.executeUpdate();
            return rows > 0;
            
        } catch (SQLException e) {
            System.err.println(" Erreur updatePatient : " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    @Override
    public boolean deleteUser(int userId) {
        String sql = "UPDATE user SET actif = FALSE WHERE id = ?";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            int rows = ps.executeUpdate();
            
            if (rows > 0) {
                System.out.println("Utilisateur desactivé: " + userId);
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Erreur deleteUser : " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    private Patient createPatientFromResultSet(ResultSet rs) throws SQLException {
        Patient patient = new Patient();
        patient.setId(rs.getInt("id"));
        patient.setCodeUser(rs.getString("code_user"));
        patient.setNom(rs.getString("nom"));
        patient.setPrenom(rs.getString("prenom"));
        patient.setEmail(rs.getString("email"));
        patient.setPassword(rs.getString("password"));
        patient.setTelephone(rs.getString("telephone"));
        patient.setRole(rs.getString("role"));
        patient.setActif(rs.getBoolean("actif"));
        patient.setCreatedAt(rs.getTimestamp("created_at"));
        patient.setNumeroSecuriteSociale(rs.getString("numero_securite_sociale"));
        patient.setDateNaissance(rs.getDate("date_naissance"));
        patient.setAdresse(rs.getString("adresse"));
        patient.setGroupeSanguin(rs.getString("groupe_sanguin"));
        return patient;
    }
    
    private Medecin createMedecinFromResultSet(ResultSet rs) throws SQLException {
        Medecin medecin = new Medecin();
        medecin.setId(rs.getInt("id"));
        medecin.setCodeUser(rs.getString("code_user"));
        medecin.setNom(rs.getString("nom"));
        medecin.setPrenom(rs.getString("prenom"));
        medecin.setEmail(rs.getString("email"));
        medecin.setPassword(rs.getString("password"));
        medecin.setTelephone(rs.getString("telephone"));
        medecin.setRole(rs.getString("role"));
        medecin.setActif(rs.getBoolean("actif"));
        medecin.setCreatedAt(rs.getTimestamp("created_at"));
        medecin.setSpecialiteId(rs.getInt("specialite_id"));
        medecin.setNumeroOrdre(rs.getString("numero_ordre"));
        return medecin;
    }
    
    private Secretaire createSecretaireFromResultSet(ResultSet rs) throws SQLException {
        Secretaire secretaire = new Secretaire();
        secretaire.setId(rs.getInt("id"));
        secretaire.setCodeUser(rs.getString("code_user"));
        secretaire.setNom(rs.getString("nom"));
        secretaire.setPrenom(rs.getString("prenom"));
        secretaire.setEmail(rs.getString("email"));
        secretaire.setPassword(rs.getString("password"));
        secretaire.setTelephone(rs.getString("telephone"));
        secretaire.setRole(rs.getString("role"));
        secretaire.setActif(rs.getBoolean("actif"));
        secretaire.setCreatedAt(rs.getTimestamp("created_at"));
        secretaire.setService(rs.getString("service"));
        return secretaire;
    }
    
    private Administrateur createAdministrateurFromResultSet(ResultSet rs) throws SQLException {
        Administrateur admin = new Administrateur();
        admin.setId(rs.getInt("id"));
        admin.setCodeUser(rs.getString("code_user"));
        admin.setNom(rs.getString("nom"));
        admin.setPrenom(rs.getString("prenom"));
        admin.setEmail(rs.getString("email"));
        admin.setPassword(rs.getString("password"));
        admin.setTelephone(rs.getString("telephone"));
        admin.setRole(rs.getString("role"));
        admin.setActif(rs.getBoolean("actif"));
        admin.setCreatedAt(rs.getTimestamp("created_at"));
        admin.setNiveau(rs.getString("niveau"));
        return admin;
    }
    
    private String genererCodePatient() {
        String sql = "SELECT COUNT(*) AS count FROM user WHERE role = 'PATIENT'";
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int count = rs.getInt("count") + 1;
                return String.format("PAT-%04d", count);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "PAT-0001";
    }
    
    private String genererCodeMedecin() {
        String sql = "SELECT COUNT(*) AS count FROM user WHERE role = 'MEDECIN'";
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int count = rs.getInt("count") + 1;
                return String.format("MED-%04d", count);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "MED-0001";
    }
    
    private String genererCodeSecretaire() {
        String sql = "SELECT COUNT(*) AS count FROM user WHERE role = 'SECRETAIRE'";
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int count = rs.getInt("count") + 1;
                return String.format("SEC-%04d", count);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "SEC-0001";
    }
    
    private String genererCodeAdmin() {
        String sql = "SELECT COUNT(*) AS count FROM user WHERE role = 'ADMIN'";
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int count = rs.getInt("count") + 1;
                return String.format("ADM-%04d", count);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "ADM-0001";
    }
    @Override
    public Patient getPatientById(int id) {
        String sql = "SELECT * FROM user WHERE id = ? AND role = 'PATIENT'";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Patient patient = new Patient();
                    patient.setId(rs.getInt("id"));
                    patient.setCodeUser(rs.getString("code_user"));
                    patient.setNom(rs.getString("nom"));
                    patient.setPrenom(rs.getString("prenom"));
                    patient.setEmail(rs.getString("email"));
                    patient.setTelephone(rs.getString("telephone"));
                    patient.setDateNaissance(rs.getDate("date_naissance"));
                    patient.setAdresse(rs.getString("adresse"));
                    patient.setNumeroSecuriteSociale(rs.getString("numero_securite_sociale"));
                    patient.setGroupeSanguin(rs.getString("groupe_sanguin"));
                    
                    return patient;
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    @Override
    public List<Patient> getPatientsConsultesByMedecin(int medecinId) {
        List<Patient> patients = new ArrayList<>();
        
        String sql = "SELECT DISTINCT u.* FROM user u " +
                     "INNER JOIN consultation c ON u.id = c.patient_id " +
                     "WHERE u.role = 'PATIENT' AND c.medecin_id = ? " +
                     "ORDER BY u.nom, u.prenom";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, medecinId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Patient patient = new Patient();
                    patient.setId(rs.getInt("id"));
                    patient.setCodeUser(rs.getString("code_user"));
                    patient.setNom(rs.getString("nom"));
                    patient.setPrenom(rs.getString("prenom"));
                    patient.setEmail(rs.getString("email"));
                    patient.setTelephone(rs.getString("telephone"));
                    patient.setDateNaissance(rs.getDate("date_naissance"));
                    patient.setAdresse(rs.getString("adresse"));
                    patient.setNumeroSecuriteSociale(rs.getString("numero_securite_sociale"));
                    patient.setGroupeSanguin(rs.getString("groupe_sanguin"));
                    
                    patients.add(patient);
                }
            }
            
            System.out.println( + patients.size() + " patient(s) trouvé(s) pour le médecin #" + medecinId);
            
        } catch (SQLException e) {
            System.err.println(" ERREUR getPatientsConsultesByMedecin(): " + e.getMessage());
            e.printStackTrace();
        }
        
        return patients;
    }
    
    
    @Override
    public List<Secretaire> getAllSecretaires() {
        List<Secretaire> secretaires = new ArrayList<>();
        
        String sql = "SELECT * FROM user WHERE role = 'SECRETAIRE' ORDER BY actif DESC, nom, prenom";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Secretaire secretaire = new Secretaire();
                secretaire.setId(rs.getInt("id"));
                secretaire.setCodeUser(rs.getString("code_user"));
                secretaire.setNom(rs.getString("nom"));
                secretaire.setPrenom(rs.getString("prenom"));
                secretaire.setEmail(rs.getString("email"));
                secretaire.setTelephone(rs.getString("telephone"));
                secretaire.setRole(rs.getString("role"));
                secretaire.setService(rs.getString("service"));
                secretaire.setActif(rs.getBoolean("actif"));  
                
                secretaires.add(secretaire);
            }
            
            System.out.println( + secretaires.size() + " secrétaire(s) trouvée(s) (actifs + inactifs)");
            
        } catch (SQLException e) {
            System.err.println("ERREUR getAllSecretaires(): " + e.getMessage());
            e.printStackTrace();
        }
        
        return secretaires;
    }
    @Override
    public boolean activerUtilisateur(int userId) {
        String sql = "UPDATE user SET actif = TRUE WHERE id = ?";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            
            int result = ps.executeUpdate();
            
            if (result > 0) {
                System.out.println(" Utilisateur #" + userId + " activé");
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println(" ERREUR activerUtilisateur(): " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }

    @Override
    public boolean desactiverUtilisateur(int userId) {
        String sql = "UPDATE user SET actif = FALSE WHERE id = ?";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            
            int result = ps.executeUpdate();
            
            if (result > 0) {
                System.out.println(" Utilisateur #" + userId + " désactivé");
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println(" ERREUR desactiverUtilisateur(): " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }

    @Override
    public Medecin getMedecinById(int id) {
        String sql = "SELECT u.*, s.nom AS nom_specialite " +
                     "FROM user u " +
                     "LEFT JOIN specialite s ON u.specialite_id = s.id " +
                     "WHERE u.id = ? AND u.role = 'MEDECIN'";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Medecin medecin = new Medecin();
                    medecin.setId(rs.getInt("id"));
                    medecin.setCodeUser(rs.getString("code_user"));
                    medecin.setNom(rs.getString("nom"));
                    medecin.setPrenom(rs.getString("prenom"));
                    medecin.setEmail(rs.getString("email"));
                    medecin.setTelephone(rs.getString("telephone"));
                    medecin.setRole(rs.getString("role"));
                    medecin.setSpecialiteId(rs.getInt("specialite_id"));
                    medecin.setNomSpecialite(rs.getString("nom_specialite"));
                    medecin.setNumeroOrdre(rs.getString("numero_ordre"));
                    medecin.setActif(rs.getBoolean("actif"));
                    
                    return medecin;
                }
            }
            
        } catch (SQLException e) {
            System.err.println(" ERREUR getMedecinById(): " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }

    @Override
    public Secretaire getSecretaireById(int id) {
        String sql = "SELECT * FROM user WHERE id = ? AND role = 'SECRETAIRE'";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Secretaire secretaire = new Secretaire();
                    secretaire.setId(rs.getInt("id"));
                    secretaire.setCodeUser(rs.getString("code_user"));
                    secretaire.setNom(rs.getString("nom"));
                    secretaire.setPrenom(rs.getString("prenom"));
                    secretaire.setEmail(rs.getString("email"));
                    secretaire.setTelephone(rs.getString("telephone"));
                    secretaire.setRole(rs.getString("role"));
                    secretaire.setService(rs.getString("service"));
                    secretaire.setActif(rs.getBoolean("actif"));
                    
                    return secretaire;
                }
            }
            
        } catch (SQLException e) {
            System.err.println("ERREUR getSecretaireById(): " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }

    @Override
    public boolean updateMedecin(Medecin medecin) {
        String sql = "UPDATE user SET nom = ?, prenom = ?, email = ?, telephone = ?, " +
                     "specialite_id = ?, numero_ordre = ? WHERE id = ?";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, medecin.getNom());
            ps.setString(2, medecin.getPrenom());
            ps.setString(3, medecin.getEmail());
            ps.setString(4, medecin.getTelephone());
            ps.setInt(5, medecin.getSpecialiteId());
            ps.setString(6, medecin.getNumeroOrdre());
            ps.setInt(7, medecin.getId());
            
            int result = ps.executeUpdate();
            
            if (result > 0) {
                System.out.println("Médecin #" + medecin.getId() + " modifié");
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println(" ERREUR updateMedecin(): " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }

    @Override
    public boolean updateSecretaire(Secretaire secretaire) {
        String sql = "UPDATE user SET nom = ?, prenom = ?, email = ?, telephone = ?, service = ? WHERE id = ?";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, secretaire.getNom());
            ps.setString(2, secretaire.getPrenom());
            ps.setString(3, secretaire.getEmail());
            ps.setString(4, secretaire.getTelephone());
            ps.setString(5, secretaire.getService());
            ps.setInt(6, secretaire.getId());
            
            int result = ps.executeUpdate();
            
            if (result > 0) {
                System.out.println("Secrétaire #" + secretaire.getId() + " modifiée");
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("ERREUR updateSecretaire(): " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
}