package dao;

import beans.Notification;
import com.JDBC.MYSQL.TestConnectionJDBC;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAOImpl implements NotificationDAO {
    
    @Override
    public boolean creerNotification(Notification notification) {
        String sql = "INSERT INTO notification (code_notification, ticket_id, patient_id, message, " +
                     "type, methode, statut) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            String codeNotification = genererCodeNotification();
            notification.setCodeNotification(codeNotification);
            
            ps.setString(1, codeNotification);
            ps.setInt(2, notification.getTicketId());
            ps.setInt(3, notification.getPatientId());
            ps.setString(4, notification.getMessage());
            ps.setString(5, notification.getType());
            ps.setString(6, notification.getMethode());
            ps.setString(7, notification.getStatut());
            
            int rows = ps.executeUpdate();
            
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    notification.setId(rs.getInt(1));
                }
                System.out.println("Notification créée : " + codeNotification);
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Erreur creerNotification : " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    @Override
    public Notification getNotificationById(int id) {
        String sql = "SELECT * FROM notification WHERE id = ?";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return createNotificationFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Erreur getNotificationById : " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    @Override
    public List<Notification> getNotificationsByPatient(int patientId) {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM notification WHERE patient_id = ? ORDER BY date_envoi DESC";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                notifications.add(createNotificationFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Erreur getNotificationsByPatient : " + e.getMessage());
            e.printStackTrace();
        }
        
        return notifications;
    }
    
    @Override
    public List<Notification> getNotificationsByTicket(int ticketId) {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM notification WHERE ticket_id = ? ORDER BY date_envoi DESC";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, ticketId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                notifications.add(createNotificationFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Erreur getNotificationsByTicket : " + e.getMessage());
            e.printStackTrace();
        }
        
        return notifications;
    }
    
    @Override
    public List<Notification> getNotificationsEnAttente() {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM notification WHERE statut = 'en_attente' ORDER BY date_envoi ASC";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                notifications.add(createNotificationFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Erreur getNotificationsEnAttente : " + e.getMessage());
            e.printStackTrace();
        }
        
        return notifications;
    }
    
    @Override
    public boolean envoyerNotification(int notificationId) {
        // Simuler l'envoi de notification
        System.out.println("Envoi de la notification ID : " + notificationId);
        
        // Marquer comme envoyée
        return marquerCommeEnvoyee(notificationId);
    }
    
    @Override
    public boolean marquerCommeEnvoyee(int notificationId) {
        String sql = "UPDATE notification SET statut = 'envoye', date_reception = NOW() WHERE id = ?";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, notificationId);
            int rows = ps.executeUpdate();
            
            if (rows > 0) {
                System.out.println("Notification marquée comme envoyée : " + notificationId);
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Erreur marquerCommeEnvoyee : " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    @Override
    public boolean marquerCommeEchec(int notificationId) {
        String sql = "UPDATE notification SET statut = 'echec', tentatives = tentatives + 1 WHERE id = ?";
        
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, notificationId);
            int rows = ps.executeUpdate();
            
            if (rows > 0) {
                System.out.println("Notification marquée comme échec : " + notificationId);
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Erreur marquerCommeEchec : " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    private Notification createNotificationFromResultSet(ResultSet rs) throws SQLException {
        Notification notification = new Notification();
        notification.setId(rs.getInt("id"));
        notification.setCodeNotification(rs.getString("code_notification"));
        notification.setTicketId(rs.getInt("ticket_id"));
        notification.setPatientId(rs.getInt("patient_id"));
        notification.setMessage(rs.getString("message"));
        notification.setType(rs.getString("type"));
        notification.setMethode(rs.getString("methode"));
        notification.setStatut(rs.getString("statut"));
        notification.setDateEnvoi(rs.getTimestamp("date_envoi"));
        notification.setDateReception(rs.getTimestamp("date_reception"));
        notification.setTentatives(rs.getInt("tentatives"));
        return notification;
    }
    
    private String genererCodeNotification() {
        String sql = "SELECT COUNT(*) AS count FROM notification WHERE DATE(date_envoi) = CURDATE()";
        try (Connection conn = TestConnectionJDBC.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int count = rs.getInt("count") + 1;
                return String.format("NOT-%s-%04d", 
                    new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date()), 
                    count);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "NOT-" + new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date()) + "-0001";
    }
}