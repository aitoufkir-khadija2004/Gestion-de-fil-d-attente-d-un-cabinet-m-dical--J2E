package dao;

import beans.Specialite;
import com.JDBC.MYSQL.TestConnectionJDBC;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SpecialiteDAOImpl implements SpecialiteDAO {
    
    @Override
    public List<Specialite> getAllSpecialites() {
        List<Specialite> specialites = new ArrayList<>();
        String sql = "SELECT * FROM specialite WHERE actif = TRUE ORDER BY nom";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Specialite specialite = new Specialite();
                specialite.setId(rs.getInt("id"));
                specialite.setCodeSpecialite(rs.getString("code_specialite"));
                specialite.setNom(rs.getString("nom"));
                specialite.setDescription(rs.getString("description"));
                specialite.setActif(rs.getBoolean("actif"));
                specialite.setCreatedAt(rs.getTimestamp("created_at"));
                specialites.add(specialite);
            }
            
        } catch (SQLException e) {
            System.err.println("Erreur getAllSpecialites : " + e.getMessage());
            e.printStackTrace();
        }
        
        return specialites;
    }
    
    @Override
    public Specialite getSpecialiteById(int id) {
        String sql = "SELECT * FROM specialite WHERE id = ?";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            // Configurer l'encodage
            try (Statement stmt = conn.createStatement()) {
                stmt.execute("SET NAMES 'utf8mb4'");
            }
            
            ps.setInt(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Specialite specialite = new Specialite();
                    specialite.setId(rs.getInt("id"));
                    specialite.setCodeSpecialite(rs.getString("code_specialite"));
                    specialite.setNom(rs.getString("nom"));
                    specialite.setDescription(rs.getString("description"));
                    
                    return specialite;
                }
            }
            
        } catch (SQLException e) {
            System.err.println(" ERREUR getSpecialiteById(): " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    @Override
    public boolean creerSpecialite(Specialite specialite) {
        String sql = "INSERT INTO specialite (code_specialite, nom, description) VALUES (?, ?, ?)";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            String codeSpecialite = genererCodeSpecialite();
            specialite.setCodeSpecialite(codeSpecialite);
            
            ps.setString(1, codeSpecialite);
            ps.setString(2, specialite.getNom());
            ps.setString(3, specialite.getDescription());
            
            int rows = ps.executeUpdate();
            
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    specialite.setId(rs.getInt(1));
                }
                System.out.println("Spécialité créée : " + codeSpecialite);
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Erreur creerSpecialite : " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    @Override
    public boolean updateSpecialite(Specialite specialite) {
        String sql = "UPDATE specialite SET nom = ?, description = ? WHERE id = ?";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            // Configurer l'encodage
            try (Statement stmt = conn.createStatement()) {
                stmt.execute("SET NAMES 'utf8mb4'");
            }
            
            ps.setString(1, specialite.getNom());
            ps.setString(2, specialite.getDescription());
            ps.setInt(3, specialite.getId());
            
            int result = ps.executeUpdate();
            
            if (result > 0) {
                System.out.println("Spécialité #" + specialite.getId() + " modifiée");
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("ERREUR updateSpecialite(): " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }

    @Override
    public boolean deleteSpecialite(int id) {
        String sql = "DELETE FROM specialite WHERE id = ?";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            
            int result = ps.executeUpdate();
            
            if (result > 0) {
                System.out.println("Spécialité #" + id + " supprimée");
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("ERREUR deleteSpecialite(): " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }

    
    private String genererCodeSpecialite() {
        String sql = "SELECT COUNT(*) AS count FROM specialite";
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int count = rs.getInt("count") + 1;
                return String.format("SPE-%04d", count);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "SPE-0001";
    }
    
    @Override
    public boolean isSpecialiteUsed(int specialiteId) {
        String sql = "SELECT COUNT(*) as count FROM user WHERE specialite_id = ? AND role = 'MEDECIN'";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, specialiteId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt("count");
                    System.out.println("Spécialité #" + specialiteId + " utilisée par " + count + " médecin(s)");
                    return count > 0;
                }
            }
            
        } catch (SQLException e) {
            System.err.println("ERREUR isSpecialiteUsed(): " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
}