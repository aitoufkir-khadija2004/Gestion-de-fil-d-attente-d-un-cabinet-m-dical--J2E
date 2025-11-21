package dao;

import beans.Notification;
import java.util.List;

public interface NotificationDAO {
    boolean creerNotification(Notification notification);
    Notification getNotificationById(int id);
    List<Notification> getNotificationsByPatient(int patientId);
    List<Notification> getNotificationsByTicket(int ticketId);
    List<Notification> getNotificationsEnAttente();
    boolean envoyerNotification(int notificationId);
    boolean marquerCommeEnvoyee(int notificationId);
    boolean marquerCommeEchec(int notificationId);
}