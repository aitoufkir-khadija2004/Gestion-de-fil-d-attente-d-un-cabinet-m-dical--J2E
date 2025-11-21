package dao;

import beans.Consultation;
import com.JDBC.MYSQL.TestConnectionJDBC;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ConsultationDAOImpl implements ConsultationDAO {
    
    @Override
    public boolean creerConsultation(Consultation consultation) {
        String sql = "INSERT INTO consultation (code_consultation, ticket_id, medecin_id, patient_id, " +
                     "symptomes, statut) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            String codeConsultation = genererCodeConsultation();
            consultation.setCodeConsultation(codeConsultation);
            
            ps.setString(1, codeConsultation);
            ps.setInt(2, consultation.getTicketId());
            ps.setInt(3, consultation.getMedecinId());
            ps.setInt(4, consultation.getPatientId());
            ps.setString(5, consultation.getSymptomes());
            ps.setString(6, consultation.getStatut());
            
            int rows = ps.executeUpdate();
            
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    consultation.setId(rs.getInt(1));
                }
                
                // Mettre à jour le statut du ticket à "appele"
                TicketDAO ticketDAO = DAOFactory.getInstance().getTicketDAO();
                ticketDAO.updateStatut(consultation.getTicketId(), "appele");
                
                System.out.println("Consultation créée : " + codeConsultation);
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Erreur creerConsultation : " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    @Override
    public Consultation getConsultationById(int id) {
        String sql = "SELECT * FROM consultation WHERE id = ?";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return createConsultationFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Erreur getConsultationById : " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    @Override
    public Consultation getConsultationByTicket(int ticketId) {
        String sql = "SELECT * FROM consultation WHERE ticket_id = ?";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, ticketId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return createConsultationFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Erreur getConsultationByTicket : " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    @Override
    public List<Consultation> getConsultationsByPatient(int patientId) {
        List<Consultation> consultations = new ArrayList<>();
        String sql = "SELECT * FROM consultation WHERE patient_id = ? ORDER BY date_consultation DESC";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                consultations.add(createConsultationFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Erreur getConsultationsByPatient : " + e.getMessage());
            e.printStackTrace();
        }
        
        return consultations;
    }
    
    @Override
    public List<Consultation> getConsultationsByMedecin(int medecinId) {
        List<Consultation> consultations = new ArrayList<>();
        String sql = "SELECT * FROM consultation WHERE medecin_id = ? ORDER BY date_consultation DESC";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, medecinId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                consultations.add(createConsultationFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Erreur getConsultationsByMedecin : " + e.getMessage());
            e.printStackTrace();
        }
        
        return consultations;
    }
    
    @Override
    public boolean updateConsultation(Consultation consultation) {
        String sql = "UPDATE consultation SET " +
                     "symptomes = ?, " +
                     "diagnostic = ?, " +
                     "prescription = ?, " +
                     "notes_medicales = ?, " +
                     "duree_consultation = ?, " +
                     "statut = ? " +
                     "WHERE id = ?";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, consultation.getSymptomes());
            ps.setString(2, consultation.getDiagnostic());
            ps.setString(3, consultation.getPrescription());
            ps.setString(4, consultation.getNotesMedicales());
            ps.setInt(5, consultation.getDureeConsultation());
            ps.setString(6, consultation.getStatut());
            ps.setInt(7, consultation.getId());
            
            int result = ps.executeUpdate();
            
            System.out.println(" Consultation " + consultation.getId() + " mise à jour : " + 
                               (result > 0 ? "OK" : "ÉCHEC"));
            
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println(" ERREUR updateConsultation(): " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    @Override
    public boolean terminerConsultation(int consultationId) {
        String sql = "UPDATE consultation SET statut = 'terminee' WHERE id = ?";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, consultationId);
            int rows = ps.executeUpdate();
            
            if (rows > 0) {
                // Mettre à jour le statut du ticket à "termine"
                Consultation consultation = getConsultationById(consultationId);
                if (consultation != null) {
                    TicketDAO ticketDAO = DAOFactory.getInstance().getTicketDAO();
                    ticketDAO.updateStatut(consultation.getTicketId(), "termine");
                }
                
                System.out.println("Consultation terminée : " + consultationId);
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Erreur terminerConsultation : " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    @Override
    public boolean ajouterDiagnostic(int consultationId, String diagnostic) {
        String sql = "UPDATE consultation SET diagnostic = ? WHERE id = ?";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, diagnostic);
            ps.setInt(2, consultationId);
            
            int rows = ps.executeUpdate();
            
            if (rows > 0) {
                System.out.println("Diagnostic ajouté pour consultation : " + consultationId);
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Erreur ajouterDiagnostic : " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    @Override
    public boolean ajouterPrescription(int consultationId, String prescription) {
        String sql = "UPDATE consultation SET prescription = ? WHERE id = ?";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, prescription);
            ps.setInt(2, consultationId);
            
            int rows = ps.executeUpdate();
            
            if (rows > 0) {
                System.out.println("Prescription ajoutée pour consultation : " + consultationId);
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Erreur ajouterPrescription : " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    private Consultation createConsultationFromResultSet(ResultSet rs) throws SQLException {
        Consultation consultation = new Consultation();
        consultation.setId(rs.getInt("id"));
        consultation.setCodeConsultation(rs.getString("code_consultation"));
        consultation.setTicketId(rs.getInt("ticket_id"));
        consultation.setMedecinId(rs.getInt("medecin_id"));
        consultation.setPatientId(rs.getInt("patient_id"));
        consultation.setDateConsultation(rs.getTimestamp("date_consultation"));
        consultation.setSymptomes(rs.getString("symptomes"));
        consultation.setDiagnostic(rs.getString("diagnostic"));
        consultation.setPrescription(rs.getString("prescription"));
        consultation.setNotesMedicales(rs.getString("notes_medicales"));
        consultation.setDureeConsultation(rs.getInt("duree_consultation"));
        consultation.setStatut(rs.getString("statut"));
        return consultation;
    }
    
    private String genererCodeConsultation() {
        String sql = "SELECT COUNT(*) AS count FROM consultation WHERE DATE(date_consultation) = CURDATE()";
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int count = rs.getInt("count") + 1;
                return String.format("CON-%s-%04d", 
                    new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date()), 
                    count);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "CON-" + new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date()) + "-0001";
    }
    
    
    
    @Override
    public List<Consultation> getConsultationsByMedecinId(int medecinId) {
        List<Consultation> consultations = new ArrayList<>();
        String sql = "SELECT * FROM consultation WHERE medecin_id = ? ORDER BY date_consultation DESC";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, medecinId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Consultation consultation = new Consultation();
                    consultation.setId(rs.getInt("id"));
                    consultation.setCodeConsultation(rs.getString("code_consultation"));
                    consultation.setTicketId(rs.getInt("ticket_id"));
                    consultation.setMedecinId(rs.getInt("medecin_id"));
                    consultation.setPatientId(rs.getInt("patient_id"));
                    consultation.setDateConsultation(rs.getTimestamp("date_consultation"));
                    consultation.setSymptomes(rs.getString("symptomes"));
                    consultation.setDiagnostic(rs.getString("diagnostic"));
                    consultation.setPrescription(rs.getString("prescription"));
                    consultation.setNotesMedicales(rs.getString("notes_medicales"));
                    consultation.setDureeConsultation(rs.getInt("duree_consultation"));
                    consultation.setStatut(rs.getString("statut"));
                    
                    consultations.add(consultation);
                }
            }
            
            System.out.println(+ consultations.size() + " consultation(s) trouvée(s) pour le médecin #" + medecinId);
            
        } catch (SQLException e) {
            System.err.println(" ERREUR getConsultationsByMedecinId(): " + e.getMessage());
            e.printStackTrace();
        }
        
        return consultations;
    }
    @Override
    public int countConsultationsByPatientAndMedecin(int patientId, int medecinId) {
        String sql = "SELECT COUNT(*) FROM consultation WHERE patient_id = ? AND medecin_id = ?";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, patientId);
            ps.setInt(2, medecinId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("❌ ERREUR countConsultationsByPatientAndMedecin(): " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    @Override
    public List<Consultation> getAllConsultations() {
        List<Consultation> consultations = new ArrayList<>();
        
        String sql = "SELECT * FROM consultation ORDER BY date_consultation DESC";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Consultation consultation = new Consultation();
                consultation.setId(rs.getInt("id"));
                consultation.setTicketId(rs.getInt("ticket_id"));
                consultation.setMedecinId(rs.getInt("medecin_id"));
                consultation.setPatientId(rs.getInt("patient_id"));
                consultation.setDateConsultation(rs.getTimestamp("date_consultation"));
                consultation.setSymptomes(rs.getString("symptomes"));
                consultation.setDiagnostic(rs.getString("diagnostic"));
                consultation.setPrescription(rs.getString("prescription"));
                consultation.setNotesMedicales(rs.getString("notes_medicales"));
                consultation.setDureeConsultation(rs.getInt("duree_consultation"));
                consultation.setStatut(rs.getString("statut"));
                
                consultations.add(consultation);
            }
            
            System.out.println(+ consultations.size() + " consultation(s) trouvée(s)");
            
        } catch (SQLException e) {
            System.err.println("ERREUR getAllConsultations(): " + e.getMessage());
            e.printStackTrace();
        }
        
        return consultations;
    }
}