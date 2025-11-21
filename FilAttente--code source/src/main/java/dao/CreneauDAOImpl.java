package dao;

import beans.Creneau;
import com.JDBC.MYSQL.TestConnectionJDBC;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CreneauDAOImpl implements CreneauDAO {
    
	@Override
	public List<Creneau> getCreneauxDisponibles() {
	    List<Creneau> creneaux = new ArrayList<>();
	    
	    String sql = "SELECT * FROM creneau " +
	                 "WHERE disponible = TRUE " +
	                 "AND date >= CURDATE() " +
	                 "AND tickets_pris < capacite " +
	                 "ORDER BY date, heure_debut";
	    
	    try (Connection conn = TestConnectionJDBC.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {
	        
	        while (rs.next()) {
	            Creneau creneau = new Creneau();
	            creneau.setId(rs.getInt("id"));
	            creneau.setCodeCreneau(rs.getString("code_creneau"));
	            creneau.setMedecinId(rs.getInt("medecin_id"));
	            creneau.setDate(rs.getDate("date"));
	            creneau.setHeureDebut(rs.getTime("heure_debut"));
	            creneau.setHeureFin(rs.getTime("heure_fin"));
	            creneau.setCapacite(rs.getInt("capacite"));
	            creneau.setTicketsPris(rs.getInt("tickets_pris"));
	            creneau.setDisponible(rs.getBoolean("disponible"));
	            
	            creneaux.add(creneau);
	        }
	        
	        System.out.println(+ creneaux.size() + " créneau(x) disponible(s) trouvé(s)");
	        
	    } catch (SQLException e) {
	        System.err.println(" ERREUR getCreneauxDisponibles(): " + e.getMessage());
	        e.printStackTrace();
	    }
	    
	    return creneaux;
	}
    @Override
    public List<Creneau> getCreneauxByMedecin(int medecinId) {
        List<Creneau> creneaux = new ArrayList<>();
        String sql = "SELECT * FROM creneau WHERE medecin_id = ? ORDER BY date, heure_debut";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, medecinId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                creneaux.add(createCreneauFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Erreur getCreneauxByMedecin : " + e.getMessage());
            e.printStackTrace();
        }
        
        return creneaux;
    }
    
    @Override
    public Creneau getCreneauById(int id) {
        String sql = "SELECT * FROM creneau WHERE id = ?";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return createCreneauFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Erreur getCreneauById : " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    @Override
    public boolean creerCreneau(Creneau creneau) {
        String sql = "INSERT INTO creneau (code_creneau, medecin_id, date, heure_debut, heure_fin, capacite) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            String codeCreneau = genererCodeCreneau();
            creneau.setCodeCreneau(codeCreneau);
            
            ps.setString(1, codeCreneau);
            ps.setInt(2, creneau.getMedecinId());
            ps.setDate(3, creneau.getDate());
            ps.setTime(4, creneau.getHeureDebut());
            ps.setTime(5, creneau.getHeureFin());
            ps.setInt(6, creneau.getCapacite());
            
            int rows = ps.executeUpdate();
            
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    creneau.setId(rs.getInt(1));
                }
                System.out.println("Créneau créé : " + codeCreneau);
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Erreur creerCreneau : " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    @Override
    public boolean updateCreneau(Creneau creneau) {
        String sql = "UPDATE creneau SET date = ?, heure_debut = ?, heure_fin = ?, capacite = ? WHERE id = ?";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setDate(1, creneau.getDate());
            ps.setTime(2, creneau.getHeureDebut());
            ps.setTime(3, creneau.getHeureFin());
            ps.setInt(4, creneau.getCapacite());
            ps.setInt(5, creneau.getId());
            
            int rows = ps.executeUpdate();
            return rows > 0;
            
        } catch (SQLException e) {
            System.err.println("Erreur updateCreneau : " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    @Override
    public boolean incrementerTicketsPris(int creneauId) {
        String sql = "UPDATE creneau SET tickets_pris = tickets_pris + 1, " +
                     "disponible = CASE WHEN (tickets_pris + 1) >= capacite THEN FALSE ELSE TRUE END " +
                     "WHERE id = ?";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, creneauId);
            int rows = ps.executeUpdate();
            
            if (rows > 0) {
                System.out.println("Tickets pris incrémenté pour créneau : " + creneauId);
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Erreur incrementerTicketsPris : " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    @Override
    public boolean deleteCreneau(int id) {
        String sql = "UPDATE creneau SET disponible = FALSE WHERE id = ?";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            
            if (rows > 0) {
                System.out.println("Créneau désactivé : " + id);
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Erreur deleteCreneau : " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    private Creneau createCreneauFromResultSet(ResultSet rs) throws SQLException {
        Creneau creneau = new Creneau();
        creneau.setId(rs.getInt("id"));
        creneau.setCodeCreneau(rs.getString("code_creneau"));
        creneau.setMedecinId(rs.getInt("medecin_id"));
        creneau.setDate(rs.getDate("date"));
        creneau.setHeureDebut(rs.getTime("heure_debut"));
        creneau.setHeureFin(rs.getTime("heure_fin"));
        creneau.setCapacite(rs.getInt("capacite"));
        creneau.setTicketsPris(rs.getInt("tickets_pris"));
        creneau.setDisponible(rs.getBoolean("disponible"));
        creneau.setCreatedAt(rs.getTimestamp("created_at"));
        return creneau;
    }
    
    private String genererCodeCreneau() {
        String sql = "SELECT COUNT(*) AS count FROM creneau WHERE DATE(created_at) = CURDATE()";
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int count = rs.getInt("count") + 1;
                return String.format("CRE-%s-%04d", 
                    new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date()), 
                    count);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "CRE-" + new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date()) + "-0001";
    }
    
    
    @Override
    public List<Creneau> getAllCreneaux() {
        List<Creneau> creneaux = new ArrayList<>();
        String sql = "SELECT * FROM creneau ORDER BY date DESC, heure_debut DESC";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Creneau creneau = new Creneau();
                creneau.setId(rs.getInt("id"));
                creneau.setCodeCreneau(rs.getString("code_creneau"));
                creneau.setMedecinId(rs.getInt("medecin_id"));
                creneau.setDate(rs.getDate("date"));
                creneau.setHeureDebut(rs.getTime("heure_debut"));
                creneau.setHeureFin(rs.getTime("heure_fin"));
                creneau.setCapacite(rs.getInt("capacite"));
                creneau.setTicketsPris(rs.getInt("tickets_pris"));
                creneau.setDisponible(rs.getBoolean("disponible"));
                creneaux.add(creneau);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return creneaux;
    }
}