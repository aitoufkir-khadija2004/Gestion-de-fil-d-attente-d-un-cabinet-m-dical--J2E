package dao;

import beans.Consultation;
import java.util.List;

public interface ConsultationDAO {
    boolean creerConsultation(Consultation consultation);
    Consultation getConsultationById(int id);
    Consultation getConsultationByTicket(int ticketId);
    List<Consultation> getConsultationsByPatient(int patientId);
    List<Consultation> getConsultationsByMedecin(int medecinId);
    boolean updateConsultation(Consultation consultation);
    boolean terminerConsultation(int consultationId);
    boolean ajouterDiagnostic(int consultationId, String diagnostic);
    boolean ajouterPrescription(int consultationId, String prescription);
    List<Consultation> getConsultationsByMedecinId(int medecinId);
    int countConsultationsByPatientAndMedecin(int patientId, int medecinId);
    List<Consultation> getAllConsultations();




}