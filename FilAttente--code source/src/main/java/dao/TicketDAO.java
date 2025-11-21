package dao;

import beans.Ticket;
import java.util.List;

public interface TicketDAO {
    boolean creerTicket(Ticket ticket);
    Ticket getTicketById(int id);
    List<Ticket> getTicketsByPatient(int patientId);
    List<Ticket> getTicketsByMedecin(int medecinId);
    List<Ticket> getTicketsEnAttente(int medecinId);
    boolean updateStatut(int ticketId, String statut);
    boolean annulerTicket(int ticketId);
    String genererNumeroTicket();
	List<Ticket> getAllTickets();
	List<Ticket> getTicketsByMedecinStatut(int medecinId, String statut);
    boolean patientADejaReserveCreneau(int patientId, int creneauId);

}